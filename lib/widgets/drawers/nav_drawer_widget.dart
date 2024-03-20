import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

////////////////////////////////////////////////////////////////////////////////
/// MAIN NAVIGATION DRAWER                                                        ///
////////////////////////////////////////////////////////////////////////////////
class SliverNavigationDrawer extends StatelessWidget {
  const SliverNavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: navDrawerBackgroundColor,
        width: kIsWeb ? 280 : 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      );

  // Builds Profile Header (User Info)
  Widget buildHeader(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                      height: 160,
                      width: 280,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          user['profile_image']),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.donut_large_rounded,
                                        color: mainSecondaryColor,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.account_circle_rounded,
                                        color: mainSecondaryColor,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            user['name'],
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(user['username']),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Build NAvigation Drawer Menu
  Widget buildMenuItems(BuildContext context) {
    return Flexible(
        child: SingleChildScrollView(
      child: Wrap(
        runSpacing: 0,
        alignment: WrapAlignment.center,
        children: [
          const Divider(
            color: Colors.white30,
            thickness: 2,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
                onPressed: () {
                  context.router.navigateNamed('/main/home');
                  Scaffold.of(context).closeDrawer();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    iconColor: navDrawerItemColor,
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                icon: const Icon(
                  Icons.home_outlined,
                  size: 28,
                ),
                label: Text(
                  'Home  ',
                  style: TextStyle(
                      color: navDrawerItemColor,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                )),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
                onPressed: () {
                  context.router.navigateNamed('/main/explore/trending');
                  Scaffold.of(context).closeDrawer();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    iconColor: navDrawerItemColor,
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                icon: const Icon(
                  Icons.search,
                  size: 28,
                ),
                label: Text(
                  'Explore',
                  style: TextStyle(
                      color: navDrawerItemColor,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                )),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
                onPressed: () {
                  context.router.navigateNamed('/main/activity/notifications');
                  Scaffold.of(context).closeDrawer();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    iconColor: navDrawerItemColor,
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                ),
                label: Text(
                  'Activity',
                  style: TextStyle(
                      color: navDrawerItemColor,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                )),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
                onPressed: () {
                  context.router.navigateNamed('/main/servers');
                  Scaffold.of(context).closeDrawer();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    iconColor: navDrawerItemColor,
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                icon: const Icon(
                  Icons.space_dashboard_rounded,
                  size: 28,
                ),
                label: Text(
                  'Servers',
                  style: TextStyle(
                      color: navDrawerItemColor,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                )),
          ),
          const Divider(),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.red),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blue),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.green),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.orange),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.purple),
          ),
        ],
      ),
    ));
  }
}

// Build
buildFooter() {
  return Expanded(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: const Icon(Icons.logout),
      )
    ],
  ));
}

////////////////////////////////////////////////////////////////////////////////
/// SERVER CHAT END DRAWER
////////////////////////////////////////////////////////////////////////////////
buildServerChatEndDrawer(
    BuildContext context, TextEditingController controller) {
  return Drawer(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // End Drawer Header
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: Theme.of(context).canvasColor,
                      ),
                      // TextField
                      child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ))),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Header Body
                        Expanded(
                            child: Column(children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 110,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: const Color.fromARGB(
                                            255, 15, 67, 17)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context).canvasColor),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Active Members'), Text('1')],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context).canvasColor),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Members'), Text('1')],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context).canvasColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context).canvasColor),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Theme.of(context).canvasColor),
                              ),
                            ],
                          )
                        ])),
                        const VerticalDivider(
                          thickness: 2,
                        ),
                        // Header Icons
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {},
                                splashRadius: 20,
                                icon: const Icon(
                                    Icons.vertical_distribute_sharp)),
                            IconButton(
                                onPressed: () {},
                                splashRadius: 20,
                                icon: const Icon(Icons.notifications)),
                            IconButton(
                                onPressed: () {},
                                splashRadius: 20,
                                icon: const Icon(Icons.settings)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // End Drawer Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Body Title
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.green),
                                  child: Text(
                                    'Chat',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.green),
                                  child: const Text('Members')),
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.green),
                                  child: const Text('Announcements')),
                            ],
                          )),
                      // Body
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Theme.of(context).canvasColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Chats'),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            margin: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            index.toString())));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '# Chat ${index.toString()}',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .fontSize),
                                                      ),
                                                    ]),
                                              ),
                                            ));
                                      }),
                                ),
                              ],
                            )),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ));
}
