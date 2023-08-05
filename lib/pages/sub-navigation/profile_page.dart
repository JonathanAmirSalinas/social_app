import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'profile')
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth <= webScreenSize) {
        return buildMobileProfilePage(constraints.maxWidth);
      } else {
        return buildWebProfilePage(constraints.maxWidth);
      }
    }));
  }

  buildMobileProfilePage(double constraints) {
    return Scaffold(
      backgroundColor: navBarColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Mobile Profile Page"),
        centerTitle: true,
      ),
      body: const Row(
        children: [],
      ),
    );
  }

  buildWebProfilePage(double constraints) {
    return Scaffold(
      backgroundColor: navBarColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Web Profile Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 180,
                    width: 280,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.red),
                  ),
                  Expanded(
                      child: Container(
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize),
                              ),
                              Text(
                                "@username",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                              Text(
                                "email123@gmail.com",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                              Text(
                                'bio: ',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.accessibility_new_rounded),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "Followers",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          "0",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Following",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          "0",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 3,
              color: primaryColor,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: buildPinnedSection(),
                      )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                                color: Colors.pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: buildBookmarkedSection(),
                          )),
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: buildPostsSection(),
                )),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: buildRecentSection(),
                      )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                                color: Colors.brown,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: buildServersSection(),
                          )),
                    ],
                  ),
                )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  // Pinned Section
  buildPinnedSection() {
    return Column(
      children: [
        buildSectionDivider('Pinned'),
      ],
    );
  }

  // Bookmarked Section
  buildBookmarkedSection() {
    return Column(
      children: [
        buildSectionDivider('Bookmarked'),
      ],
    );
  }

  // Posts Section
  buildPostsSection() {
    return Column(
      children: [
        buildSectionDivider('Posts'),
      ],
    );
  }

  // Recent Section
  buildRecentSection() {
    return Column(
      children: [
        buildSectionDivider('Recent'),
      ],
    );
  }

  // Server Section
  buildServersSection() {
    return Column(
      children: [
        buildSectionDivider('Servers'),
      ],
    );
  }

  // Section Title Divider
  buildSectionDivider(String section) {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: primaryColor,
        )),
        Text(
          section,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
        ),
        Expanded(
            flex: 8,
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: primaryColor,
            )),
      ],
    );
  }
}

/*  buildProfileBody() {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const TabBar(tabs: [
          Tab(text: 'Home'),
          Tab(text: 'Posts'),
          Tab(text: 'Media'),
          Tab(text: 'Likes'),
          Tab(text: 'Servers'),
        ]),
        body: TabBarView(children: [
          buildProfileHomePage(),
          buildProfilePostsPage(),
          Container(
            color: Colors.purple,
            child: const SingleChildScrollView(),
          ),
          Container(
            color: Colors.orange,
            child: const SingleChildScrollView(),
          ),
          Container(
            color: Colors.teal,
            child: const SingleChildScrollView(),
          ),
        ]),
      ),
    );
  } */

/*Row(
          children: [
            Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: primaryColor),
                  ),
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                    ),
                  ),
                  Container(
                    child: Text(
                      '@username',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .fontSize),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('Followers'),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('0'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Following'),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('0'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Posts'),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('0'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                    color: primaryColor,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      const ListTile(
                        title: Text('Profile'),
                      ),
                      const ListTile(
                        title: Text('Profile'),
                      ),
                      const ListTile(
                        title: Text('Profile'),
                      ),
                      const ListTile(
                        title: Text('Profile'),
                      ),
                      Expanded(child: Container()),
                      ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.logout_rounded),
                        title: Container(
                            alignment: Alignment.centerRight,
                            child: Text('Logout')),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              height: double.infinity,
              width: 3,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: primaryColor),
            ),
            Expanded(child: buildProfileBody())
          ],
        ), */
