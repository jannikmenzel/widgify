import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Song {
  final String title;
  final String artist;
  final String filePath;

  Song({
    required this.title,
    required this.artist,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'filePath': filePath,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      filePath: json['filePath'],
    );
  }
}


class PlaylistService {
  static const _playlistKey = 'playlist';

  Future<List<Song>> loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistJson = prefs.getString(_playlistKey);
    if (playlistJson != null) {
      final List<dynamic> playlistData = json.decode(playlistJson);
      return playlistData.map((data) => Song.fromJson(data)).toList();
    }
    return [];
  }

  Future<void> savePlaylist(List<Song> playlist) async {
    final prefs = await SharedPreferences.getInstance();
    final playlistJson = json.encode(playlist.map((song) => song.toJson()).toList());
    await prefs.setString(_playlistKey, playlistJson);
  }
}