import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/services/server_services.dart';
import 'package:social_app/widgets/server/server_chatroom_widgets.dart';

@RoutePage(name: 'server_chatroom')
class ServerChatroomPage extends StatefulWidget {
  final String sid;
  const ServerChatroomPage({super.key, @PathParam('sid') required this.sid});

  @override
  State<ServerChatroomPage> createState() => _ServerChatroomPageState();
}

class _ServerChatroomPageState extends State<ServerChatroomPage> {
  bool loading = false;
  List<String> channels = [];
  @override
  void initState() {
    getServerChannels();
    super.initState();
  }

  getServerChannels() async {
    setState(() {
      loading = true;
    });
    try {
      channels = await ServerServices().getChannelList(widget.sid);
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(
            color: mainSecondaryColor,
          ))
        : Builder(builder: (context) {
            return SafeArea(
              child: AutoTabsRouter.tabBar(
                routes: [
                  for (String channel in channels)
                    Server_channel(channel: channel, sid: widget.sid),
                ],
                homeIndex: 3,
                //animatePageTransition: false,
                physics: const NeverScrollableScrollPhysics(),
                builder: (context, child, tabController) {
                  final tabsRouter = AutoTabsRouter.of(context);
                  tabController.index = tabsRouter.activeIndex;
                  return buildServerChannel(tabsRouter, child, tabController);
                },
              ),
            );
          });
  }

// Builds Server Channel
  buildServerChannel(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      drawer: buildServerChatroomDrawer(tabsRouter),
      endDrawer: buildServerChatroomEndDrawer(),
      appBar: AppBar(
        backgroundColor: mainServerRailBackgroundColor,
        title:
            buildChannelAppbarTitle(context, channels[tabsRouter.activeIndex]),
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
      body: child,
    );
  }

  // Server Chatroom Drawer
  buildServerChatroomDrawer(TabsRouter tabsRouter) {
    return Drawer(
      width: 250,
      child: Container(
        color: mainServerRailBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(child: buildServerDrawerHeader()),
                ),
                //buildServerChatroomDrawerMenu()
              ],
            ),
            Expanded(
              child: buildServerDrawerMenu(tabsRouter),
            ),
          ],
        ),
      ),
    );
  }

  // Server Drawer Header
  buildServerDrawerHeader() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('servers')
          .doc(widget.sid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var channel = snapshot.data!.data()!;
          return Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(channel['banner_image']),
                        opacity: .1,
                        fit: BoxFit.cover)),
              ),
              Container(
                height: 150,
                color: Colors.black45,
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        channel['server_name'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(channel['server_link']),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Build Server Menu
  buildServerDrawerMenu(TabsRouter tabsRouter) {
    return Container(
      color: mainNavRailBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 2,
                color: mainServerRailBackgroundColor,
              )),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return ElevatedButton(
                  onPressed: () {
                    tabsRouter.setActiveIndex(index);
                    Scaffold.of(context).closeDrawer();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: mainNavRailBackgroundColor,
                      foregroundColor: mainSecondaryColor,
                      padding: const EdgeInsets.all(4),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.centerLeft,
                      child:
                          buildDrawerChannelTabName(context, channels[index])),
                );
              }),
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: mainServerRailBackgroundColor,
                  )),
              Container(
                padding: const EdgeInsets.all(4),
                child: const Text('Channels'),
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: mainServerRailBackgroundColor,
                  )),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: channels.length - 3,
              itemBuilder: ((context, index) {
                return ElevatedButton(
                  onPressed: () {
                    tabsRouter.setActiveIndex(index + 3);
                    Scaffold.of(context).closeDrawer();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: mainNavRailBackgroundColor,
                      foregroundColor: mainSecondaryColor,
                      padding: const EdgeInsets.all(4),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.centerLeft,
                      child: buildDrawerChannelTabName(
                          context, channels[index + 3])),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  // Server Chatroom EndDrawer
  buildServerChatroomEndDrawer() {
    return Container(
      width: 300,
      color: mainServerRailBackgroundColor,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ServerEndDrawerMenu(sid: widget.sid),
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

  //
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
                  color: mainServerRailBackgroundColor,
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
class ServerEndDrawerMenu extends StatefulWidget {
  final String sid;
  const ServerEndDrawerMenu({super.key, required this.sid});

  @override
  State<ServerEndDrawerMenu> createState() => _ServerEndDrawerMenuState();
}

class _ServerEndDrawerMenuState extends State<ServerEndDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: mainNavRailBackgroundColor,
          appBar: const TabBar(
              labelColor: mainSecondaryColor,
              indicatorColor: mainSecondaryColor,
              tabs: [
                Tab(text: "Members"),
                Tab(text: "Activities"),
              ]),
          body: TabBarView(children: [
            buildMembersTab(),
            buildActivitiesTab(),
          ]),
        ));
  }

  // Members Tab
  buildMembersTab() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('servers')
                .doc(widget.sid)
                .collection('roles')
                .orderBy('rank', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var role = snapshot.data!.docs[index].data();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    color: mainServerRailBackgroundColor,
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(role['role_name']),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    color: mainServerRailBackgroundColor,
                                  )),
                            ],
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: role['members'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 1),
                                  child: Row(
                                    children: [
                                      buildServerMemberImage(
                                          context, role['members'][index]),
                                      Expanded(
                                          child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('servers')
                                              .doc(widget.sid)
                                              .collection('members')
                                              .doc(role['members'][index])
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      DocumentSnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              var member =
                                                  snapshot.data!.data()!;

                                              return Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Text(
                                                      member['member_name'],
                                                      style: TextStyle(
                                                        color: Color(
                                                            hexToInteger(member[
                                                                'member_color'])),
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .fontSize,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ))
                                    ],
                                  ),
                                );
                              })
                        ],
                      );
                    });
              } else {
                return Container();
              }
            },
          ),
        )
      ],
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
                  color: mainServerRailBackgroundColor,
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
                  color: mainServerRailBackgroundColor,
                )),
          ],
        ),
      ],
    );
  }
}
