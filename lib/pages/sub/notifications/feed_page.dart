import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/components/app_bar.dart';

import 'edit_feed_page.dart';
import 'feed_detail_page.dart';
import 'rss_feed.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  List<RssFeed> feeds = [];

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  Future<void> _loadFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? feedListJson = prefs.getString('rssFeeds');
    if (feedListJson != null) {
      final List<dynamic> jsonData = jsonDecode(feedListJson);
      setState(() {
        feeds = jsonData.map((json) => RssFeed.fromJson(json)).toList();
      });
    } else {
      setState(() {
        feeds = [
          RssFeed(
              name: "Mensa Heute",
              url: "https://www.studentenwerk-dresden.de/feeds/speiseplan.rss"),
          RssFeed(
              name: "Mensa Morgen",
              url: "https://www.studentenwerk-dresden.de/feeds/speiseplan.rss?tag=morgen")
        ];
      });
    }
  }

  Future<void> _saveFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final feedListJson =
    jsonEncode(feeds.map((feed) => feed.toJson()).toList());
    await prefs.setString('rssFeeds', feedListJson);
  }

  void _editFeeds() async {
    final updatedFeeds = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFeedPage(feeds: feeds)),
    );
    if (updatedFeeds != null) {
      setState(() {
        feeds = updatedFeeds;
      });
      await _saveFeeds();
    }
  }

  void _viewFeedDetail(RssFeed feed) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedDetailPage(feed: feed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "RSS Feeds",
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
        trailingIcon: Icons.edit,
        onTrailingPressed: _editFeeds,
      ),
      body: feeds.isEmpty
          ? Center(
        child: Text("Keine Feeds verfügbar"),
      )
          : ListView.separated(
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          final feed = feeds[index];
          return ListTile(
            title: Text(feed.name),
            subtitle: Text(feed.url),
            onTap: () => _viewFeedDetail(feed),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          thickness: 1.0,
          indent: 16.0,
          endIndent: 16.0,
        ),
      ),
    );
  }
}