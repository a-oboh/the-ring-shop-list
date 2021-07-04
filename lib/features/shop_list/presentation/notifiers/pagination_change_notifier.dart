import 'package:flutter/material.dart';

class PaginationChangeNotifier extends ChangeNotifier {
  bool _hasMore = false;
  int _totalPages = 1;
  int _currentPage = 1;
  int offset = 0;

  // bool hasMore;
  // int totalPages;
  // int currentPage;

  bool get hasMore => _hasMore;
  int get totalPages => _totalPages;
  int get currentPage => _currentPage;

  setHasMore(bool value) {
    _hasMore = value;
    notifyListeners();
  }

  setTotalPages(int pages) {
    _totalPages = pages;
    notifyListeners();
  }

  setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  incrementOffset(int value) {
    offset = offset + value;
    notifyListeners();
  }
}
