import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';
import 'payment_webview_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // 'payment_systems', 'card', 'installment'
  String _selectedPaymentMethod = 'card';
  int _installmentMonths = 12;
  final TextEditingController _promoController = TextEditingController();
  bool _isProcessing = false;
  bool _promoError = false;
  Map<String, dynamic>? _plan;
  DateTime _activationDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && _plan == null) {
      _plan = args;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _fmt(dynamic price) {
    final p = (price is int) ? price : (price is double) ? price.toInt() : (int.tryParse(price.toString().split('.').first) ?? 0);
    final str = p.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buf.write(str[i]);
      c++;
      if (c % 3 == 0 && i > 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  String _dateStr(DateTime dt) {
    final months = ['yanvar','fevral','mart','aprel','may','iyun','iyul','avgust','sentabr','oktabr','noyabr','dekabr'];
    return '${dt.day}-${months[dt.month - 1]}, ${dt.year}';
  }

  String _getErrorMessage(dynamic e) {
    String msg = e.toString();
    if (msg.contains('already have an active subscription') || msg.contains('already has active')) {
      return context.tr('already_active_sub');
    }
    if (msg.contains('Not authenticated') || msg.contains('401')) {
      return context.tr('login_first');
    }
    if (msg.contains('Plan not found')) {
      return context.tr('plan_not_found');
    }
    if (msg.contains('Payment creation failed')) {
      return context.tr('payment_create_error');
    }
    msg = msg.replaceAll('Exception: ', '').replaceAll('DioException', 'Tarmoq xatosi');
    if (msg.length > 100) msg = msg.substring(0, 100);
    return msg;
  }

  Future<void> _processPayment() async {
    if (_isProcessing || _plan == null) return;
    setState(() => _isProcessing = true);
    try {
      // Step 1: Create subscription (or get existing active one)
      final subResult = await FullApiService.createSubscription(
        planId: _plan!['id'].toString(),
        autoRenew: false,
      );
      
      // If user already has active subscription, show success
      if (subResult['already_active'] == true) {
        if (mounted) _showSuccessDialog();
        return;
      }
      
      final subscriptionId = subResult['id']?.toString() ?? subResult['subscription_id']?.toString();
      if (subscriptionId == null) throw Exception(context.tr('sub_create_error'));

      // Step 2: Create payment record via backend (returns order_id, payment_id)
      final price = _plan!['price'] ?? 0;
      final amount = double.tryParse(price.toString()) ?? 0.0;
      final paymentResult = await FullApiService.createMobilePayment(
        subscriptionId: subscriptionId,
        planId: _plan!['id'].toString(),
        amount: amount,
      );
      final paymentId = paymentResult['payment_id']?.toString() ?? '';
      final orderId = paymentResult['order_id']?.toString() ?? '';

      // Step 3: Call IpakYuli directly from Flutter to get payment URL
      try {
        final ipakResult = await FullApiService.createIpakYuliPaymentDirect(
          orderId: orderId,
          amount: amount.toInt(),
          paymentId: paymentId,
        );
        final paymentUrl = ipakResult['payment_url']?.toString();
        final transferId = ipakResult['transfer_id']?.toString() ?? '';
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          if (mounted) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentWebViewScreen(
                  paymentUrl: paymentUrl,
                  subscriptionId: subscriptionId,
                ),
              ),
            );
            if (mounted) {
              await _checkSubscriptionActivated(subscriptionId, transferId: transferId, paymentId: paymentId);
            }
          }
        } else {
          if (mounted) await _checkSubscriptionActivated(subscriptionId, transferId: transferId, paymentId: paymentId);
        }
      } catch (paymentError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('To\'lov yaratishda xatolik: ${paymentError.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _checkSubscriptionActivated(String subscriptionId, {String transferId = '', String paymentId = ''}) async {
    // Step 1: If we have transferId, check IpakYuli directly and activate via backend
    if (transferId.isNotEmpty && paymentId.isNotEmpty) {
      for (int i = 0; i < 6; i++) {
        if (!mounted) return;
        try {
          final status = await FullApiService.checkIpakYuliPaymentDirect(
            transferId: transferId,
            paymentId: paymentId,
          );
          if (status == 'success') {
            // Give backend a moment to activate subscription
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) _showSuccessDialog();
            return;
          }
          if (status == 'failed' || status == 'cancelled' || status == 'expired') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('payment_failed')), backgroundColor: Colors.red),
              );
            }
            return;
          }
        } catch (_) {}
        await Future.delayed(const Duration(seconds: 3));
      }
    }

    // Step 2: Fallback — poll subscription status from backend
    for (int i = 0; i < 5; i++) {
      if (!mounted) return;
      try {
        final sub = await FullApiService.getSubscriptionStatus();
        final subData = sub['subscription'] as Map<String, dynamic>?;
        if (subData != null && subData['status'] == 'active') {
          if (mounted) _showSuccessDialog();
          return;
        }
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 2));
    }
    // If not activated after polling, show pending dialog
    if (mounted) _showPaymentPendingDialog();
  }

  @override
  Widget build(BuildContext context) {
    final planName = _plan?['name'] ?? '${_plan?['duration_days'] ?? 365} kunlik';
    final price = _plan?['price'] ?? 10800000;
    final oldPrice = _plan?['old_price'] ?? 18000000;
    final discount = _plan?['discount'] ?? 40;
    final discountAmount = (oldPrice is num && price is num) ? (oldPrice - price).toInt() : 0;
    final installmentPrice = price is num ? (price / _installmentMonths).round() : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)), onPressed: () => Navigator.pop(context)),
        title: Text(context.tr('checkout_buy_sub'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Plan Card ───
            _buildPlanCard(planName, price, oldPrice, discount),

            // ─── Activation Date ───
            _buildSection(context.tr('activation_date'), _buildDateField()),

            // ─── Promo Code ───
            _buildSection(context.tr('promo_code'), _buildPromoField()),

            // ─── Payment Info ───
            _buildSection(context.tr('payment_method'), _buildPaymentInfo()),

            // ─── Narxi ───
            _buildSection(context.tr('price'), _buildPriceBreakdown(oldPrice, discountAmount, price, installmentPrice)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // ─── Plan Card ───
  Widget _buildPlanCard(String name, dynamic price, dynamic oldPrice, dynamic discount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              // Plan image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png',
                  width: 56, height: 56, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: const Color(0xFF00BFFE).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.workspace_premium, color: Color(0xFF00BFFE), size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (oldPrice != null && oldPrice != price)
                          Text(
                            '${_fmt(oldPrice)} so\'m',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF8F96A0), decoration: TextDecoration.lineThrough, fontFamily: 'Mulish'),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        if (discount != null && discount > 0)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFF00BFFE), borderRadius: BorderRadius.circular(6)),
                            child: Text('-$discount%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Mulish')),
                          ),
                        Text('${_fmt(price)} so\'m', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh, size: 14, color: const Color(0xFF8F96A0)),
              const SizedBox(width: 4),
              Text(context.tr('sub_renewable'), style: TextStyle(fontSize: 12, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }

  // ─── Section wrapper ───
  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 20, endIndent: 20),
      ],
    );
  }

  // ─── Date Field ───
  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _activationDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) setState(() => _activationDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr('activation_date'), style: TextStyle(fontSize: 12, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_dateStr(_activationDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF0A0C13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Promo Field ───
  Widget _buildPromoField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _promoError ? const Color(0xFFFC3E3E) : (_promoController.text.isNotEmpty ? const Color(0xFF00BFFE) : const Color(0xFFE8E8E8))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _promoController.text.isNotEmpty ? context.tr('promo_enter') : context.tr('promo_have'),
            style: TextStyle(fontSize: 12, color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  onChanged: (_) => setState(() => _promoError = false),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                  decoration: InputDecoration(
                    hintText: context.tr('promo_enter'),
                    hintStyle: TextStyle(fontSize: 15, color: const Color(0xFFCCCCCC), fontFamily: 'Mulish', fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_promoController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    // Apply promo - for now show error as demo
                    setState(() => _promoError = true);
                  },
                  child: _promoError
                      ? const Icon(Icons.close, size: 20, color: Color(0xFFFC3E3E))
                      : Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0A0C13), width: 1.5)),
                          child: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF0A0C13)),
                        ),
                ),
            ],
          ),
          if (_promoError) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.info, size: 14, color: const Color(0xFFFC3E3E)),
                const SizedBox(width: 4),
                Text(context.tr('promo_expired'), style: TextStyle(fontSize: 12, color: const Color(0xFFFC3E3E), fontFamily: 'Mulish')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── Payment Info (single method: Ipak Yo'li Bank) ───
  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00BFFE), width: 1.5),
        color: const Color(0xFF00BFFE).withOpacity(0.04),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00BFFE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.credit_card, color: Color(0xFF00BFFE), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('card_payment'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                const SizedBox(height: 2),
                Text(context.tr('card_types'), style: const TextStyle(fontSize: 13, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
              ],
            ),
          ),
          Container(
            width: 24, height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00BFFE),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  // ─── Price Breakdown ───
  Widget _buildPriceBreakdown(dynamic oldPrice, int discountAmount, dynamic price, int installmentPrice) {
    return Column(
      children: [
        _buildPriceLine(context.tr('sub_price'), '${_fmt(oldPrice)} ${context.tr('currency')}'),
        const SizedBox(height: 8),
        _buildPriceLine(context.tr('discount_label'), '${_fmt(discountAmount)} ${context.tr('currency')}', color: const Color(0xFF00BFFE)),
        const SizedBox(height: 8),
        _buildPriceLine(context.tr('amount'), '${_fmt(price)} ${context.tr('currency')}'),
        const SizedBox(height: 8),
        _buildPriceLine(context.tr('promo_code'), '0 ${context.tr('currency')}'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr('full_payment'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
            Text('${_fmt(price)} ${context.tr('currency')}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceLine(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Text(
                  '.' * (constraints.maxWidth ~/ 4),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0), letterSpacing: 1),
                );
              },
            ),
          ),
        ),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color ?? const Color(0xFF0A0C13), fontFamily: 'Mulish')),
      ],
    );
  }

  // ─── Bottom Button ───
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD600),
              foregroundColor: const Color(0xFF0A0C13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A0C13)))
                : Text(context.tr('make_payment'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ),
      ),
    );
  }

  // ─── Dialogs ───
  void _showPaymentPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.hourglass_top, size: 48, color: Colors.orange)),
              const SizedBox(height: 24),
              Text(context.tr('payment_pending'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(context.tr('payment_pending_desc'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0))),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pushNamedAndRemoveUntil('/main', (route) => false),
                child: const Text('OK'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFF5CCC27).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, size: 48, color: Color(0xFF5CCC27))),
              const SizedBox(height: 24),
              Text(context.tr('success_title'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(context.tr('sub_activated'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0))),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pushNamedAndRemoveUntil('/main', (route) => false),
                child: const Text('OK'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
