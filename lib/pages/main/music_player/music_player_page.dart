import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/pages/main/music_player/music_player_songview_page.dart';
import 'package:widgify/pages/main/music_player/music_player_utils.dart';
import 'package:widgify/styles/colors.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool isPlaying = false;
  int _currentIndex = 0;
  bool isPlaylistRepeat = false;
  bool isSongRepeat = false;
  List<Song> _playlist = [];
  late List<Song> _shuffledPlaylist;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
    _shuffledPlaylist = List.from(_playlist);

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (isSongRepeat) {
        _playAudio();
      } else if (isPlaylistRepeat || _currentIndex < _shuffledPlaylist.length - 1) {
        _skipNext();
      }
    });
  }

  Future<void> _loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistJson = prefs.getString('playlist');
    if (playlistJson != null) {
      final List<dynamic> playlistData = jsonDecode(playlistJson);
      setState(() {
        _playlist = playlistData.map((data) => Song.fromJson(data)).toList();
        _shuffledPlaylist = List.from(_playlist);
      });
    }
  }

  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistJson = jsonEncode(_playlist.map((song) => song.toJson()).toList());
    await prefs.setString('playlist', playlistJson);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _currentSongTitle = 'Kein Song ausgewählt';
  String _currentSongArtist = 'Unbekannter Künstler';

  Future<void> _playAudio() async {
    if (_shuffledPlaylist.isEmpty) {
      setState(() {
        _currentSongTitle = 'Keine Songs vorhanden';
      });
      return;
    }
    await _audioPlayer.play(DeviceFileSource(_shuffledPlaylist[_currentIndex].filePath));
    setState(() {
      isPlaying = true;
      _currentSongTitle = _shuffledPlaylist[_currentIndex].title;
      _currentSongArtist = _shuffledPlaylist[_currentIndex].artist;
    });
  }

  void _playPauseAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await _playAudio();
    }
  }

  void _skipNext() async {
    if (isShuffle) {
      int nextIndex;
      do {
        nextIndex = Random().nextInt(_shuffledPlaylist.length);
      } while (nextIndex == _currentIndex);
      _currentIndex = nextIndex;
    } else {
      if (_currentIndex < _shuffledPlaylist.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    }
    await _playAudio();
  }

  void _skipPrevious() async {
    if (!isShuffle) {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _shuffledPlaylist.length - 1;
      }
    }
    await _playAudio();
  }

  void _toggleRepeat() {
    if (isPlaylistRepeat) {
      isPlaylistRepeat = false;
      isSongRepeat = true;
    } else if (isSongRepeat) {
      isSongRepeat = false;
    } else {
      isPlaylistRepeat = true;
    }
    setState(() {});
  }

  bool isShuffle = false;

  void _toggleShuffle() {
    if (_shuffledPlaylist.isEmpty) {
      setState(() {
        _currentSongTitle = 'Keine Songs vorhanden';
      });
      return;
    }

    setState(() {
      if (isShuffle) {
        isShuffle = false;
        final currentSong = _shuffledPlaylist[_currentIndex];
        _shuffledPlaylist = List.from(_playlist);
        _currentIndex = _playlist.indexOf(currentSong);
      } else {
        isShuffle = true;
        final currentSong = _shuffledPlaylist[_currentIndex];
        _shuffledPlaylist = List.from(_playlist)..shuffle(Random());
        _currentIndex = _shuffledPlaylist.indexOf(currentSong);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musikplayer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              final selectedIndex = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerSongViewPage(
                    playlist: isShuffle ? _shuffledPlaylist : _playlist,
                    currentIndex: _currentIndex,
                    onPlaylistChanged: (newPlaylist) {
                      setState(() {
                        _playlist = newPlaylist;
                        _shuffledPlaylist = List.from(newPlaylist);
                      });
                      _savePlaylist();
                    },
                  ),
                ),
              );

              if (selectedIndex != null) {
                setState(() {
                  _currentIndex = selectedIndex;
                });
                _playAudio();
              }
            },
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
              height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  image: (_shuffledPlaylist.isNotEmpty &&
                      _currentIndex >= 0 &&
                      _currentIndex < _shuffledPlaylist.length &&
                      _shuffledPlaylist[_currentIndex].coverImage != null)
                      ? DecorationImage(
                    image: MemoryImage(_shuffledPlaylist[_currentIndex].coverImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: (_shuffledPlaylist.isEmpty ||
                    _currentIndex < 0 ||
                    _currentIndex >= _shuffledPlaylist.length ||
                    _shuffledPlaylist[_currentIndex].coverImage == null)
                    ? const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey,
                )
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                _currentSongTitle,
                style: TextStyle(color: AppColors.primary, fontSize: 18),
              ),
              Text(_currentSongArtist)
            ],
          ),
          Column(
            children: [
              Slider(
                value: _currentPosition.inSeconds.toDouble(),
                max: _totalDuration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(newPosition);
                  setState(() {
                    _currentPosition = newPosition;
                  });
                },
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: isShuffle ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: _toggleShuffle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: _skipPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                      ),
                      onPressed: _playPauseAudio,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: _skipNext,
                    ),
                    IconButton(
                      icon: Icon(
                        isSongRepeat
                            ? Icons.repeat_one
                            : isPlaylistRepeat
                            ? Icons.repeat
                            : Icons.repeat_outlined,
                        color: isSongRepeat || isPlaylistRepeat ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: _toggleRepeat,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}