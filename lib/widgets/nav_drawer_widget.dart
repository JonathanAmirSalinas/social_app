import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
/// NAVIGATION DRAWER                                                        ///
////////////////////////////////////////////////////////////////////////////////
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
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
              onTap: () {},
            ),
          )
        ],
      ),
    ));
  }
}
