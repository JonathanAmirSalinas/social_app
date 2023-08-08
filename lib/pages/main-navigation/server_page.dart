import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/drawers/nav_drawer_widget.dart';

@RoutePage(name: 'servers')
class ServersPage extends StatefulWidget {
  final String? sid; // <- Get from provider
  const ServersPage({super.key, this.sid});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  late String serverRailController;
  TextEditingController searchDrawerController = TextEditingController();
  List sid = [
    "first",
    "second",
    "third",
    "first",
    "second",
    "third",
    "first",
    "second",
    "third",
    "first",
    "second",
    "third",
    "first",
    "second",
    "third",
    "first",
    "second",
    "third"
  ];

  @override
  void initState() {
    serverRailController = sid[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AutoTabsRouter.tabBar(
        routes: [
          const Server_home(),
          const Server_messages(),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
          Server_chatroom(sid: sid[0]),
          Server_chatroom(sid: sid[1]),
          Server_chatroom(sid: sid[2]),
        ],
        animatePageTransition: false,
        builder: (context, child, tabController) {
          final tabsRouter = AutoTabsRouter.of(context);
          tabController.index = tabsRouter.activeIndex;
          return buildServerRoom(tabsRouter, child, tabController);
        },
      ),
    );
  }

  buildServerRoom(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();

          setState(() {});
        },
        child: Row(
          children: [buildServerRail(tabsRouter), Expanded(child: child)],
        ));
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Server Navigation Rail
  //////////////////////////////////////////////////////////////////////////////
  buildServerRail(TabsRouter tabsRouter) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 60,
      color: navServerBar,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(children: [
            // Server Home Menu
            GestureDetector(
              onTap: () {
                tabsRouter.setActiveIndex(0);
              },
              child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Icon(Icons.dashboard),
              ),
            ),
            GestureDetector(
              onTap: () {
                tabsRouter.setActiveIndex(1);
              },
              child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Icon(Icons.message),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            /////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: MediaQuery.of(context).size.height * .78,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: sid.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        tabsRouter.setActiveIndex(index + 2);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const Divider(
              thickness: 3,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),

            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                  onPressed: () {},
                  tooltip: "Create Server",
                  splashRadius: 20,
                  icon: const Icon(Icons.add)),
            ),
          ]),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Controller Function for Navigating through Navigation Rail
  //////////////////////////////////////////////////////////////////////////////
  buildSelectedServer(String sid) {
    if (sid == "main") {
      return buildServerHomeMenu();
    } else {
      return buildServerChat(sid);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Main Chat Block Using Server ID
  //////////////////////////////////////////////////////////////////////////////
  buildServerChat(String sid) {
    return Expanded(
      child: Scaffold(
          endDrawer: buildServerChatEndDrawer(context, searchDrawerController),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).cardColor,
            leading: Container(),
            title: Text(
              sid,
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
            ),
            actions: [
              Builder(builder: (context) {
                return Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        splashRadius: 25,
                        iconSize: 25,
                        icon: const Icon(Icons.view_list_rounded)));
              })
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      sid,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds the User's Home Menu Panel
  //////////////////////////////////////////////////////////////////////////////
  buildServerHomeMenu() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.height * .14,
                            margin: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.indigoAccent),
                            child: const Text("Image"),
                          ),
                          Row(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Friends"),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Servers"),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Awards"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .fontSize),
                                  ),
                                  const Text("  @username")
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .12,
                              width: MediaQuery.of(context).size.width * .2,
                              margin: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.indigoAccent),
                              child: const Text("Options Panel (Grid)"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Text("Stats"),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Text("Manage Servers"),
                  ),
                ),
              )
            ],
          ),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text("Pinned Item/Media"),
            ),
          ),
        ],
      ),
    ));
  }

////////////////
}
