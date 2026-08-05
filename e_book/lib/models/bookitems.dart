class BookItem {
  final String title;
  final String author;
  final String coverImage;
  final String readOnline;
  final DownloadLinks downloadLinks;
  final String description;
  final String authorDescription;
  final int? firstPublishYear;
  int price;

  BookItem({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.readOnline,
    required this.downloadLinks,
    required this.description,
    required this.authorDescription,
    this.firstPublishYear,
    required this.price,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      title: json['title'],
      author: json['author'],
      coverImage: json['coverImage'],
      readOnline: json['readOnline'],
      downloadLinks: DownloadLinks.fromJson(json['downloadLinks']),
      description: json['description'],
      authorDescription: json['authorDescription'],
      firstPublishYear: json['firstPublishYear'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'coverImage': coverImage,
        'readOnline': readOnline,
        'downloadLinks': downloadLinks.toJson(),
        'description': description,
        'authorDescription': authorDescription,
        'firstPublishYear': firstPublishYear,
        'price': price,
      };
}

class DownloadLinks {
  final String pdf;
  final String epub;

  DownloadLinks({required this.pdf, required this.epub});

  factory DownloadLinks.fromJson(Map<String, dynamic> json) {
    return DownloadLinks(
      pdf: json['pdf'],
      epub: json['epub'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf': pdf,
      'epub': epub,
    };
  }
}
