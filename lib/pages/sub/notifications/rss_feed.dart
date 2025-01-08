class RssFeed {
  final String name;
  final String url;

  RssFeed({required this.name, required this.url});

  // Convert RssFeed instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  // Create an RssFeed instance from a JSON object
  factory RssFeed.fromJson(Map<String, dynamic> json) {
    return RssFeed(
      name: json['name'],
      url: json['url'],
    );
  }
}
