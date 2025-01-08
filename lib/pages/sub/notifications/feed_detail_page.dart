import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart' as webfeed;
import 'package:http/http.dart' as http;
import 'rss_feed.dart';
import 'dart:convert';

class FeedDetailPage extends StatefulWidget {
  final RssFeed feed;

  const FeedDetailPage({super.key, required this.feed});

  @override
  FeedDetailPageState createState() => FeedDetailPageState();
}

class FeedDetailPageState extends State<FeedDetailPage> {
  webfeed.RssFeed? rssFeed;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    try {
      final response = await http.get(Uri.parse(widget.feed.url));
      if (response.statusCode == 200) {
        // Decode as UTTF-8, doesn't work by default
        final decodedXml = utf8.decode(response.bodyBytes);

        // Prints the RSS data into console for debugging
        print('Response XML: $decodedXml');

        setState(() {
          rssFeed = webfeed.RssFeed.parse(decodedXml);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Feed konnte nicht geladen werden: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Feed konnte nicht geladen werden: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.name),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : rssFeed == null || rssFeed!.items == null
          ? Center(child: Text('Es wurde kein Inhalt im Feed gefunden'))
          : ListView.builder(
        itemCount: rssFeed!.items!.length,
        itemBuilder: (context, index) {
          final item = rssFeed!.items![index];
          return ListTile(
            title: Text(item.title ?? 'Titel fehlt'),
            onTap: () {
              if (item.link != null) {
                _openItemDetails(context, item);
              }
            },
          );
        },
      ),
    );
  }

  void _openItemDetails(BuildContext context, webfeed.RssItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(item: item),
      ),
    );
  }
}

class ItemDetailPage extends StatelessWidget {
  final webfeed.RssItem item;

  const ItemDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title ?? 'Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title != null)
                Text(
                  item.title!,
                ),
              if (item.pubDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Published on: ${item.pubDate}',
                  ),
                ),
              if (item.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    item.description!,
                  ),
                ),
              if (item.link != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Read more at: ${item.link}',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
