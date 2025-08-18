import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 20;

  // Get search history
  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_searchHistoryKey) ?? [];
      return historyJson.map((item) => jsonDecode(item) as String).toList();
    } catch (e) {
      print('Error getting search history: $e');
      return [];
    }
  }

  // Add search term to history
  Future<void> addSearchTerm(String searchTerm) async {
    try {
      if (searchTerm.trim().isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final history = await getSearchHistory();

      // Remove if already exists
      history.removeWhere((term) => term.toLowerCase() == searchTerm.toLowerCase());

      // Add to beginning
      history.insert(0, searchTerm.trim());

      // Keep only max items
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }

      // Save to preferences
      final historyJson = history.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      print('Error adding search term: $e');
    }
  }

  // Remove search term from history
  Future<void> removeSearchTerm(String searchTerm) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getSearchHistory();

      history.removeWhere((term) => term.toLowerCase() == searchTerm.toLowerCase());

      final historyJson = history.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      print('Error removing search term: $e');
    }
  }

  // Clear all search history
  Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }

  // Get search suggestions based on partial input
  Future<List<String>> getSearchSuggestions(String partialQuery) async {
    try {
      if (partialQuery.trim().isEmpty) return [];

      final history = await getSearchHistory();
      final suggestions = <String>[];

      for (final term in history) {
        if (term.toLowerCase().contains(partialQuery.toLowerCase())) {
          suggestions.add(term);
        }
      }

      // Also add some common suggestions
      final commonSuggestions = [
        'Chocolate',
        'Vanilla',
        'Strawberry',
        'Birthday',
        'Wedding',
        'Gluten Free',
        'Vegan',
        'Nut Free',
        'Cupcakes',
        'Cakes',
        'Cookies',
        'Brownies',
        'Muffins',
        'Donuts'
      ];

      for (final suggestion in commonSuggestions) {
        if (suggestion.toLowerCase().contains(partialQuery.toLowerCase()) &&
            !suggestions.contains(suggestion)) {
          suggestions.add(suggestion);
        }
      }

      return suggestions.take(10).toList();
    } catch (e) {
      print('Error getting search suggestions: $e');
      return [];
    }
  }

  // Get trending searches (based on frequency)
  Future<List<String>> getTrendingSearches() async {
    try {
      final history = await getSearchHistory();
      final frequencyMap = <String, int>{};

      for (final term in history) {
        frequencyMap[term] = (frequencyMap[term] ?? 0) + 1;
      }

      final sortedTerms = frequencyMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedTerms.take(5).map((e) => e.key).toList();
    } catch (e) {
      print('Error getting trending searches: $e');
      return [];
    }
  }

  // Get recent searches (last 5)
  Future<List<String>> getRecentSearches() async {
    try {
      final history = await getSearchHistory();
      return history.take(5).toList();
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  // Check if search term exists in history
  Future<bool> hasSearchTerm(String searchTerm) async {
    try {
      final history = await getSearchHistory();
      return history.any((term) => term.toLowerCase() == searchTerm.toLowerCase());
    } catch (e) {
      print('Error checking search term: $e');
      return false;
    }
  }

  // Get search history count
  Future<int> getSearchHistoryCount() async {
    try {
      final history = await getSearchHistory();
      return history.length;
    } catch (e) {
      print('Error getting search history count: $e');
      return 0;
    }
  }
}
