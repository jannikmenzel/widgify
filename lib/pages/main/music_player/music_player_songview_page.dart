import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:widgify/pages/main/music_player/music_player_utils.dart';

class MusicPlayerSongViewPage extends StatefulWidget {
  final List<Song> playlist;
  final int currentIndex;
  final Function(List<Song>) onPlaylistChanged;

  const MusicPlayerSongViewPage({
    super.key,
    required this.playlist,
    required this.currentIndex,
    required this.onPlaylistChanged,
  });

  @override
  MusicPlayerSongViewPageState createState() => MusicPlayerSongViewPageState();
}

class MusicPlayerSongViewPageState extends State<MusicPlayerSongViewPage> {
  late List<Song> _playlist;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _playlist = List.from(widget.playlist);
    _currentIndex = widget.currentIndex;
  }

  Future<void> _addSongsFromFolder() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      allowMultiple: true,
    );

    if (result != null) {
      final newSongs = result.files.map((file) {
        return Song(
          title: file.name.split('.').first,
          artist: 'Unbekannt',
          filePath: file.path!,
        );
      }).toList();

      setState(() {
        _playlist.addAll(newSongs);
      });

      widget.onPlaylistChanged(_playlist);
    }
  }

  void _removeSong(int index) {
    setState(() {
      _playlist.removeAt(index);
    });

    widget.onPlaylistChanged(_playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _addSongsFromFolder,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _playlist.length,
        itemBuilder: (context, index) {
          final song = _playlist[index];
          return ListTile(
            leading: Icon(
              index == _currentIndex ? Icons.play_arrow : Icons.music_note,
              color: index == _currentIndex ? Colors.blue : Colors.grey,
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeSong(index),
            ),
            onTap: () {
              Navigator.pop(context, index);
            },
          );
        },
      ),
    );
  }
}