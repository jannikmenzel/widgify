import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart' as webfeed;
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/styles/colors.dart';

import 'rss_feed.dart';

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
  Set<String> favoriteAuthors = {};

  @override
  void initState() {
    super.initState();
    _fetchFeed();
    _loadFavorites();
  }

  Future<void> _fetchFeed() async {
    try {
      final response = await http.get(Uri.parse(widget.feed.url));
      if (response.statusCode == 200) {
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

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteAuthors = (prefs.getStringList('favoriteAuthors') ?? []).toSet();
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteAuthors', favoriteAuthors.toList());
  }

  void _toggleFavorite(String author) {
    setState(() {
      if (favoriteAuthors.contains(author)) {
        favoriteAuthors.remove(author);
      } else {
        favoriteAuthors.add(author);
      }
      _saveFavorites();
    });
  }

  Map<String, List<webfeed.RssItem>> _groupByAuthor(List<webfeed.RssItem> items) {
    final Map<String, List<webfeed.RssItem>> groupedItems = {};

    for (var item in items) {
      final author = item.author ?? 'Unbekannter Autor';
      if (!groupedItems.containsKey(author)) {
        groupedItems[author] = [];
      }
      groupedItems[author]!.add(item);
    }

    return groupedItems;
  }

  List<MapEntry<String, List<webfeed.RssItem>>> _getSortedAuthors(Map<String, List<webfeed.RssItem>> groupedItems) {
    final favorite = groupedItems.entries.where((entry) => favoriteAuthors.contains(entry.key));
    final nonFavorite = groupedItems.entries.where((entry) => !favoriteAuthors.contains(entry.key));
    return [...favorite, ...nonFavorite];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.feed.name,
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
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

    if (groupedItems.length == 1) {
      final singleAuthor = groupedItems.keys.first;
      final items = groupedItems[singleAuthor]!;
      return _buildSingleAuthorView(singleAuthor, items);
    }

    return _buildGroupedList(groupedItems);
  }

  Widget _buildSingleAuthorView(String author, List<webfeed.RssItem> items) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            author,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              favoriteAuthors.contains(author) ? Icons.star : Icons.star_border,
              color: favoriteAuthors.contains(author) ? Colors.yellow : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(author),
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
        }),
      ],
    );
  }

  Widget _buildGroupedList(Map<String, List<webfeed.RssItem>> groupedItems) {
    final sortedAuthors = _getSortedAuthors(groupedItems);

    return ListView(
      children: sortedAuthors.map((entry) {
        final author = entry.key;
        final items = entry.value;

        return ExpansionTile(
          title: Text(
            author,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              favoriteAuthors.contains(author) ? Icons.star : Icons.star_border,
              color: favoriteAuthors.contains(author) ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(author),
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

  const ItemDetailPage({super.key, required this.item});

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
                    'Aktualisiert am: ${item.pubDate}',
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
                    'Weitere Infos: ${item.link}',
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