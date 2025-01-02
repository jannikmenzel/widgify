import 'package:flutter/material.dart';
import 'package:widgify/pages/main/music_player/music_player_utils.dart';
import 'package:file_picker/file_picker.dart';

class MusicPlayerSongViewPage extends StatefulWidget {
  final List<String> playlist;
  final int currentIndex;

  const MusicPlayerSongViewPage({
    Key? key,
    required this.playlist,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _MusicPlayerSongViewPageState createState() => _MusicPlayerSongViewPageState();
}

class _MusicPlayerSongViewPageState extends State<MusicPlayerSongViewPage> {
  late List<String> _playlist;
  late int _currentIndex;

  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playlist = List.from(widget.playlist);
    _currentIndex = widget.currentIndex;
  }

  void _removeSong(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Song löschen'),
          content: const Text('Möchten Sie diesen Song wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Schließt den Dialog
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _playlist.removeAt(index);
                  if (_currentIndex >= _playlist.length) {
                    _currentIndex = _playlist.length - 1;
                  }
                });
                Navigator.pop(context); // Schließt den Dialog und löscht den Song
              },
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSongFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          _playlist.add(filePath);
        });
      }
    }
  }

  Future<void> _addSongFromUrl() async {
    String? url = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Song URL eingeben'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(hintText: 'Geben Sie den Song-Link ein'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null); // Abbrechen
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _urlController.text); // Song-URL zurückgeben
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        );
      },
    );

    if (url != null && url.isNotEmpty) {
      setState(() {
        _playlist.add(url); // URL zur Playlist hinzufügen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSongFromFile,
          ),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: _addSongFromUrl, // Song über URL hinzufügen
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _playlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              index == _currentIndex ? Icons.play_arrow : Icons.music_note,
              color: index == _currentIndex ? Colors.blue : Colors.grey,
            ),
            title: Text('Song ${index + 1}'),
            subtitle: Text(_playlist[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _removeSong(index);
              },
            ),
            onTap: () {
              Navigator.pop(context, index); // Gibt den ausgewählten Song-Index zurück
            },
          );
        },
      ),
    );
  }
}
