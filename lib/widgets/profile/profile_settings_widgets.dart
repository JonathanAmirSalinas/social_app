import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/settings/account/settings_account_page.dart';

// Profile Settings Tile
buildProfileSettingsTile(BuildContext context, String uid, String link,
    String title, String subTitle) {
  return ListTile(
    onTap: () {
      buildSettingsTileLink(context, uid, link);
    },
    title: Text(
      title,
      style:
          TextStyle(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
    ),
    subtitle: Text(
      subTitle,
      style:
          TextStyle(fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
    ),
    shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6))),
  );
}

buildSettingsTileLink(BuildContext context, String uid, String link) {
  switch (link) {
    case 'Account':
      return context.router.pushNamed('/settings/account');
    case 'Profiles':
      return context.router.pushNamed('/settings/profiles');
    case 'Privacy':
      return context.router.pushNamed('/settings/privacyandsafety');
    default:
      return null;
  }
}

// Builds User's Account Settings Screen
buildAccountSettingsDialog(BuildContext context, String uid) {
  return showDialog(
      context: context,
      builder: ((context) {
        return AccountSettingsPage();
      }));
}

// Builds User's Profiles Settings Screen
buildProfilesSettingDialog(BuildContext context, String uid) {
  return showDialog(
      context: context,
      builder: ((context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profiles',
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
            ),
          ),
          body: Container(
            color: mainBackgroundColor,
          ),
        );
      }));
}

// Build User's Privacy and Safety Settings
buildPrivacyAndSafetySettingDialog(BuildContext context, String uid) {
  return showDialog(
      context: context,
      builder: ((context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Privacy & Safety',
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
            ),
          ),
          body: Container(
            color: mainBackgroundColor,
          ),
        );
      }));
}

buildAccountInformation(BuildContext context, String uid) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionDivider(context, 'Banner'),
            // Banner
            Container(
              height: 300,
              margin: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(user['banner_image']),
                      fit: BoxFit.cover)),
            ),
            buildSectionDivider(context, 'Profile Picture'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 150,
                  width: 200,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: mainBackgroundColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(user['profile_image']),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
            buildSectionDivider(context, 'User Information'),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize),
                      ),
                      Text(
                        user['username'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      ),
                      Text(
                        user['email'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    },
  );
}

// Section Title Divider
buildSectionDivider(BuildContext context, String section) {
  return Row(
    children: [
      Expanded(
          child: Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: fillColor,
      )),
      Text(
        section,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
      ),
      Expanded(
          flex: 8,
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: fillColor,
          )),
    ],
  );
}
