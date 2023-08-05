import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'server_home')
class ServerHomePage extends StatefulWidget {
  const ServerHomePage({super.key});

  @override
  State<ServerHomePage> createState() => _ServerHomePageState();
}

class _ServerHomePageState extends State<ServerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navServerBar,
        leading: Container(),
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            // User Info Row
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.red),
                ),
                Expanded(
                    child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.blue),
                ))
              ],
            ),
            // Quick Filter
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.purple),
                ))
              ],
            ),
            // Filter Info
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 300,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.green),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
