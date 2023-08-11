import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
/// MAIN NAVIGATION DRAWER                                                        ///
////////////////////////////////////////////////////////////////////////////////
class SliverNavigationDrawer extends StatelessWidget {
  const SliverNavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      );

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width * .6,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: const Text(
                          "Name",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: const Text("Username"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Flexible(
        child: SingleChildScrollView(
      child: Wrap(
        runSpacing: 0,
        children: [
          const Divider(
            color: Colors.white30,
            thickness: 2,
          ),
          Card(
            child: ListTile(
                leading: const Icon(
                  Icons.home_outlined,
                  size: 24,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () async {}),
          ),
          Card(
            child: ListTile(
                leading: const Icon(
                  Icons.account_box_outlined,
                  size: 24,
                ),
                title: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {}),
          ),
          Card(
            child: ListTile(
                leading: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 24,
                ),
                title: const Text(
                  "Bookmarked",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {}),
          ),
          Card(
            child: ListTile(
                leading: const Icon(Icons.help_center),
                title: const Text(
                  "Help",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {}),
          ),
          Card(
            child: ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  size: 24,
                ),
                title: const Text(
                  "Settings",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {}),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                size: 24,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                context.router.root.pushNamed('/');
              },
            ),
          )
        ],
      ),
    ));
  }
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
                            child: Container(
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
                                    children: [
                                      Text('Active Members'),
                                      Text('1')
                                    ],
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
                          ]),
                        )),
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
