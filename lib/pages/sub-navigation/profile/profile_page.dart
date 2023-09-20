import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/services/time_services.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/content/post_widget.dart';
import 'package:social_app/widgets/content/re_post_widget.dart';
import 'package:social_app/widgets/profile/profile_settings_widgets.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'profile')
class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, @PathParam('uid') required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return buildProfileBody(constraints.maxWidth);
    }));
  }

  buildProfileBody(double constraints) {
    return Scaffold(
        backgroundColor: navBarColor,
        endDrawer: widget.uid == FirebaseAuth.instance.currentUser!.uid
            ? buildProfileEndDrawerMenu()
            : buildProfileUserDrawerMenu(),
        endDrawerEnableOpenDragGesture: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.router.pushNamed('/');
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.align_horizontal_right_rounded));
            })
          ],
        ),
        body: Row(
          children: [
            constraints > 1600 ? Expanded(child: Container()) : Container(),
            Flexible(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(4),
                child: DefaultTabController(
                  length: 5,
                  child: Scaffold(
                    //drawer: const NavigationDrawer(),
                    body: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              leading: Container(),
                              backgroundColor: backgroundColor,
                              expandedHeight: kIsWeb ? 400 : 300,
                              flexibleSpace: FlexibleSpaceBar(
                                  background:
                                      buildProfileBackground(constraints)),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverAppBarDelegate(
                                const TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: [
                                    Tab(text: "Home"),
                                    Tab(text: "Posts"),
                                    Tab(text: "Posts & Replies"),
                                    Tab(text: "Media"),
                                    Tab(text: "Likes"),
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                        body: TabBarView(
                          children: [
                            buildHomeSection(),
                            buildPostsSection(),
                            buildPostsAndRepliesSection(),
                            buildMediaSection(),
                            buildLikesSection(),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            constraints > 1280
                ? Expanded(child: buildProfileSideMenu())
                : Container()
          ],
        ));
  }

  // Builds Follow/Following Button
  buildProfileUserDrawerMenu() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return SafeArea(
              child: Container(
            width: 300,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6)),
                      color: cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: buildUserStatus(
                              user['status'],
                            ),
                          )),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.message_rounded),
                            iconSize: 18,
                          ),
                        ],
                      ),
                      Card(
                        margin: const EdgeInsets.all(2),
                        shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: ListTile(
                          onTap: () {},
                          title: const Text('Send Friend Request'),
                          subtitle: const Text('Send a Friend Request...'),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.all(2),
                        shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: ListTile(
                          onTap: () {
                            ContentServices().followUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.uid,
                            );
                          },
                          title: user['followers'].toString().contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? const Text('Following')
                              : const Text('Follow'),
                          subtitle: const Text('Follow to keep track...'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        } else {
          return Container();
        }
      },
    );
  }

  // Builds User Status
  buildUserStatus(String status) {
    switch (status) {
      case 'Online':
        return Row(
          children: [
            Text(
              "Status: ",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
            const Icon(
              Icons.circle,
              color: Colors.green,
              size: 10,
            )
          ],
        );
      case 'Offline':
        return Row(
          children: [
            Text(
              "Status: ",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
            const Icon(
              Icons.circle,
              color: Colors.red,
              size: 10,
            )
          ],
        );
      case 'Busy':
        return Row(
          children: [
            Text(
              "Status: ",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
            const Icon(
              Icons.circle,
              color: Colors.grey,
              size: 10,
            )
          ],
        );

      default:
    }
  }

  // Builds Profile Flexiable Space
  buildProfileBackground(double constraints) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    // Banner
                    Container(
                      height: kIsWeb ? 300 : 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  user['banner_image']),
                              fit: BoxFit.cover)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: kIsWeb ? 150 : 130,
                                width: kIsWeb ? 200 : 180,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3, color: backgroundColorSolid),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            user['profile_image']),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'],
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .fontSize),
                                        ),
                                        Text(
                                          user['username'],
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .fontSize),
                                        ),
                                        Text(
                                          user['email'],
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .fontSize),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                buildProfileStats(
                                                    user['followers']
                                                        .length
                                                        .toString(),
                                                    'Followers'),
                                                buildProfileStats(
                                                    user['following']
                                                        .length
                                                        .toString(),
                                                    'Following'),
                                                kIsWeb
                                                    ? buildProfileStats(
                                                        user['posts']
                                                            .length
                                                            .toString(),
                                                        'Posts')
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Profile End Drawer
  buildProfileEndDrawerMenu() {
    return SafeArea(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              var user = snapshot.data!.data()!;
              return Container(
                width: kIsWeb ? 300 : 250,
                padding: const EdgeInsets.all(2),
                color: backgroundColorSolid,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                          height: 160,
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.topLeft,
                          child: buildUserStatus(user['status']),
                        )),
                        Container(
                          height: 160,
                          margin: const EdgeInsets.all(2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.router.pushNamed('/settings');
                                      },
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.settings,
                                        size: 18,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.notifications_none_rounded,
                                        size: 18,
                                      )),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.logout,
                                    size: 18,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Expanded(
                      child: ProfileEndDrawerMenu(),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  //
  buildProfileSideMenu() {
    return Column(
      children: [
        Expanded(
            flex: 2,
            child: Card(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: navBarColor),
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                      controller: searchController,
                      //focusNode: _focus,
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          border: const OutlineInputBorder(),
                          fillColor: secondaryColor,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _focus.hasFocus
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                  splashRadius: 20,
                                  icon: const Icon(Icons.clear))
                              : null),
                      onChanged: (value) {
                        setState(() {
                          // name = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          // name = searchController.text;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          // name = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            )),
        Expanded(
          flex: 3,
          child: Card(
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Container(),
          ),
        ),
      ],
    );
  }

  // Builds User Stats
  buildProfileStats(String stat, String label) {
    return Container(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              stat,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize),
          ),
        ],
      ),
    );
  }

  // Profile Home Section
  buildHomeSection() {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: buildProfileBio(),
                  ),
                ),
                buildLinkedMedia(),
              ],
            ),
            Container(
              width: 4,
              color: Colors.red,
            ),
            buildBookmarkedContent(),
          ],
        ),
      ),
    );
  }

  // Build User's Bio
  buildProfileBio() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!.data()!;
            return Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bio:'),
                        Container(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            user['bio'],
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  // Profile Linked Accounts
  buildLinkedMedia() {
    return Container(
      height: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: fillColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.discord_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Link'))
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.snapchat_rounded,
                      color: Colors.yellow,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Link'))
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.facebook_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Link'))
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.tiktok_rounded,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Link'))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Profile Bookmarked
  buildBookmarkedContent() {
    return Column(
      children: [
        buildSectionDivider(context, 'Bookmarked'),
        Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: Colors.blue),
        )
      ],
    );
  }

  // Profile Posts Section Tab
  buildPostsSection() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .where('id_content_owner', isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });

                    case ConnectionState.done:
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });
                  }
                }),
          ),
        ],
      ),
    );
  }

  // Profile Posts & Replies Section Tab
  buildPostsAndRepliesSection() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('id_content_owner', isEqualTo: widget.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });

                    case ConnectionState.done:
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });
                  }
                }),
          ),
        ],
      ),
    );
  }

  // Profile Media Section Tab
  buildMediaSection() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('id_content_owner', isEqualTo: widget.uid)
                    .where('hasMedia', isEqualTo: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });

                    case ConnectionState.done:
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });
                  }
                }),
          ),
        ],
      ),
    );
  }

  // Profile Likes Section Tab
  buildLikesSection() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('likes', arrayContains: widget.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });

                    case ConnectionState.done:
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var content = snapshot.data!.docs[index].data();
                            switch (content['type']) {
                              case 'post':
                                return BuildPostContent(content: content);
                              case 're_post':
                                return BuildRePostContent(content: content);
                              case 'ad':
                                return Container();
                              case 'server_link':
                                return Container();
                              case 'server_post':
                                return Container();
                              default:
                                return Container();
                            }
                          });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////// Profile End Drawer

// Profile End Drawer
class ProfileEndDrawerMenu extends StatefulWidget {
  const ProfileEndDrawerMenu({super.key});

  @override
  State<ProfileEndDrawerMenu> createState() => _ProfileEndDrawerMenuState();
}

class _ProfileEndDrawerMenuState extends State<ProfileEndDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(tabs: [
            Tab(text: "Friends"),
            Tab(text: "Messages"),
          ]),
          body: TabBarView(children: [
            buildFriendsTab(),
            buildActivityTab(),
          ]),
        ));
  }

  buildFriendsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Active',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
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
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Unactive',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
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
    );
  }

  // Profile Message Tab
  buildActivityTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildActivityTile(),
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
                child: Text(
                  'Messages',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      fontWeight: FontWeight.w400),
                ),
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
          buildMessageTileList(),
        ],
      ),
    );
  }

  // Activity Tile Notifications (Friend Request and )
  buildActivityTile() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notifications')
            .where('seen', isEqualTo: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var notifictions = snapshot.data!.docs.length;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: ListTile(
                  onTap: () {},
                  // Display Number of UnSeen Messages

                  leading: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.red),
                    child: Text(
                      notifictions.toString(),
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(
                    'Activity',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Friend Requests, New Messages, etc.',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize),
                  ),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: ListTile(
                  onTap: () {},
                  // Display Number of UnSeen Messages
                  leading: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Colors.red),
                      child: const CircularProgressIndicator()),
                  title: Text(
                    'Activity',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Friend Requests, New Messages, etc.',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize),
                  ),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            );
          }
        });
  }

  // Message List
  buildMessageTileList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('private chats')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var snap = snapshot.data!.docs[index].data();
                    return buildMessageTile(snap['id_chat']);
                  });

            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var snap = snapshot.data!.docs[index].data();
                    return buildMessageTile(snap['id_chat']);
                  });
          }
        });
  }

  // Message Tile
  buildMessageTile(String chatID) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatID)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              var snap = snapshot.data!.data()!;
              return Card(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: ListTile(
                      onTap: () {
                        /*snap['members'][0] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Navigator.of(context).pushNamed('/chat',
                                arguments: snap['members'][1])
                            : Navigator.of(context).pushNamed('/chat',
                                arguments: snap['members'][0]);*/
                      },
                      // Display Number of UnSeen Messages
                      leading: snap['members'][0] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? buildUserProfileImage(context, snap['members'][1])
                          : buildUserProfileImage(context, snap['members'][0]),
                      title: snap['members'][0] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? buildUserChatTile(
                              snap['members'][1], snap['timestamp'])
                          : buildUserChatTile(
                              snap['members'][0], snap['timestamp']),
                      subtitle: Text(
                        snap['recent_message'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              );
            case ConnectionState.done:
              var snap = snapshot.data!.data()!;
              return Card(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: ListTile(
                      onTap: () {
                        /*snap['members'][0] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Navigator.of(context).pushNamed('/chat',
                                arguments: snap['members'][1])
                            : Navigator.of(context).pushNamed('/chat',
                                arguments: snap['members'][0]);*/
                      },
                      // Display Number of UnSeen Messages
                      leading: snap['members'][0] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? buildUserProfileImage(context, snap['members'][1])
                          : buildUserProfileImage(context, snap['members'][0]),
                      title: snap['members'][0] ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? buildUserChatTile(
                              snap['members'][1], snap['timestamp'])
                          : buildUserChatTile(
                              snap['members'][0], snap['timestamp']),
                      subtitle: Text(
                        snap['recent_message'],
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              );
          }
        });
  }

  // Message Tile User Information
  buildUserChatTile(String uid, int timestamp) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return SizedBox(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user['name'],
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize),
                        ),
                        Text(
                          ' \u2022 ${timeAgoSinceDate(timestamp)}',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        ),
                      ],
                    ),
                  ],
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
}
