import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/full_api_service.dart';

class RegisterScreenNew extends StatefulWidget {
  const RegisterScreenNew({Key? key}) : super(key: key);

  @override
  State<RegisterScreenNew> createState() => _RegisterScreenNewState();
}

class _RegisterScreenNewState extends State<RegisterScreenNew> {
  final _phoneController = TextEditingController(text: '+998');
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Ismingizni kiriting');
      return;
    }
    if (phone.length < 9) {
      setState(() => _error = 'Telefon raqamni kiriting');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await FullApiService.register(phoneNumber: phone, fullName: name);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'];
      if (detail == 'Phone number already registered') {
        setState(() => _error = 'Bu raqam allaqachon ro\'yxatdan o\'tgan. Tizimga kiring.');
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
              Row(
                children: [
                  Text('YUV', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF00BFFE), fontFamily: 'Mulish')),
                  Text('GO', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0A0C13), fontFamily: 'Mulish')),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Ro\'yxatdan o\'tish',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Mulish', color: Color(0xFF0A0C13)),
              ),
              const SizedBox(height: 8),
              Text(
                'Ma\'lumotlaringizni kiriting',
                style: TextStyle(fontSize: 15, color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
              ),
              const SizedBox(height: 32),
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
              // Name field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8ECF0)),
                ),
                child: TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
                  decoration: InputDecoration(
                    labelText: 'Ism va familiya',
                    labelStyle: TextStyle(color: const Color(0xFF8F96A0), fontFamily: 'Mulish'),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8F96A0)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              // Register button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0C13),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Ro\'yxatdan o\'tish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mulish')),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Akkauntingiz bormi? ', style: TextStyle(fontSize: 14, color: const Color(0xFF8F96A0), fontFamily: 'Mulish')),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Tizimga kirish',
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
