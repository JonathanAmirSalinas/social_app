import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'Settings_Privacy_And_Safety')
class PrivacyAndSafetySettingsPage extends StatefulWidget {
  const PrivacyAndSafetySettingsPage({super.key});

  @override
  State<PrivacyAndSafetySettingsPage> createState() =>
      _PrivacyAndSafetySettingsPageState();
}

class _PrivacyAndSafetySettingsPageState
    extends State<PrivacyAndSafetySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.router.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('Privacy and Safety'),
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
