class AudioBooks {
  final String id;
  final String title;
  final String description;
  final String language;
  final String author;
  final String urlLibrivox;
  final String urlTextSource;
  final String urlZipFile;
  final String urlRss;
  final String totalTime;
  String? coverImage;

  AudioBooks({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.author,
    required this.urlLibrivox,
    required this.urlTextSource,
    required this.urlZipFile,
    required this.urlRss,
    required this.totalTime,
    this.coverImage,
  });

  factory AudioBooks.fromJson(Map<String, dynamic> json) {
    final authorData = json['authors'].isNotEmpty
        ? json['authors'][0]
        : {'first_name': '', 'last_name': ''};

    return AudioBooks(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      author: '${authorData['first_name']} ${authorData['last_name']}',
      urlLibrivox: json['url_librivox'] ?? '',
      urlTextSource: json['url_text_source'] ?? '',
      urlZipFile: json['url_zip_file'] ?? '',
      urlRss: json['url_rss'] ?? '',
      totalTime: json['totaltime'] ?? '',
      coverImage: json['cover_image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'language': language,
        'author': author,
        'url_librivox': urlLibrivox,
        'url_text_source': urlTextSource,
        'url_zip_file': urlZipFile,
        'url_rss': urlRss,
        'totaltime': totalTime,
        'cover_image': coverImage,
      };
}
