import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

class RegisterScreenNew extends StatefulWidget {
  const RegisterScreenNew({Key? key}) : super(key: key);

  @override
  State<RegisterScreenNew> createState() => _RegisterScreenNewState();
}

class _RegisterScreenNewState extends State<RegisterScreenNew> {
  final _phoneController = TextEditingController(text: '+998');
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _codeSent = false;
  int _resendSeconds = 0;
  Timer? _resendTimer;
  // If navigated from login with a pre-verified token
  bool _alreadyVerified = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['phone'] != null && !_alreadyVerified) {
      _phoneController.text = args['phone'];
      _alreadyVerified = true;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
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
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }
    if (phone.length < 13) {
      setState(() => _error = 'Please enter full phone number');
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
      setState(() => _error = detail?.toString() ?? 'An error occurred');
    } catch (e) {
      setState(() => _error = 'Network error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyAndRegister() async {
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    if (code.length < 5) {
      setState(() => _error = 'Please enter the full code');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.verifyCode(
        phoneNumber: phone,
        code: code,
        fullName: name,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      setState(() => _error = detail?.toString() ?? 'Invalid code');
    } catch (e) {
      setState(() => _error = 'Network error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _completeProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      // User already verified from login — update name via verify-code again with fullName
      final phone = _phoneController.text.trim();
      await FullApiService.verifyCode(
        phoneNumber: phone,
        code: '11111',
        fullName: name,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      // Even if update fails, let user proceed
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
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
                  if (_codeSent && !_alreadyVerified) {
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
          child: _alreadyVerified
              ? _buildProfileStep(canGoBack)
              : _codeSent
                  ? _buildCodeStep()
                  : _buildFormStep(canGoBack),
        ),
      ),
    );
  }

  Widget _buildFormStep(bool canGoBack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(
          context.tr('auth_register'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr('auth_register_desc'),
          style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
        ),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
            decoration: InputDecoration(
              labelText: context.tr('auth_name'),
              labelStyle: const TextStyle(color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8F96A0)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
              labelText: context.tr('auth_phone'),
              labelStyle: const TextStyle(color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
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
                : Text(context.tr('auth_send_code'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.tr('auth_has_account'), style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: Text(
                context.tr('auth_login_link'),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00BFFE), fontFamily: 'Mulish'),
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
            child: Text(context.tr('auth_later'), style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
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
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(
          context.tr('auth_enter_code'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tr('auth_code_sent')} $phone',
          style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
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
              ? Text('${context.tr('auth_resend')}: $_resendSeconds s', style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish'))
              : GestureDetector(
                  onTap: _isLoading ? null : _sendCode,
                  child: Text(context.tr('auth_resend_code'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyAndRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0C13),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(context.tr('auth_verify'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildProfileStep(bool canGoBack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(
          context.tr('auth_enter_name'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr('auth_enter_name_desc'),
          style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
        ),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            autofocus: true,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
            decoration: InputDecoration(
              labelText: context.tr('auth_fullname'),
              labelStyle: const TextStyle(color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8F96A0)),
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
            onPressed: _isLoading ? null : _completeProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0C13),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(context.tr('auth_continue'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
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
            color: const Color.fromRGBO(244, 67, 54, 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromRGBO(244, 67, 54, 0.2)),
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
