import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_player_provider.dart';
import '../models/song.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<MusicPlayerProvider>();
    final song = playerProvider.currentSong;
    final songs = playerProvider.allSongs;

    if (song == null) return const SizedBox.shrink();

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.5),
          elevation: 0,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.coverUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                playerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                playerProvider.playSong(song);
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              iconSize: 30,
              onPressed: () {
                playerProvider.playNextSong();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "UP NEXT"),
              Tab(text: "LYRICS"),
            ],
          ),
        ),

        body: Stack(
          children: [
            // 🔹 Background Blur
            Positioned.fill(
              child: Image.network(song.coverUrl, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
            ),

            // 🔹 Main Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight + 48,
                ), // เว้นพื้นที่ให้ AppBar + TabBar
                child: TabBarView(
                  children: [
                    _UpNextList(
                      songs: songs,
                      onTap: (song) {
                        context.read<MusicPlayerProvider>().playSong(song);
                      },
                    ),
                    _LyricsView(song: song),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpNextList extends StatelessWidget {
  final List<Song> songs;
  final Function(Song) onTap;

  const _UpNextList({required this.songs, required this.onTap});

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.read<MusicPlayerProvider>();

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        playerProvider.reorderSongs(oldIndex, newIndex);
      },

      // 🔧 ตรงนี้คือส่วนที่ป้องกันไม่ให้มีกรอบขาว
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent, // ไม่ให้มีพื้นหลัง
          child: child,
        );
      },

      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          key: ValueKey(song), // ต้องมี key
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.coverUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
            ),
          ),
          title: Text(song.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(
            '${song.artist} • ${_formatDuration(song.duration)}',
            style: const TextStyle(color: Colors.white70),
          ),
          onTap: () => onTap(song),
          trailing: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle, color: Colors.white70),
          ),
        );
      },
    );
  }
}

class _LyricsView extends StatelessWidget {
  final Song song;

  _LyricsView({required this.song});
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<MusicPlayerProvider>();
    final position = playerProvider.currentPosition;
    final duration = playerProvider.totalDuration;
    final value = duration.inSeconds == 0
        ? 0.0
        : position.inSeconds.clamp(0, duration.inSeconds).toDouble();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 ปกใหญ่
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                song.coverUrl,
                key: ValueKey(song.coverUrl), // ⭐ ป้องกัน Flutter แคชภาพผิด
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 ชื่อเพลง
            Text(
              song.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              song.artist,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🔹 Progress Bar
            Slider(
              value: value,
              max: duration.inSeconds.toDouble(),
              onChanged: (value) {
                playerProvider.audioPlayer.seek(
                  Duration(seconds: value.toInt()),
                );
              },
              activeColor: Colors.white,
              inactiveColor: Colors.white24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  _formatDuration(duration),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),

            // 🔹 ปุ่มควบคุม
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    playerProvider.playPreviousSong();
                  },
                ),
                IconButton(
                  icon: Icon(
                    playerProvider.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                  ),
                  iconSize: 60,
                  color: Colors.white,
                  onPressed: () {
                    playerProvider.playSong(song);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: () {
                    playerProvider.playNextSong();
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Lyrics (mock)
            Text(
              'Lyrics for "${song.title}"\n\n(ไม่พบเนื้อเพลง)',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
