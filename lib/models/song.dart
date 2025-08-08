class Song {
  final String title;
  final String artist;
  final String url;
  final String coverUrl; // เพิ่มรูปปกเพลง
  final Duration duration;

  Song({
    required this.title,
    required this.artist,
    required this.url,
    required this.coverUrl,
    required this.duration,
  });
}
