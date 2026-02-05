import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;

  final List<SearchHistoryItem> _history = [
    SearchHistoryItem(query: 'bla bla car wash', time: 'O\'chirish'),
  ];

  final List<SearchSuggestion> _suggestions = [
    SearchSuggestion(query: 'black star'),
    SearchSuggestion(query: 'black jack moyka'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Stack(
        children: [
          Container(
            height: 200,
            color: AppTheme.lightGray.withOpacity(0.3),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryCyan,
                              width: 2,
                            ),
                            boxShadow: [AppTheme.cardShadow],
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                _showResults = value.isNotEmpty;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Bla',
                              prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.close, color: AppTheme.textSecondary),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _showResults = false;
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.close, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _showResults ? _buildSearchResults() : _buildSearchHistory(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._history.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(Icons.history, color: AppTheme.textTertiary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.query,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._suggestions.map((item) => GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.textTertiary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.query,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppTheme.textTertiary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class SearchHistoryItem {
  final String query;
  final String time;

  SearchHistoryItem({required this.query, required this.time});
}

class SearchSuggestion {
  final String query;

  SearchSuggestion({required this.query});
}
