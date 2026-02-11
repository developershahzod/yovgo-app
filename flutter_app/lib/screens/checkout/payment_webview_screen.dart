import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../l10n/language_provider.dart';
import 'payment_webview_web.dart' if (dart.library.io) 'payment_webview_stub.dart' as platform;

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String? subscriptionId;

  const PaymentWebViewScreen({
    Key? key,
    required this.paymentUrl,
    this.subscriptionId,
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  bool _isLoading = true;
  late String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'payment-iframe-${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb) {
      platform.registerIframe(_viewId, widget.paymentUrl, () {
        if (mounted) setState(() => _isLoading = false);
      });
    } else {
      // On iOS/Android, open in external browser and go back
      _openExternal();
    }
  }

  Future<void> _openExternal() async {
    final uri = Uri.parse(widget.paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    if (mounted) Navigator.pop(context, 'opened_external');
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryCyan),
              const SizedBox(height: 16),
              Text(context.tr('payment'), style: const TextStyle(fontSize: 16, fontFamily: 'Mulish')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF0A0C13)),
          onPressed: () => _showCloseConfirmation(),
        ),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Color(0xFF5CCC27)),
            const SizedBox(width: 6),
            Text(
              context.tr('payment'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish',
                color: Color(0xFF0A0C13),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: HtmlElementView(viewType: _viewId),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryCyan),
            ),
        ],
      ),
    );
  }

  void _showCloseConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr('payment_cancel_title'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Mulish'),
        ),
        content: Text(
          context.tr('payment_cancel_desc'),
          style: const TextStyle(fontSize: 14, fontFamily: 'Mulish', color: Color(0xFF8F96A0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr('cancel'), style: const TextStyle(color: Color(0xFF8F96A0), fontWeight: FontWeight.w600, fontFamily: 'Mulish')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'cancelled');
            },
            child: Text(context.tr('close'), style: const TextStyle(color: Color(0xFFFC3E3E), fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ],
      ),
    );
  }
}
