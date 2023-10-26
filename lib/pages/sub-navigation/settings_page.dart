import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/profile/profile_settings_widgets.dart';

@RoutePage(name: 'settings')
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorSolid,
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        centerTitle: true,
        title: const Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /////////// Settings /////////////////////////////////////////
            buildSectionDivider(context, 'Settings'),
            buildProfileSettingsTile(
                context,
                FirebaseAuth.instance.currentUser!.uid,
                "Account",
                "Account",
                "Manage Your Account Information. E.g. Name, Username, Email, Profile Image, etc."),
            buildProfileSettingsTile(
                context,
                FirebaseAuth.instance.currentUser!.uid,
                "Profiles",
                "Profiles",
                "Manage Your Server Profiles"),
            buildProfileSettingsTile(
                context,
                FirebaseAuth.instance.currentUser!.uid,
                "Privacy",
                "Privacy & Safety",
                "Manage Your Privacy and Safety Setting."),
            ////////// Billing ///////////////////////////////////////////
            buildSectionDivider(context, 'Billings'),
            buildProfileSettingsTile(
                context,
                "Billing",
                FirebaseAuth.instance.currentUser!.uid,
                "Billing",
                "Manage Your Billings."),
            buildProfileSettingsTile(
                context,
                FirebaseAuth.instance.currentUser!.uid,
                "Premium",
                "Premium",
                "Manage your Premium Subscription"),
            ////////// Support ///////////////////////////////////////////
            buildSectionDivider(context, 'Support'),
            buildProfileSettingsTile(
                context,
                "Support",
                FirebaseAuth.instance.currentUser!.uid,
                "Support",
                "Support Information"),
            buildProfileSettingsTile(
                context,
                "Help",
                FirebaseAuth.instance.currentUser!.uid,
                "Help Center",
                "Ask For Assistance"),
          ],
        ),
      ),
    );
  }
}
