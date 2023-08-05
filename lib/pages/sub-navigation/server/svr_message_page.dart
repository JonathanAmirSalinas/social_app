import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'server_messages')
class ServerMessagesPage extends StatefulWidget {
  const ServerMessagesPage({super.key});

  @override
  State<ServerMessagesPage> createState() => _ServerMessagesPageState();
}

class _ServerMessagesPageState extends State<ServerMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildServerMessagesEndDrawer(),
      appBar: AppBar(
        backgroundColor: navServerBar,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
        title: const Text('Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Divider
            buildSectionDivider('Request'),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () {},
                child: Container(
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  child: const Text('Request'),
                ),
              ),
            ),
            // Friends Divider
            buildSectionDivider('Messages'),
          ],
        ),
      ),
    );
  }

  buildServerMessagesEndDrawer() {
    return Container(
      width: 320,
      color: navServerBar,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            child: const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.group),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('0'),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  buildSectionDivider(String dividerName) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: navServerBar,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                dividerName,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: navServerBar,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: navServerBar,
              ),
            )
          ],
        ),
      ],
    );
  }
}
