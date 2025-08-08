import 'package:flutter/material.dart';
import 'package:music_playlist_app/screens/palyer_screen.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_player_provider.dart';

class PlaylistScreen extends StatelessWidget {
  final List<Song> songs = [
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

  @override
  Widget build(BuildContext context) {
    final player = context.watch<MusicPlayerProvider>();
    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Playlist')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final isPlaying =
              player.currentSong?.url == song.url && player.isPlaying;

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              ),
              iconSize: 30,
              onPressed: () => player.playSong(song),
            ),
          );
        },
      ),
      bottomNavigationBar: player.currentSong != null
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlayerScreen()),
                );
              },
              child: Container(
                color: Colors.grey[900],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                constraints: BoxConstraints(minHeight: 120),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // แถบสถานะเพลง + เวลา อยู่บนสุด
                    Row(
                      children: [
                        // เวลาปัจจุบัน
                        Text(
                          _formatDuration(player.currentPosition),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: LinearProgressIndicator(
                              value: player.totalDuration.inSeconds == 0
                                  ? 0
                                  : player.currentPosition.inSeconds /
                                        player.totalDuration.inSeconds,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),

                        // เวลารวมเพลง
                        Text(
                          _formatDuration(player.totalDuration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8), // เว้นช่องว่างเล็กน้อย
                    // Row รูปเพลง + ชื่อเพลง + ปุ่มเล่น/หยุด
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            player.currentSong!.coverUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                player.currentSong!.title,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                player.currentSong!.artist,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            player.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            player.playSong(player.currentSong!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
