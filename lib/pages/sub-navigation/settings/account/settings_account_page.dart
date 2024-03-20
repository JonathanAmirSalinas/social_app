import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/settings/account/account_update_banner_image.dart';
import 'package:social_app/pages/sub-navigation/settings/account/account_update_profile_image.dart';
import 'package:social_app/pages/sub-navigation/settings/account/account_update_user_information.dart';
import 'package:social_app/widgets/profile/profile_settings_widgets.dart';

// Main
////////////////////////////////////////////////////////////////////////////////
@RoutePage(name: 'Settings_Account')
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Account'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              var user = snapshot.data!.data()!;
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionDivider(context, "Banner Image"),
                      // Banner Image
                      Container(
                        height: 300,
                        width: 500,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    user['banner_image']),
                                fit: BoxFit.cover)),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateBannerImage(
                                        banner: user['banner_image'],
                                      );
                                    });
                              },
                              child: const Text('Change Banner Image'))
                        ],
                      ),
                      buildSectionDivider(context, "Profile Image"),

                      /// Profile Image
                      Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    user['profile_image']),
                                fit: BoxFit.cover)),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateProfileImage(
                                        profileImage: user['profile_image'],
                                      );
                                    });
                              },
                              child: const Text('Change Profile Image'))
                        ],
                      ),
                      buildSectionDivider(context, "User Information"),
                      // User Information
                      Card(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //////////////////////////////// User Information Name
                              Text(
                                'Name:',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  user['name'],
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize),
                                ),
                              ),

                              //////////////////////////// User Information Username
                              Text(
                                'Username:',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  user['username'],
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize),
                                ),
                              ),

                              ///////////////////////////////// User Information Bio
                              Text(
                                'Bio:',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  user['bio'],
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateUserInformation(
                                        name: user['name'],
                                        username: user['username'],
                                        bio: user['bio'],
                                      );
                                    });
                              },
                              child: const Text('Change User Information'))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }
}

// Change User Information
////////////////////////////////////////////////////////////////////////////////
class ChangeProfileInformation extends StatefulWidget {
  const ChangeProfileInformation({super.key});

  @override
  State<ChangeProfileInformation> createState() =>
      _ChangeProfileInformationState();
}

class _ChangeProfileInformationState extends State<ChangeProfileInformation> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
