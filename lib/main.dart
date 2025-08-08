import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/music_player_provider.dart';
import 'screens/playlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicPlayerProvider(),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: PlaylistScreen(),
      ),
    );
  }
}
