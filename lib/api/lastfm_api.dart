import 'package:cradle/album.dart';
import 'package:cradle/api/api.dart';
import 'package:cradle/env/env.dart';

class LastFmApi extends Api {
  LastFmApi()
      : super(
      baseUrl:
      'https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=$LASTFM_KEY');

  Future<Map> getAlbum(Album album) async =>
      await callApi(
        '&artist=${album.artist}&album=${album.name}&format=json',
      );

  Future getCover(Album album) async {
    Map result = await getAlbum(album);
    var image = result['album']['image'];

    return (image != null)
        ? (image.last['#text'] != "")
        ? image.last['#text']
        : null
        : null;
  }
}
