import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'help')
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
        title: const Text("Help Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Help"),
      ),
    );
  }
}
