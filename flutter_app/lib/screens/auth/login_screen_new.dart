import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../services/full_api_service.dart';
import '../../l10n/language_provider.dart';

/// Unified auth screen — handles both login and registration in one flow:
///   Step 1: Enter phone number → send SMS code
///   Step 2: Enter SMS code → verify
///   Step 3: Enter name (only shown for NEW users)
///   → navigate to /main
class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({Key? key}) : super(key: key);

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

enum _AuthStep { phone, code, name }

class _LoginScreenNewState extends State<LoginScreenNew> {
  final _phoneController = TextEditingController(text: '+998');
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  _AuthStep _step = _AuthStep.phone;
  bool _isLoading = false;
  String? _error;
  int _resendSeconds = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  void _goBack() {
    setState(() {
      _error = null;
      if (_step == _AuthStep.code) {
        _step = _AuthStep.phone;
        _codeController.clear();
      } else if (_step == _AuthStep.name) {
        _step = _AuthStep.code;
        _nameController.clear();
      }
    });
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 13) {
      setState(() => _error = context.tr('auth_phone_short'));
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.sendCode(phone);
      if (mounted) {
        setState(() => _step = _AuthStep.code);
        _startResendTimer();
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      if (mounted) setState(() => _error = detail?.toString() ?? context.tr('auth_error_occurred'));
    } catch (_) {
      if (mounted) setState(() => _error = context.tr('auth_error_network'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    if (code.length < 5) {
      setState(() => _error = context.tr('auth_code_short'));
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await FullApiService.verifyCode(
        phoneNumber: phone,
        code: code,
      );
      if (!mounted) return;
      await FullApiService.savePhone(phone);
      final isNew = result['is_new_user'] == true;
      final hasName = (result['user']?['full_name']?.toString() ?? '').trim().isNotEmpty;
      if (isNew || !hasName) {
        // New user or missing name — collect name before proceeding
        setState(() { _step = _AuthStep.name; _isLoading = false; });
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      if (mounted) setState(() => _error = detail?.toString() ?? context.tr('auth_invalid_code'));
    } catch (_) {
      if (mounted) setState(() => _error = context.tr('auth_error_network'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = context.tr('auth_name_required'));
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.updateMyProfile(fullName: name);
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      if (mounted) setState(() => _error = detail?.toString() ?? context.tr('auth_error_occurred'));
    } catch (_) {
      if (mounted) setState(() => _error = context.tr('auth_error_network'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final showBack = _step != _AuthStep.phone || canGoBack;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0A0C13)),
                onPressed: _step != _AuthStep.phone ? _goBack : () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _step == _AuthStep.phone
              ? _buildPhoneStep(canGoBack)
              : _step == _AuthStep.code
                  ? _buildCodeStep()
                  : _buildNameStep(),
        ),
      ),
    );
  }
  // ─── Step 1: Phone ────────────────────────────────────────────────────────
  Widget _buildPhoneStep(bool canGoBack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(context.tr('auth_login'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        const SizedBox(height: 8),
        Text(context.tr('auth_login_desc'),
            style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        _buildField(
          controller: _phoneController,
          label: context.tr('auth_phone'),
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: context.tr('auth_send_code'),
          onPressed: _sendCode,
        ),
        const SizedBox(height: 40),
        Center(
          child: TextButton(
            onPressed: () => canGoBack
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, '/main'),
            child: Text(context.tr('auth_later'),
                style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ─── Step 2: SMS Code ─────────────────────────────────────────────────────
  Widget _buildCodeStep() {
    final phone = _phoneController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(context.tr('auth_enter_code'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        const SizedBox(height: 8),
        Text('${context.tr('auth_code_sent')} $phone',
            style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
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
            onChanged: (v) { if (v.length == 5) _verifyCode(); },
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Mulish', letterSpacing: 10),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              counterText: '',
              hintText: '•••••',
              hintStyle: TextStyle(fontSize: 28, color: Color(0xFFCCCCCC), letterSpacing: 10),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: _resendSeconds > 0
              ? Text('${context.tr('auth_resend')}: $_resendSeconds s',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF8F96A0), fontFamily: 'Mulish'))
              : GestureDetector(
                  onTap: _isLoading ? null : _sendCode,
                  child: Text(context.tr('auth_resend_code'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00BFFE), fontFamily: 'Mulish')),
                ),
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: context.tr('auth_verify'),
          onPressed: _verifyCode,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ─── Step 3: Name (new users only) ───────────────────────────────────────
  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/images/Light BG Default.png', height: 28, fit: BoxFit.contain),
        const SizedBox(height: 40),
        Text(context.tr('auth_enter_name'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13))),
        const SizedBox(height: 8),
        Text(context.tr('auth_enter_name_desc'),
            style: const TextStyle(fontSize: 15, color: Color(0xFF8F96A0), fontFamily: 'Mulish')),
        const SizedBox(height: 32),
        if (_error != null) _buildError(),
        _buildField(
          controller: _nameController,
          label: context.tr('auth_fullname'),
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          label: context.tr('auth_continue'),
          onPressed: _saveName,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ─── Shared widgets ───────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool autofocus = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8F96A0), fontFamily: 'Mulish'),
          prefixIcon: Icon(icon, color: const Color(0xFF8F96A0)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A0C13),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
      ),
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
