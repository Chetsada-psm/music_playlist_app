import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;

  final List<Song> allSongs = [
    Song(
      title: 'Tech House Vibes',
      artist: 'A&K',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      coverUrl:
          'https://static.freelancebay.com/article/inlineimage/2019/6/full/1561558449349-52578-nuzj24jbtlqms1nar73a.jpg',
      duration: Duration(minutes: 6, seconds: 12),
    ),
    Song(
      title: 'Summer Hits',
      artist: 'Hits',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      coverUrl:
          'https://static.freelancebay.com/article/inlineimage/2019/6/full/1561558449350-92600-uvq0r1k951f8abkt8had.jpg',
      duration: Duration(minutes: 7, seconds: 05),
    ),
    Song(
      title: 'Techno 2021',
      artist: 'The 2021 Group',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      coverUrl:
          'https://static.freelancebay.com/article/inlineimage/2019/6/full/1561558449375-766277-8upnpfazq1j7i7o5ljdm.jpg',
      duration: Duration(minutes: 5, seconds: 44),
    ),
    Song(
      title: 'Vibe with Me',
      artist: 'Housy',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      coverUrl:
          'https://static.freelancebay.com/article/inlineimage/2019/6/full/1561558449439-62809-3as8rpx4idiv6kdntpnt.jpg',
      duration: Duration(minutes: 5, seconds: 02),
    ),
    Song(
      title: 'Listen & Chill',
      artist: 'Hipster',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      coverUrl:
          'https://static.freelancebay.com/article/inlineimage/2019/6/full/1561558449533-43271-r2y39ekofv3hyb0juf3i.jpg',
      duration: Duration(minutes: 5, seconds: 53),
    ),
  ];

  MusicPlayerProvider() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      _isPlaying = playing;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  double get sliderValue {
    if (_totalDuration.inSeconds == 0) return 0.0;
    return _currentPosition.inSeconds
        .clamp(0, _totalDuration.inSeconds)
        .toDouble();
  }

  double get sliderMax => _totalDuration.inSeconds.toDouble();

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool isShuffle = false;
  LoopMode loopMode = LoopMode.off;

  Future<void> toggleShuffle() async {
    isShuffle = !isShuffle;
    await _audioPlayer.setShuffleModeEnabled(isShuffle);
    notifyListeners();
  }

  Future<void> playSong(Song song) async {
    if (_currentSong != null && _currentSong!.url == song.url) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(); // ใช้ play() แทน resume()
      }
    } else {
      _currentSong = song;
      // ใช้ setUrl() ได้เลย ไม่ต้องใช้ UrlSource
      await _audioPlayer.setUrl(song.url);
      await _audioPlayer.play();
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentSong == null) {
      final song = allSongs.first;
      _currentSong = song;
      await _audioPlayer.setUrl(song.url);
      await _audioPlayer.play();
      // _isPlaying ถูกอัปเดตจาก listener
    } else if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    // ไม่ต้องเรียก notifyListeners เพราะฟังจาก onPlayerStateChanged
  }

  void stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }

  void playNextSong() {
    if (_currentSong == null) return;

    final currentIndex = allSongs.indexOf(_currentSong!);
    final nextIndex = (currentIndex + 1) % allSongs.length;
    final nextSong = allSongs[nextIndex];
    playSong(nextSong);
  }

  void playPreviousSong() {
    if (_currentSong == null) return;

    final currentIndex = allSongs.indexOf(_currentSong!);
    final prevIndex = (currentIndex - 1 + allSongs.length) % allSongs.length;
    final prevSong = allSongs[prevIndex];
    playSong(prevSong);
  }

  void toggleRepeatMode() {
    switch (loopMode) {
      case LoopMode.off:
        loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        loopMode = LoopMode.off;
        break;
    }
    _audioPlayer.setLoopMode(loopMode);
    notifyListeners();
  }

  void reorderSongs(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final song = allSongs.removeAt(oldIndex);
    allSongs.insert(newIndex, song);
    notifyListeners();
  }
}
