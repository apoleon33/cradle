import 'package:cradle/album.dart';
import 'package:cradle/route/more_info.dart';
import 'package:cradle/share.dart';
import 'package:flutter/material.dart';

class MoreInfoMenu extends StatelessWidget {
  final Album album;

  const MoreInfoMenu({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(menuChildren: <Widget>[
      MenuItemButton(
        leadingIcon: const Icon(Icons.info_rounded),
        child: const Text("More info"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreInfo(
                  album: album,
                  lightColorScheme: const ColorScheme.light(),
                  darkColorScheme: const ColorScheme.dark(),
                ),
              ));
        },
      ),
      MenuItemButton(
        leadingIcon: const Icon(Icons.share),
        child: const Text("Share"),
        onPressed: () async {
          shareAlbum(album);
        },
      )
    ], builder: builder);
  }

  Widget builder(
      BuildContext context, MenuController controller, Widget? child) {
    return IconButton.filled(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: const Icon(Icons.more_vert));
  }
}
