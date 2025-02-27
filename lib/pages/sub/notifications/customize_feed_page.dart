import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/components/app_bar.dart';

import 'rss_feed.dart';

class EditFeedPage extends StatefulWidget {
  final List<RssFeed> feeds;

  const EditFeedPage({super.key, required this.feeds});

  @override
  EditFeedPageState createState() => EditFeedPageState();
}

class EditFeedPageState extends State<EditFeedPage> {
  late List<RssFeed> editableFeeds;
  late List<RssFeed> presets;

  @override
  void initState() {
    super.initState();
    editableFeeds = List.from(widget.feeds);
    presets = [];
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    try {
      final String jsonString =
      await rootBundle.loadString('lib/pages/sub/notifications/presets.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        presets = jsonData.map((preset) {
          return RssFeed(
            name: preset['name'],
            url: preset['url'],
          );
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error');
      }
    }
  }

  void _addCustomFeed() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Feed importieren'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Feed Name'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'Feed URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final url = urlController.text;
                if (name.isNotEmpty && url.isNotEmpty) {
                  setState(() {
                    editableFeeds.add(RssFeed(name: name, url: url));
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Hinzufügen'),
            ),
          ],
        );
      },
    );
  }

  void _addFeed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Andere Feeds hinzufügen'),
              onTap: () {
                Navigator.pop(context);
                _addCustomFeed();
              },
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: presets.length,
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  return ListTile(
                    title: Text(preset.name),
                    subtitle: Text(preset.url),
                    onTap: () {
                      setState(() {
                        editableFeeds.add(preset);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeFeed(int index) {
    setState(() {
      editableFeeds.removeAt(index);
    });
  }

  Future<void> _saveAndExit() async {
    final prefs = await SharedPreferences.getInstance();
    final feedListJson = jsonEncode(
      editableFeeds.map((feed) => feed.toJson()).toList(),
    );
    await prefs.setString('rssFeeds', feedListJson);

    if (mounted) {
      Navigator.pop(context, editableFeeds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Feeds bearbeiten",
        trailingIcon: Icons.check,
        onTrailingPressed: _saveAndExit,
      ),
      body: ListView.builder(
        itemCount: editableFeeds.length,
        itemBuilder: (context, index) {
          final feed = editableFeeds[index];
          return ListTile(
            title: Text(feed.name),
            subtitle: Text(feed.url),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeFeed(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFeed,
        child: Icon(Icons.add),
      ),
    );
  }
}
