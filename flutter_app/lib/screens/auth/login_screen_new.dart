import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/full_api_service.dart';

class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({Key? key}) : super(key: key);

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  final _phoneController = TextEditingController(text: '+998');
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _codeSent = false;
  int _resendSeconds = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 13) {
      setState(() => _error = 'Telefon raqamni to\'liq kiriting');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.sendCode(phone);
      if (mounted) {
        setState(() => _codeSent = true);
        _startResendTimer();
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      setState(() => _error = detail?.toString() ?? 'Xatolik yuz berdi');
    } catch (e) {
      setState(() => _error = 'Tarmoq xatosi');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    if (code.length < 5) {
      setState(() => _error = 'Kodni to\'liq kiriting');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await FullApiService.verifyCode(
        phoneNumber: phone,
        code: code,
      );
      if (mounted) {
        if (result['is_new_user'] == true) {
          Navigator.pushReplacementNamed(context, '/register', arguments: {'phone': phone, 'token': result['access_token']});
        } else {
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      setState(() => _error = detail?.toString() ?? 'Kod noto\'g\'ri');
    } catch (e) {
      setState(() => _error = 'Tarmoq xatosi');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: canGoBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)),
                onPressed: () {
                  if (_codeSent) {
                    setState(() { _codeSent = false; _error = null; _codeController.clear(); });
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            : _codeSent
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)),
                    onPressed: () => setState(() { _codeSent = false; _error = null; _codeController.clear(); }),
                  )
                : null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _codeSent ? _buildCodeStep() : _buildPhoneStep(canGoBack),
        ),
      ),
    );
  }

  Widget _buildPhoneStep(bool canGoBack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Logo.png', height: 32, fit: BoxFit.contain,
          errorBuilder: (c, e, s) => Row(children: [
            Text('YUV', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF00BFFE), fontFamily: 'Mulish')),
            Text('GO', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0A0C13), fontFamily: 'Mulish')),
          ]),
        ),
        const SizedBox(height: 40),
        const Text(
          'Tizimga kirish',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
        ),
        const SizedBox(height: 8),
        Text(
          'Telefon raqamingizni kiriting',
          style: TextStyle(fontSize: 15, color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
        ),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
            decoration: InputDecoration(
              labelText: 'Telefon raqam',
              labelStyle: TextStyle(color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
              prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF8F96A0)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0C13),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Kod yuborish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Akkauntingiz yo\'qmi? ', style: TextStyle(fontSize: 14, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/register'),
              child: const Text(
                'Ro\'yxatdan o\'tish',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00BFFE), fontFamily: 'Mulish'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: TextButton(
            onPressed: () {
              if (canGoBack) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/main');
              }
            },
            child: Text('Keyinroq', style: TextStyle(fontSize: 14, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCodeStep() {
    final phone = _phoneController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Logo.png', height: 32, fit: BoxFit.contain,
          errorBuilder: (c, e, s) => Row(children: [
            Text('YUV', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF00BFFE), fontFamily: 'Mulish')),
            Text('GO', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0A0C13), fontFamily: 'Mulish')),
          ]),
        ),
        const SizedBox(height: 40),
        const Text(
          'Kodni kiriting',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
        ),
        const SizedBox(height: 8),
        Text(
          '$phone raqamiga kod yuborildi',
          style: TextStyle(fontSize: 15, color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
        ),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 5,
            autofocus: true,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Mulish', letterSpacing: 8),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              hintText: '•••••',
              hintStyle: TextStyle(fontSize: 24, color: const Color(0xFFCCCCCC), letterSpacing: 8),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: _resendSeconds > 0
              ? Text('Qayta yuborish: $_resendSeconds s', style: TextStyle(fontSize: 14, color: const Color(0xFF8F96A0), fontFamily: 'Mulish'))
              : GestureDetector(
                  onTap: _isLoading ? null : _sendCode,
                  child: const Text('Kodni qayta yuborish', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0C13),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Tasdiqlash', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14, fontFamily: 'Mulish'))),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
