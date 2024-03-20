import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/server/create_server.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/drawers/nav_drawer_widget.dart';

@RoutePage(name: 'servers')
class ServersPage extends StatefulWidget {
  final String? sid;
  const ServersPage({super.key, this.sid});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  TextEditingController searchDrawerController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Builder(builder: (context) {
      return SafeArea(
        child: AutoTabsRouter.tabBar(
          routes: [
            const Server_messages(),
            for (String servers in userProvider.getUser.servers)
              Server_chatroom(sid: servers),
          ],
          physics: const NeverScrollableScrollPhysics(),
          animatePageTransition: false,
          builder: (context, child, tabController) {
            final tabsRouter = AutoTabsRouter.of(context);
            tabController.index = tabsRouter.activeIndex;
            return buildServerRoom(tabsRouter, child, tabController);
          },
        ),
      );
    });
  }

  buildServerRoom(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return Scaffold(
        body: Row(
      children: [
        buildServerRail(tabsRouter),
        Expanded(child: child),
      ],
    ));
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Server Navigation Rail
  //////////////////////////////////////////////////////////////////////////////
  buildServerRail(TabsRouter tabsRouter) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Builder(builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: 60,
        color: mainServerRailBackgroundColor,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(children: [
            GestureDetector(
              onTap: () {
                tabsRouter.setActiveIndex(0);
              },
              child: Container(
                height: 52,
                width: 52,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: tabsRouter.activeIndex == 0
                      ? Border.all(color: Colors.white54, width: 2)
                      : null,
                  borderRadius: const BorderRadius.all(
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
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userProvider.getServers.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          tabsRouter.setActiveIndex(index + 1);
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: tabsRouter.activeIndex == index + 1
                                ? Border.all(color: Colors.white54, width: 2)
                                : null,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(userProvider
                                    .getServers[index]['server_image']),
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    }))),
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
                  onPressed: () {
                    buildCreateServerDialog(context);
                  },
                  tooltip: "Create Server",
                  splashRadius: 20,
                  icon: const Icon(Icons.add)),
            ),
          ]),
        ),
      );
    });
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

  // Creates a Dialog Used to create a Post
  buildCreateServerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const CreateServer();
      },
    );
  }

////////////////
}
