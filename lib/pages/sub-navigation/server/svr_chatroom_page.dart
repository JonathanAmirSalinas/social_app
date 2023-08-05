import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'server_chatroom')
class ServerChatroomPage extends StatefulWidget {
  final String sid;
  const ServerChatroomPage({super.key, @PathParam('sid') required this.sid});

  @override
  State<ServerChatroomPage> createState() => _ServerChatroomPageState();
}

class _ServerChatroomPageState extends State<ServerChatroomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildServerChatroomDrawer(widget.sid),
      endDrawer: buildServerChatroomEndDrawer(widget.sid),
      appBar: AppBar(
        backgroundColor: navServerBar,
        title: Text(widget.sid),
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.notes_rounded),
              ),
            );
          })
        ],
      ),
      body: const Column(
        children: [],
      ),
    );
  }

  // Server Chatroom Drawer
  buildServerChatroomDrawer(String sid) {
    return Container(
      width: 300,
      color: navServerBar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Server Name',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize),
                          ),
                          Text(
                            '# Server ID',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
              buildServerChatroomDrawerMenu()
            ],
          ),
          const Expanded(
            child: ServerDrawerMenu(),
          ),
        ],
      ),
    );
  }

  // Server Chatroom EndDrawer
  buildServerChatroomEndDrawer(String sid) {
    return Container(
      width: 300,
      color: navServerBar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text('0'),
                              ),
                              Text('Members'),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text('0'),
                              ),
                              Text('Active'),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Expanded(
            child: ServerEndDrawerMenu(),
          ),
        ],
      ),
    );
  }

  // Drawer Menu
  buildServerChatroomDrawerMenu() {
    return Container(
      height: 120,
      width: 60,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              buildServerBottomMenu();
            },
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.view_comfy_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  buildServerBottomMenu() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        context: context,
        builder: ((context) {
          return FractionallySizedBox(
            heightFactor: .8,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: Colors.red),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            height: 150,
                            width: 225,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.green),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  color: navServerBar,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.blue,
                      ),
                      Container()
                    ],
                  ),
                ))
              ],
            ),
          );
        }));
  }
}

// Server End Drawer Tab Widget
class ServerDrawerMenu extends StatefulWidget {
  const ServerDrawerMenu({super.key});

  @override
  State<ServerDrawerMenu> createState() => _ServerDrawerMenuState();
}

class _ServerDrawerMenuState extends State<ServerDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: const TabBar(tabs: [
            Tab(text: "Chatrooms"),
          ]),
          body: TabBarView(children: [
            buildChatroomsTab(),
          ]),
        ));
  }

  buildChatroomsTab() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
            Container(
              padding: const EdgeInsets.all(4),
              child: const Text('Chatrooms'),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
          ],
        ),
      ],
    );
  }
}

// Server End Drawer Tab Widget
class ServerEndDrawerMenu extends StatefulWidget {
  const ServerEndDrawerMenu({super.key});

  @override
  State<ServerEndDrawerMenu> createState() => _ServerEndDrawerMenuState();
}

class _ServerEndDrawerMenuState extends State<ServerEndDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(tabs: [
            Tab(text: "Members"),
            Tab(text: "Activities"),
          ]),
          body: TabBarView(children: [
            buildMembersTab(),
            buildActivitiesTab(),
          ]),
        ));
  }

  buildChatroomsTab() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
            Container(
              padding: const EdgeInsets.all(4),
              child: const Text('Chatrooms'),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
          ],
        ),
      ],
    );
  }

  buildMembersTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: navServerBar,
                    )),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: const Text('Members'),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: navServerBar,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildActivitiesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
            Container(
              padding: const EdgeInsets.all(4),
              child: const Text('Activities'),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: navServerBar,
                )),
          ],
        ),
      ],
    );
  }
}
