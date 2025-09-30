import 'package:dio/dio.dart';
import 'package:http/http.dart';
import '../interfaces/interface_book_repository.dart';
import '../models/book_model.dart';

class BookRepository implements IBookRepository {
  final Dio dio;
  BookRepository(this.dio);

  @override
  Future<List<BookModel>> search(String query, {int page = 1}) async {
    final encoded = Uri.encodeQueryComponent(query);
    final url = 'https://openlibrary.org/search.json?q=$encoded&page=$page';
    final resp = await dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data;
      final docs = data['docs'] as List<dynamic>? ?? [];
      return docs.map((e) => BookModel.fromSearchJson(Map<String, dynamic>.from(e))).toList();
    } else {
      throw Exception('Search failed: ${resp.statusCode}');
    }
  }

  @override
  Future<List<BookModel>> getBySubject(String subject, {int limit = 20, int offset = 0}) async {
    // subjects endpoint returns works under "works" field
    final encoded = Uri.encodeQueryComponent(subject.toLowerCase());
    final url = 'https://openlibrary.org/subjects/$encoded.json?limit=$limit&offset=$offset';
    final resp = await dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data;
      final works = data['works'] as List<dynamic>? ?? [];
      return works.map((w) {
        // the subject works structure has title, authors (list of maps), cover_id, key
        final authors = <String>[];
        if (w['authors'] != null) {
          try {
            (w['authors'] as List).forEach((a) {
              if (a != null && a['name'] != null) authors.add(a['name']);
            });
          } catch (_) {}
        }
        return BookModel(
          title: w['title'] ?? 'No title',
          authors: authors.isNotEmpty ? authors : ['Unknown'],
          coverId: w['cover_id'],
          workKey: w['key'] ?? '',
          firstPublishYear: w['first_publish_year'],
          subjects: w['subject'] != null ? List<String>.from(w['subject']) : null,
        );
      }).toList();
    } else {
      throw Exception('GetBySubject failed: ${resp.statusCode}');
    }
  }

  @override
  Future<BookModel?> getWorkDetails(String workKey) async {
    if (workKey.isEmpty) return null;
    final url = 'https://openlibrary.org$workKey.json';
    final resp = await dio.get(url);
    if (resp.statusCode == 200) {
      final data = resp.data as Map<String, dynamic>;
      return BookModel.fromWorkJson(data);
    }
    return null;
  }


}
