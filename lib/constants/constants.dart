import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
const navBarColor = Color.fromARGB(255, 20, 20, 20);
const navServerBar = Color.fromARGB(255, 40, 40, 40);
const primaryColor = Color.fromARGB(125, 0, 0, 0);
const secondaryColor = Color.fromARGB(255, 230, 200, 250);
const secondaryColorSolid = Color.fromARGB(255, 245, 230, 253);
const backgroundColor = Color.fromARGB(165, 0, 0, 0);
const backgroundColorSolid = Color.fromARGB(255, 0, 0, 0);
const fillColor = Color.fromARGB(255, 85, 85, 85);
const cardColor = Color.fromARGB(255, 5, 5, 5);
const errorColor = Color.fromARGB(255, 255, 75, 75);

// Screen
const double mobileScreenSize = 600;
const double webScreenSize = 900;
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

buildUserTile(
  BuildContext context,
) {
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

/*
// Mobile Image/File Picker using File
Future<File?> pickMobileImage(BuildContext context) async {
  try {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      File imageTemp = File(image.path);
      imageTemp = await _cropImage(context, image: imageTemp);

      return imageTemp;
    }
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}

// Mobile Image Cropper
Future<File> _cropImage(BuildContext context, {required File image}) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [WebUiSettings(context: context, showZoomer: true)]);
  if (croppedImage == null) return image;
  return File(croppedImage.path);
}
*/