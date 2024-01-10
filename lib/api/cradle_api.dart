import 'package:cradle/album.dart';
import 'package:cradle/api/api.dart';

class CradleApi extends Api {
  CradleApi() : super(baseUrl: 'https://cradle-api.vercel.app/album/');

  Future<Album> getAlbumByDate(DateTime date) async {
    Map result = await callApi('${date.year}/${date.month}/${date.day}');
    return Album(
        cover: result['image'],
        name: result['name'],
        artist: result['artist'],
        genre: result['genre'][0],
        averageRating: result['average_rating']);
  }
}
