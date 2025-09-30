class BookModel {
  final String title;
  final List<String> authors;
  final int? coverId;
  final String workKey;
  final int? firstPublishYear;
  final List<String>? subjects;
  final String? description;
  final List<String>? languages;

  BookModel({
    required this.title,
    required this.authors,
    required this.workKey,
    this.coverId,
    this.firstPublishYear,
    this.subjects,
    this.description,
    this.languages,
  });

  factory BookModel.fromSearchJson(Map<String, dynamic> json) {
    final authors = <String>[];
    if (json['author_name'] != null) {
      try {
        for (var e in (json['author_name'] as List)) {
          if (e != null) authors.add(e.toString());
        }
      } catch (_) {}
    }
    return BookModel(
      title: json['title'] ?? 'No title',
      authors: authors.isNotEmpty ? authors : ['Unknown'],
      coverId: json['cover_i'],
      workKey: (json['key'] ?? '').toString(), // e.g. "/works/OL123W"
      firstPublishYear: json['first_publish_year'],
      subjects: json['subject'] != null ? List<String>.from(json['subject']) : null,
      languages: json['language'] != null ? List<String>.from(json['language']) : null,
      description: null,
    );
  }

  /// For work details (detailed endpoint)
  factory BookModel.fromWorkJson(Map<String, dynamic> json, {String? titleOverride, List<String>? authorsOverride}) {
    String desc = '';
    if (json['description'] != null) {
      if (json['description'] is String) {
        desc = json['description'];
      }
      else if (json['description'] is Map && json['description']['value'] != null) {
        desc = json['description']['value'];
      }
    }

    return BookModel(
      title: titleOverride ?? (json['title'] ?? 'No title'),
      authors: authorsOverride ?? [],
      coverId: (json['covers'] != null && (json['covers'] as List).isNotEmpty) ? (json['covers'][0] as int) : null,
      workKey: json['key'] ?? '',
      firstPublishYear: json['first_publish_date'] != null ? int.tryParse((json['first_publish_date'].toString()).split('-').first) : null,
      subjects: json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      languages: null,
      description: desc.isNotEmpty ? desc : null,
    );
  }

  String get coverUrl {
    if (coverId != null) {
      return "https://covers.openlibrary.org/b/id/$coverId-L.jpg";
    }
    return '';
  }

  String get primaryAuthor => authors.isNotEmpty ? authors[0] : 'Unknown';
}
