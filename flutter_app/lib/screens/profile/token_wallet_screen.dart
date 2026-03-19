import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../l10n/language_provider.dart';
import '../../services/full_api_service.dart';
import 'token_topup_screen.dart';

class TokenWalletScreen extends StatefulWidget {
  const TokenWalletScreen({super.key});

  @override
  State<TokenWalletScreen> createState() => _TokenWalletScreenState();
}

class _TokenWalletScreenState extends State<TokenWalletScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await FullApiService.getTokenBalance();
    if (mounted) setState(() { _data = data; _loading = false; });
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

  Color _txColor(String type) {
    if (type == 'topup' || type == 'refund' || type == 'admin_adjust') return const Color(0xFF22C55E);
    return const Color(0xFFFC3E3E);
  }

  String _txSign(String type) => (type == 'topup' || type == 'refund' || type == 'admin_adjust') ? '+' : '−';

  String _txTypeLabel(String type) {
    switch (type) {
      case 'topup': return context.tr('tokens_type_topup');
      case 'spend': return context.tr('tokens_type_spend');
      case 'refund': return context.tr('tokens_type_refund');
      case 'admin_adjust': return context.tr('tokens_type_admin');
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => Scaffold(
        backgroundColor: const Color(0xFF0A0C13),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0C13),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr('tokens_title'),
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Mulish'),
          ),
          centerTitle: true,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFD600)))
            : RefreshIndicator(
                onRefresh: _load,
                color: const Color(0xFFFFD600),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(),
                      const SizedBox(height: 20),
                      _buildTopupButton(),
                      const SizedBox(height: 28),
                      _buildHistory(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final balance = (_data?['balance'] ?? 0) as num;
    final balanceUzs = (_data?['balance_uzs'] ?? 0) as num;
    final earned = (_data?['total_earned'] ?? 0) as num;
    final spent = (_data?['total_spent'] ?? 0) as num;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFFFAA00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFFD600).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0C13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.toll, color: Color(0xFFFFD600), size: 14),
                      const SizedBox(width: 5),
                      Text('YuvGo Tokens', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  context.tr('tokens_rate'),
                  style: TextStyle(color: const Color(0xFF0A0C13).withOpacity(0.7), fontSize: 12, fontFamily: 'Mulish'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${_fmt(balance)} tokens',
              style: const TextStyle(color: Color(0xFF0A0C13), fontSize: 42, fontWeight: FontWeight.w900, fontFamily: 'Mulish'),
            ),
            const SizedBox(height: 4),
            Text(
              '≈ ${_fmt(balanceUzs)} so\'m',
              style: TextStyle(color: const Color(0xFF0A0C13).withOpacity(0.65), fontSize: 16, fontFamily: 'Mulish'),
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: const Color(0xFF0A0C13).withOpacity(0.15)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStat('↑', _fmt(earned), 'Jami kirim')),
                Container(width: 1, height: 36, color: const Color(0xFF0A0C13).withOpacity(0.15)),
                Expanded(child: _buildStat('↓', _fmt(spent), 'Jami chiqim')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String arrow, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(arrow, style: TextStyle(color: const Color(0xFF0A0C13).withOpacity(0.6), fontSize: 14)),
              const SizedBox(width: 4),
              Text('$value tkn', style: const TextStyle(color: Color(0xFF0A0C13), fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: const Color(0xFF0A0C13).withOpacity(0.6), fontSize: 11, fontFamily: 'Mulish')),
        ],
      ),
    );
  }

  Widget _buildTopupButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TokenTopupScreen()),
          );
          if (result == true) _load();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD600),
          foregroundColor: const Color(0xFF0A0C13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: Text(
          context.tr('tokens_topup'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    final txs = (_data?['transactions'] as List?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('tokens_history'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
        ),
        const SizedBox(height: 12),
        if (txs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, color: Colors.white.withOpacity(0.2), size: 56),
                  const SizedBox(height: 12),
                  Text(context.tr('tokens_no_history'), style: TextStyle(color: Colors.white.withOpacity(0.4), fontFamily: 'Mulish')),
                ],
              ),
            ),
          )
        else
          ...txs.map((t) => _buildTxItem(t as Map<String, dynamic>)).toList(),
      ],
    );
  }

  Widget _buildTxItem(Map<String, dynamic> t) {
    final type = t['type'] as String? ?? '';
    final amount = (t['amount'] as num?)?.abs() ?? 0;
    final desc = t['description'] as String? ?? '';
    final createdAt = t['created_at'] as String?;
    final color = _txColor(type);
    final sign = _txSign(type);

    String dateStr = '';
    if (createdAt != null) {
      try {
        final dt = DateTime.parse(createdAt).toLocal();
        dateStr = '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B26),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              type == 'topup' ? Icons.add : type == 'spend' ? Icons.shopping_bag_outlined : Icons.swap_horiz,
              color: color, size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_txTypeLabel(type), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12, fontFamily: 'Mulish'), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$sign${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 1)} tkn',
                  style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Mulish')),
              const SizedBox(height: 2),
              Text(dateStr, style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11, fontFamily: 'Mulish')),
            ],
          ),
        ],
      ),
    );
  }
}
