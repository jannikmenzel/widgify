import 'package:flutter/material.dart';
import 'edit_feed_page.dart';
import 'feed_detail_page.dart';
import 'rss_feed.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  List<RssFeed> feeds = [
    RssFeed(name: "Mensa Heute", url: "https://www.studentenwerk-dresden.de/feeds/speiseplan.rss"),
    RssFeed(name: "Mensa Morgen", url: "https://www.studentenwerk-dresden.de/feeds/speiseplan.rss?tag=morgen")
  ];

  void _editFeeds() async {
    final updatedFeeds = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFeedPage(feeds: feeds)),
    );
    if (updatedFeeds != null) {
      setState(() {
        feeds = updatedFeeds;
      });
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
      appBar: AppBar(
        title: Text("RSS Feeds"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editFeeds,
          ),
        ],
      ),
      body: ListView.separated(
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
