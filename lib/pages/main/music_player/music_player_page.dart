import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _currentSongTitle = 'Titel 1';

  Future<void> _playAudio() async {
    await _audioPlayer.play(DeviceFileSource(_shuffledPlaylist[_currentIndex].filePath));
    setState(() {
      isPlaying = true;
      _currentSongTitle = _shuffledPlaylist[_currentIndex].title;
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
        centerTitle: true,
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _currentSongTitle,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 18),
              ),
              const Text(
                'Interpret',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
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
                activeColor: Colors.blue,
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
                        color: isShuffle ? Colors.blueGrey : Colors.grey,
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
                        color: isSongRepeat || isPlaylistRepeat ? Colors.blueGrey : Colors.grey,
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