import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({Key? key}) : super(key: key);

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  final List<Map<String, dynamic>> _cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mening kartalarim',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _cards.isEmpty ? _buildEmptyState() : _buildCardsList(),
      bottomNavigationBar: _buildAddButton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 48,
              color: AppTheme.primaryCyan,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Kartalar mavjud emas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Kartalarni qo\'shish uchun pastdagi "Qo\'shish" tugmasini bosing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return _buildCardItem(card);
      },
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderGray),
      ),
      child: Row(
        children: [
          _getCardIcon(card['type']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card['number']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (card['isPrimary'] == true)
                  Text(
                    'Asosiy karta',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryCyan,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppTheme.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _getCardIcon(String type) {
    switch (type) {
      case 'uzcard':
        return Container(
          width: 48,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              'U',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      case 'mastercard':
        return Container(
          width: 48,
          height: 32,
          child: Icon(Icons.credit_card, color: Colors.orange),
        );
      case 'visa':
        return Container(
          width: 48,
          height: 32,
          child: Text(
            'VISA',
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      default:
        return Icon(Icons.credit_card, size: 32);
    }
  }

  Widget _buildAddButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              _showAddCardDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Qo\'shish',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.add, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Karta qo\'shish'),
        content: Text('Karta qo\'shish funksiyasi tez orada qo\'shiladi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tushundim',
              style: TextStyle(color: AppTheme.primaryCyan),
            ),
          ),
        ],
      ),
    );
  }
}
