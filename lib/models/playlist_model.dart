import 'package:music_playlist_app/models/song.dart';

class PlaylistModel {
  final String title;
  final List<Song> songs;

  PlaylistModel({required this.title, required this.songs});
}
