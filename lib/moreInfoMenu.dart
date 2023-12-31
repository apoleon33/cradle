import 'package:flutter/material.dart';

class MoreInfoMenu extends StatelessWidget {
  const MoreInfoMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(menuChildren: <Widget>[
      MenuItemButton(
        child: const Text("yup"),
        onPressed: () {},
      ),
      MenuItemButton(
        child: const Text("we are here"),
        onPressed: () {},
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
