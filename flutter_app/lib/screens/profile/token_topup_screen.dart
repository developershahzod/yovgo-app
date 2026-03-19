import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/language_provider.dart';
import '../../services/full_api_service.dart';
import '../checkout/payment_webview_screen.dart';

class TokenTopupScreen extends StatefulWidget {
  const TokenTopupScreen({super.key});

  @override
  State<TokenTopupScreen> createState() => _TokenTopupScreenState();
}

class _TokenTopupScreenState extends State<TokenTopupScreen> {
  List<dynamic> _packages = [];
  int? _selectedIdx;
  bool _loading = true;
  bool _processing = false;
  final TextEditingController _customAmountCtrl = TextEditingController();
  bool _useCustomAmount = false;

  @override
  void initState() {
    super.initState();
    _loadPackages();
    _customAmountCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadPackages() async {
    final pkgs = await FullApiService.getTokenPackages();
    if (mounted) setState(() { _packages = pkgs; _loading = false; });
  }

  String _fmt(dynamic n) {
    final val = (n is num) ? n.toInt() : (int.tryParse(n?.toString() ?? '0') ?? 0);
    final s = val.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]); c++;
      if (c % 3 == 0 && i > 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }

  @override
  void dispose() {
    _customAmountCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPurchase() async {
    if (_processing) return;
    int tokens;
    int amountUzs;
    if (_useCustomAmount) {
      final val = int.tryParse(_customAmountCtrl.text.replaceAll(' ', '').trim()) ?? 0;
      if (val <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('tokens_custom_hint')), backgroundColor: Colors.red),
        );
        return;
      }
      tokens = val;
      amountUzs = val; // 1 token = 1 UZS
    } else {
      if (_selectedIdx == null) return;
      final pkg = _packages[_selectedIdx!] as Map<String, dynamic>;
      tokens = pkg['tokens'] as int;
      amountUzs = pkg['price_uzs'] as int;
    }

    setState(() => _processing = true);
    try {
      // Step 1: Create pending token top-up order
      final order = await FullApiService.createTokenTopup(tokens: tokens);
      final transactionId = order['transaction_id']?.toString() ?? '';
      final orderId = order['order_id']?.toString() ?? '';

      // Step 2: Create IpakYuli payment
      final ipakResult = await FullApiService.createIpakYuliPaymentDirect(
        orderId: orderId,
        amount: amountUzs,
        paymentId: transactionId,
      );
      final paymentUrl = ipakResult['payment_url']?.toString();
      final transferId = ipakResult['transfer_id']?.toString() ?? '';

      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentWebViewScreen(
                paymentUrl: paymentUrl,
                subscriptionId: transactionId,
              ),
            ),
          );
        }
      }

      // Step 3: Confirm top-up after payment (poll IpakYuli status)
      await _confirmAfterPayment(transactionId: transactionId, transferId: transferId, tokens: tokens);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _confirmAfterPayment({
    required String transactionId,
    required String transferId,
    required int tokens,
  }) async {
    // Poll IpakYuli payment status up to 6 times
    for (int i = 0; i < 6; i++) {
      if (!mounted) return;
      try {
        final status = await FullApiService.checkIpakYuliPaymentDirect(
          transferId: transferId,
          paymentId: transactionId,
        );
        if (status == 'success') {
          // Confirm top-up on backend
          await FullApiService.confirmTokenTopup(
            transactionId: transactionId,
            transferId: transferId,
          );
          if (mounted) _showSuccess(tokens);
          return;
        }
        if (status == 'failed' || status == 'cancelled' || status == 'expired') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tr('tokens_cancelled')), backgroundColor: Colors.red),
            );
          }
          return;
        }
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 3));
    }
    // If couldn't confirm automatically, try direct confirm anyway
    try {
      await FullApiService.confirmTokenTopup(transactionId: transactionId, transferId: transferId);
      if (mounted) _showSuccess(tokens);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('payment_pending')), backgroundColor: Colors.orange),
        );
      }
    }
  }

  void _showSuccess(int tokens) {
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
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: const Color(0xFFFFD600).withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.toll, size: 44, color: Color(0xFFFFD600)),
              ),
              const SizedBox(height: 20),
              Text(context.tr('tokens_topup_success'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
              const SizedBox(height: 8),
              Text('+$tokens tokens qo\'shildi!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF22C55E), fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD600),
                    foregroundColor: const Color(0xFF0A0C13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr('tokens_topup_title'),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF0A0C13), fontFamily: 'Mulish'),
          ),
          centerTitle: true,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFD600)))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rate info banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD600).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFFFD600).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Color(0xFFFFAA00), size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  context.tr('tokens_rate'),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            context.tr('tokens_select_package'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                          ),
                          const SizedBox(height: 14),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.35,
                            ),
                            itemCount: _packages.length,
                            itemBuilder: (ctx, i) => _buildPackageCard(i, _packages[i] as Map<String, dynamic>),
                          ),
                          const SizedBox(height: 20),
                          // Custom amount section
                          GestureDetector(
                            onTap: () => setState(() {
                              _useCustomAmount = !_useCustomAmount;
                              if (_useCustomAmount) _selectedIdx = null;
                            }),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    color: _useCustomAmount ? const Color(0xFF0A0C13) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: _useCustomAmount ? const Color(0xFFFFD600) : const Color(0xFFCCCCCC),
                                      width: 2,
                                    ),
                                  ),
                                  child: _useCustomAmount
                                      ? const Icon(Icons.check, size: 13, color: Color(0xFFFFD600))
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  context.tr('tokens_custom_amount'),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                                ),
                              ],
                            ),
                          ),
                          if (_useCustomAmount) ...[
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                    child: Icon(Icons.toll, color: Color(0xFFFFAA00), size: 20),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _customAmountCtrl,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
                                      decoration: InputDecoration(
                                        hintText: context.tr('tokens_custom_hint'),
                                        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'Mulish'),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 14),
                                    child: Text('token', style: TextStyle(fontSize: 13, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.tr('tokens_custom_rate'),
                              style: const TextStyle(fontSize: 12, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            context.tr('tokens_topup_desc'),
                            style: const TextStyle(fontSize: 13, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildPackageCard(int idx, Map<String, dynamic> pkg) {
    final tokens = pkg['tokens'] as int;
    final priceUzs = pkg['price_uzs'] as int;
    final bonus = (pkg['bonus'] as int?) ?? 0;
    final popular = pkg['popular'] as bool? ?? false;
    final isSelected = _selectedIdx == idx;

    return GestureDetector(
      onTap: () => setState(() => _selectedIdx = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A0C13) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD600) : const Color(0xFFE8E8E8),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFFFFD600).withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.toll, color: isSelected ? const Color(0xFFFFD600) : const Color(0xFFFFAA00), size: 18),
                const Spacer(),
                if (popular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD600),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(context.tr('tokens_popular'),
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF0A0C13), fontFamily: 'Mulish')),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$tokens',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : const Color(0xFF0A0C13),
                fontFamily: 'Mulish',
              ),
            ),
            Text(
              'tokens',
              style: TextStyle(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.6) : const Color(0xFF8F96A0), fontFamily: 'Mulish'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_fmt(priceUzs)} so\'m',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFFFFD600) : const Color(0xFF0A0C13),
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
                if (bonus > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(isSelected ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+$bonus ${context.tr('tokens_bonus')}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF22C55E), fontFamily: 'Mulish'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    final canPay = _useCustomAmount
        ? (_customAmountCtrl.text.trim().isNotEmpty && (int.tryParse(_customAmountCtrl.text.replaceAll(' ', '').trim()) ?? 0) > 0)
        : _selectedIdx != null;
    final pkg = (!_useCustomAmount && _selectedIdx != null) ? _packages[_selectedIdx!] as Map<String, dynamic> : null;
    final customTokens = _useCustomAmount ? (int.tryParse(_customAmountCtrl.text.replaceAll(' ', '').trim()) ?? 0) : 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pkg != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${pkg['tokens']} tokens', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                  Text('${_fmt(pkg['price_uzs'])} so\'m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                ],
              ),
              const SizedBox(height: 10),
            ],
            if (_useCustomAmount && customTokens > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$customTokens tokens', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                  Text('${_fmt(customTokens)} so\'m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
                ],
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: canPay && !_processing ? _processPurchase : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD600),
                  foregroundColor: const Color(0xFF0A0C13),
                  disabledBackgroundColor: const Color(0xFFE8E8E8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _processing
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A0C13)))
                    : Text(
                        context.tr('tokens_buy_btn'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
