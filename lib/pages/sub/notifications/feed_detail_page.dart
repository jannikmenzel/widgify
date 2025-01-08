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
        // Decode as UTF-8
        final decodedXml = utf8.decode(response.bodyBytes);

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

  /// Group items by their authors
  Map<String, List<webfeed.RssItem>> _groupByAuthor(List<webfeed.RssItem> items) {
    final Map<String, List<webfeed.RssItem>> groupedItems = {};

    for (var item in items) {
      final author = item.author ?? 'Unknown Author';
      if (!groupedItems.containsKey(author)) {
        groupedItems[author] = [];
      }
      groupedItems[author]!.add(item);
    }

    return groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.name),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : rssFeed == null || rssFeed!.items == null
          ? const Center(child: Text('Es wurde kein Inhalt im Feed gefunden'))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final groupedItems = _groupByAuthor(rssFeed!.items!);

    // Check if there is only one author
    if (groupedItems.length == 1) {
      final singleAuthor = groupedItems.keys.first;
      final items = groupedItems[singleAuthor]!;
      return _buildSingleAuthorView(singleAuthor, items);
    }

    // If there are multiple authors, display as grouped list
    return _buildGroupedList(groupedItems);
  }

  Widget _buildSingleAuthorView(String author, List<webfeed.RssItem> items) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$author',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) {
          return ListTile(
            title: Text(item.title ?? 'Titel fehlt'),
            subtitle: Text(item.description ?? 'Keine Beschreibung'),
            onTap: () {
              if (item.link != null) {
                _openItemDetails(context, item);
              }
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGroupedList(Map<String, List<webfeed.RssItem>> groupedItems) {
    return ListView(
      children: groupedItems.entries.map((entry) {
        final author = entry.key;
        final items = entry.value;

        return ExpansionTile(
          title: Text(
            author,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: items.map((item) {
            return ListTile(
              title: Text(item.title ?? 'Titel fehlt'),
              subtitle: Text(item.description ?? 'Keine Beschreibung'),
              onTap: () {
                if (item.link != null) {
                  _openItemDetails(context, item);
                }
              },
            );
          }).toList(),
        );
      }).toList(),
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
        title: Text(item.title ?? 'Details'),
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (item.pubDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                      'Aktualsiert am: ${item.pubDate}',
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
                    'Weitre Infos: ${item.link}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
