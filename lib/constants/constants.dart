import 'package:flutter/material.dart';
import 'package:social_app/pages/main-navigation/activity_page.dart';
import 'package:social_app/pages/main-navigation/explore_page.dart';
import 'package:social_app/pages/main-navigation/home_page.dart';
import 'package:social_app/pages/main-navigation/server_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_media_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_news_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_server_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_trending_page.dart';
import 'package:social_app/widgets/drawers/nav_drawer_widget.dart';

// Colors
const navBarColor = Color.fromARGB(255, 51, 51, 51);
const navServerBar = Color.fromARGB(255, 63, 63, 63);
const primaryColor = Color.fromARGB(125, 0, 0, 0);
const secondaryColor = Color.fromARGB(255, 225, 170, 255);
const backgroundColor = Color.fromARGB(125, 0, 0, 0);
const fillColor = Color.fromARGB(255, 85, 85, 85);
const cardColor = Color.fromARGB(255, 255, 0, 0);

// Screen
const mobileScreenSize = 500;
const webScreenSize = 900;
//Window width: ${MediaQuery.of(context).size.width.toString()

// Bool true if Screen Size is meets Mobile Constraints
bool isMobileScreen(double screenSize) {
  if (screenSize < mobileScreenSize) {
    return true;
  } else {
    return false;
  }
}

// Main Navigation Screen
const mainScreens = [
  HomePage(),
  ExplorePage(),
  ActivityPage(),
  ServersPage(),
];

const exploreScreens = [
  TrendingTabPage(),
  NewsTabPage(),
  MediaTabPage(),
  ServersTabPage()
];

// FUNCTION'S MAIN USE IS FOR WIDETS THAT ONLY APPEAR ON THE SMALLER SCREENS
// RETURNS CERTAIN WIDGETS DEPENDING IF THE SCREEN SIZE AND CERTAIN WIDGETNAME
// RETURNS NULL IF SCREEN SIZE IS LARGER THAN 500
Widget? isSmallPage(BuildContext context, String widgetName) {
  if (MediaQuery.of(context).size.width == 500 ||
      MediaQuery.of(context).size.width < 500) {
    switch (widgetName) {
      case "Drawer":
        return const SliverNavigationDrawer();
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
    return Container();
  }
}
