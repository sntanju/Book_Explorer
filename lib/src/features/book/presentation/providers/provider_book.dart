import 'package:flutter/material.dart';
import '../../data/interfaces/interface_book_repository.dart';
import '../../data/models/book_model.dart';

enum ViewState { idle, busy, error, loadingMore }

class ProviderBook with ChangeNotifier {
  final IBookRepository repository;
  ProviderBook(this.repository);

  List<BookModel> books = [];
  ViewState state = ViewState.idle;
  String error = '';
  int currentPage = 1;
  final int limit = 20;
  bool hasMore = true;
  bool isLoadingMore = false;
  String currentQuery = '';
  String currentSubject = '';

  // Filters
  String? filterAuthor;
  int? filterYear;

  // load default home list (call on screen init)
  Future<void> loadInitial({String defaultQuery = 'the'}) async {
    currentQuery = '';
    currentSubject = '';
    currentPage = 1;
    await search(defaultQuery);
  }

  Future<void> search(String query, {int page = 1, bool append = false}) async {
    try {
      state = append ? ViewState.loadingMore : ViewState.busy;
      notifyListeners();

      currentQuery = query;
      currentPage = page;
      final res = await repository.search(query, page: page);

      // Apply filters manually
      final filtered = res.where((b) {
        if (filterAuthor != null && !b.authors.contains(filterAuthor)) return false;
        if (filterYear != null && b.firstPublishYear != filterYear) return false;
        return true;
      }).toList();

      if (append) {
        books.addAll(filtered);
      } else {
        books = filtered;
      }
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      state = ViewState.idle;
      notifyListeners();
    }
  }

  Future<void> loadSubject(String subject) async {
    try {
      state = ViewState.busy;
      notifyListeners();
      currentSubject = subject;
      currentPage = 1;
      final res = await repository.getBySubject(subject, limit: 30);

      // Apply filters manually
      final filtered = res.where((b) {
        if (filterAuthor != null && !b.authors.contains(filterAuthor)) return false;
        if (filterYear != null && b.firstPublishYear != filterYear) return false;
        return true;
      }).toList();

      books = filtered;
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      state = ViewState.idle;
      notifyListeners();
    }
  }


  Future<BookModel?> fetchWorkDetails(String workKey) async {
    try {
      state = ViewState.busy;
      notifyListeners();
      final res = await repository.getWorkDetails(workKey);
      return res;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      state = ViewState.idle;
      notifyListeners();
    }
  }


  Future<void> loadMore() async {
    if (state == ViewState.loadingMore) return; // prevent duplicate calls
    currentPage++;
    if (currentQuery.isNotEmpty) {
      await search(currentQuery, page: currentPage, append: true);
    }
    // (for subjects pagination, you could also implement with offset param)
  }

  void applyFilters({String? author, int? year}) {
    filterAuthor = author;
    filterYear = year;
    if (currentSubject.isNotEmpty) {
      loadSubject(currentSubject);
    } else if (currentQuery.isNotEmpty) {
      search(currentQuery, page: 1);
    }
  }

  void clearFilters() {
    filterAuthor = null;
    filterYear = null;
    if (currentSubject.isNotEmpty) {
      loadSubject(currentSubject);
    } else if (currentQuery.isNotEmpty) {
      search(currentQuery, page: 1);
    }
  }
}







// enum ViewState { idle, busy, error }
//
// class ProviderBook with ChangeNotifier {
//   final IBookRepository repository;
//   ProviderBook(this.repository);
//
//   List<BookModel> books = [];
//   ViewState state = ViewState.idle;
//   String error = '';
//   int currentPage = 1;
//   String currentQuery = '';
//   String currentSubject = '';
//
//   // load default home list (call on screen init)
//   Future<void> loadInitial({String defaultQuery = 'the'}) async {
//     currentQuery = '';
//     currentSubject = '';
//     currentPage = 1;
//     await search(defaultQuery);
//   }
//
//   Future<void> search(String query, {int page = 1}) async {
//     try {
//       state = ViewState.busy;
//       notifyListeners();
//       currentQuery = query;
//       currentPage = page;
//       final res = await repository.search(query, page: page);
//       books = res;
//       error = '';
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       state = ViewState.idle;
//       notifyListeners();
//     }
//   }
//
//   Future<void> loadSubject(String subject) async {
//     try {
//       state = ViewState.busy;
//       notifyListeners();
//       currentSubject = subject;
//       final res = await repository.getBySubject(subject, limit: 30);
//       books = res;
//       error = '';
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       state = ViewState.idle;
//       notifyListeners();
//     }
//   }
//
//   Future<BookModel?> fetchWorkDetails(String workKey) async {
//     try {
//       state = ViewState.busy;
//       notifyListeners();
//       final res = await repository.getWorkDetails(workKey);
//       return res;
//     } catch (e) {
//       error = e.toString();
//       return null;
//     } finally {
//       state = ViewState.idle;
//       notifyListeners();
//     }
//   }
// }
