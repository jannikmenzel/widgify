class RssFeed {
  final String name;
  final String url;

  RssFeed({required this.name, required this.url});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory RssFeed.fromJson(Map<String, dynamic> json) {
    return RssFeed(
      name: json['name'],
      url: json['url'],
    );
  }
}
