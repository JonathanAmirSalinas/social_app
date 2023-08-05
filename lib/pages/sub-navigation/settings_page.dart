import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'setting')
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Settings Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Settings"),
      ),
    );
  }
}
