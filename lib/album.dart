class Album {
  String cover = 'assets/default.png';

  String name = "album";
  String artist = "artist";
  String genre = "genre";
  double averageRating = 5.0;

  Album(
      {required this.cover,
      required this.name,
      required this.artist,
      required this.genre,
      required this.averageRating});
}
