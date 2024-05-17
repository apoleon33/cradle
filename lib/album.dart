class Album {
  /// Url to a cover of the album
  String cover = 'assets/default.png';

  /// Name of the album
  String name = "album";

  /// Main artist that did the album
  String artist = "artist";

  /// Main genre of the album
  String genre = "genre";

  /// RYM's rating for this album
  double averageRating = 5.0;

  Album(
      {required this.cover,
      required this.name,
      required this.artist,
      required this.genre,
      required this.averageRating});
}
