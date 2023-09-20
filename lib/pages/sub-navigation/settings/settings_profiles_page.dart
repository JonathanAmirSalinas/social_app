import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'Settings_Profiles')
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.router.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text('Profiles'),
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
