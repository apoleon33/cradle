import 'package:cradle/album.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<XFile> getImageXFileByUrl(String url) async {
  var file = await DefaultCacheManager().getSingleFile(url);
  XFile result = await XFile(file.path);
  return result;
}

void shareAlbum(Album album) async {
  Share.shareXFiles(
    [await getImageXFileByUrl(album.cover)],
    text:
    'Hey, check out ${album.name} by ${album
        .artist}! \n This album was discovered using Cradle: https://github.com/apoleon33/cradle.',
  );
}
