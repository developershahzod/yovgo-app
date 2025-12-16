#!/bin/bash

cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi/flutter_app

echo "Creating all missing screens..."

# Register Screen
cat > lib/screens/auth/register_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text('Создать аккаунт', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Заполните данные для регистрации', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Полное имя', prefixIcon: Icon(Icons.person)),
                  validator: (value) => value == null || value.isEmpty ? 'Введите имя' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Телефон', hintText: '+998901234567', prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Введите номер телефона' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Введите email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Пароль', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите пароль';
                    if (value.length < 6) return 'Пароль должен быть минимум 6 символов';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Зарегистрироваться'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Уже есть аккаунт? Войти'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
EOF

# Home Screen  
cat > lib/screens/home/home_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('YuvGo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Premium', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.star, color: Colors.amber),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Активный план', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text('Базовый', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                            child: const Text('АКТИВНО', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Осталось визитов', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  SizedBox(height: 8),
                                  Text('10', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Осталось дней', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  SizedBox(height: 8),
                                  Text('30', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/qr'),
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Сканировать QR код'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Быстрые действия', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildQuickAction(context, 'История визитов', Icons.history, Colors.purple, '/visits'),
                    _buildQuickAction(context, 'Карта', Icons.map, Colors.green, '/map'),
                    _buildQuickAction(context, 'Подписки', Icons.card_membership, Colors.orange, '/subscriptions'),
                    _buildQuickAction(context, 'Профиль', Icons.person, Colors.blue, '/profile'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
EOF

# Subscriptions Screen
cat > lib/screens/subscriptions/subscriptions_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подписки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Выберите план', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Подберите подходящий тариф', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            _buildPlanCard(context, 'Базовый', '50,000 UZS', '10 визитов в месяц', false),
            const SizedBox(height: 16),
            _buildPlanCard(context, 'Стандарт', '90,000 UZS', '20 визитов в месяц', false),
            const SizedBox(height: 16),
            _buildPlanCard(context, 'Премиум', '150,000 UZS', 'Безлимитные визиты', true),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String name, String price, String description, bool isPopular) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPopular ? Border.all(color: Colors.amber, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
              child: const Text('ПОПУЛЯРНЫЙ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 16),
          ],
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00BCD4))),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Оплата успешна!'), backgroundColor: Colors.green));
                Navigator.pop(context);
              },
              child: const Text('Выбрать план'),
            ),
          ),
        ],
      ),
    );
  }
}
EOF

# QR Scanner Screen
cat > lib/screens/qr/qr_scanner_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final _qrController = TextEditingController();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Сканер')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              const Text('Введите QR код вручную', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _qrController,
                decoration: InputDecoration(
                  hintText: 'MERCHANT_123_456789',
                  prefixIcon: const Icon(Icons.qr_code),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _handleScan,
                  child: _isScanning ? const CircularProgressIndicator(color: Colors.white) : const Text('Зарегистрировать визит'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScan() async {
    if (_qrController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите QR код')));
      return;
    }
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Регистрация успешна!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }
}
EOF

echo "✅ All screens created!"
ls -R lib/screens/
EOF

chmod +x create_all_missing_screens.sh
./create_all_missing_screens.sh
