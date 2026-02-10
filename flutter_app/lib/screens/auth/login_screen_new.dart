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
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      setState(() => _error = 'Telefon raqamni kiriting');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.login(phone);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      if (detail == 'User not found') {
        setState(() => _error = 'Foydalanuvchi topilmadi. Ro\'yxatdan o\'ting.');
      } else {
        setState(() => _error = detail?.toString() ?? 'Xatolik yuz berdi');
      }
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
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Logo
              Row(
                children: [
                  Text('YUV', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF00BFFE), fontFamily: 'Mulish')),
                  Text('GO', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0A0C13), fontFamily: 'Mulish')),
                ],
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
              // Error
              if (_error != null) ...[
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
              // Phone field
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
              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0C13),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Kirish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 20),
              // Register link
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
              // Skip for now
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
          ),
        ),
      ),
    );
  }
}
