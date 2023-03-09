import 'package:flutter/material.dart';
import 'package:social_app/widgets/nav_drawer_widget.dart';

// FUNCTION'S MAIN USE IS FOR WIDETS THAT ONLY APPEAR ON THE SMALLER SCREENS
// RETURNS CERTIAN WIDGETS DEPENDING IF THE SCREEN SIZE AND CERTAIN WIDGETNAME
// RETURNS NULL IF SCREEN SIZE IS LARGER THAN 500
Widget? isSmallPage(BuildContext context, String widgetName) {
  if (MediaQuery.of(context).size.width == 500 ||
      MediaQuery.of(context).size.width < 500) {
    switch (widgetName) {
      case "Drawer":
        return const NavigationDrawer();
      case "Leading IconButton":
        return Builder(builder: (BuildContext context) {
          return IconButton(
            alignment: Alignment.center,
            //padding: const EdgeInsets.symmetric(horizontal: 20),
            splashRadius: 20,
            icon: const Icon(
              Icons.dehaze_rounded,
              size: 28,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        });

      default:
        return null;
    }
  } else {
    return null;
  }
}
