import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
const mainBackgroundColor = Colors.black;
const mainSecondaryColor = Color.fromARGB(255, 255, 59, 114);
const fillColor = Color.fromARGB(255, 144, 144, 144);
const errorColor = Colors.red;

// Content Colors

const taggedColor = Color.fromARGB(255, 255, 59, 114);

// Navigation Rail
const mainNavRailBackgroundColor = Color.fromARGB(255, 20, 20, 20);
const mainServerRailBackgroundColor = Color.fromARGB(255, 40, 40, 40);

// Navigation Drawer
const navDrawerBackgroundColor = Colors.black;
const navDrawerItemColor = Color.fromARGB(255, 255, 255, 255);

// Screen
const double mobileScreenSize = 600;
const double webScreenSize = 900;
//Window width: ${MediaQuery.of(context).size.width.toString()

// Content Loading Shimmer Animation
const shimmerBase = Color.fromARGB(255, 142, 142, 142);
const shimmerHighlight = Color.fromARGB(255, 115, 115, 115);

int hexToInteger(String hex) => int.parse(hex, radix: 16);

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

buildProfileImage(BuildContext context) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: 55,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(user['profile_image']),
                  fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

buildUserTile(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user['name'],
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        ),
                      ),
                      Text(
                        ' \u2022 Date',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                        ),
                      )
                    ],
                  ),
                  Text(
                    user['username'],
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge!.fontSize,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      });
}

// Builds Detectabel Statement
buildDetectableStatement(
    BuildContext context, String statement, TextOverflow textOverflow) {
  return DetectableText(
    text: statement,
    basicStyle: TextStyle(
      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
      fontWeight: FontWeight.w400,
    ),
    detectedStyle: TextStyle(
      color: taggedColor,
      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
      fontWeight: FontWeight.w500,
    ),
    detectionRegExp: RegExp(
      "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
      multiLine: true,
    ),
    overflow: textOverflow,
  );
}

// Builds Server Member Profile Image
buildServerMemberImage(BuildContext context, String uid) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 45,
            width: 45,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(user['profile_image']),
                  fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    },
  );
}
