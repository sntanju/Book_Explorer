import '../../data/models/book_model.dart';

abstract class IBookRepository {

  /// Search by free query (title/author/keyword)
  Future<List<BookModel>> search(String query, {int page = 1});

  /// Get books by subject (category): returns simplified list
  Future<List<BookModel>> getBySubject(String subject, {int limit = 20, int offset = 0});

  /// Get single work details (workKey must include leading "/works/...")
  Future<BookModel?> getWorkDetails(String workKey);

}
