import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'explore')
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        Hub_trending_tab(),
        Hub_news_tab(),
        Hub_media_tab(),
        Hub_servers_tab(),
      ],
      builder: (context, child, tabController) {
        final tabsRouter = AutoTabsRouter.of(context);
        tabController.index = tabsRouter.activeIndex;
        return buildExploreTabs(tabsRouter, child, tabController);
      },
    );
  }

  // Main Explore Page
  buildExploreTabs(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {});
        },
        child: DefaultTabController(
            length: 4,
            initialIndex: tabController.index,
            child: Scaffold(
              backgroundColor: mainBackgroundColor,
              drawer: isSmallPage(context, "Drawer"),
              resizeToAvoidBottomInset: false,
              body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      // TABBAR
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          TabBar(
                            controller: tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: mainSecondaryColor,
                            onTap: tabsRouter.setActiveIndex,
                            tabs: const [
                              Tab(text: "Trending"),
                              Tab(text: "News"),
                              Tab(text: "Media"),
                              Tab(text: "Servers"),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: child),
            )));
  }
}


/* buildSearchQuery() {
    return Builder(builder: (context) {
      return GestureDetector(
          onTap: () {
            setState(() {
              FocusManager.instance.primaryFocus?.unfocus();
              _focus.unfocus();
            });
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: backgroundColorSolid,
                  child: keyword.isEmpty
                      ? buildRecentlySearchItemList(context)
                      : keyword.characters.elementAt(0) == '#'
                          ? buildHashtagsSearchItemList(context)
                          : keyword.characters.elementAt(0) == '@'
                              ? buildUsernameSearchItemList(context)
                              : buildNameSearchItemList(context, keyword),
                ),
              ),
            ],
          ));
    });
  }

  /// Build Searh Bar Item For Name
  buildNameSearchItemList(BuildContext context, String keyword) {
    return Builder(builder: (context) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                      // Empty Search bar
                      if (keyword.isEmpty) {
                        return Text(keyword);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase())) {
                        return buildSearchItemCardUser(
                            context, snapshot.data!.docs[index].data());
                      } else {
                        return Container();
                      }
                    });
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildSearchItemCardUser(
                          context, snapshot.data!.docs[index].data());
                    });
            }
          });
    });
  }

  /// Build Searh Bar Item 'Recently Searched'
  buildRecentlySearchItemList(BuildContext context) {
    return Builder(builder: (context) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                      // Empty Search bar
                      if (keyword.isEmpty) {
                        return Text(keyword);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase())) {
                        return buildSearchItemCardUser(
                            context, snapshot.data!.docs[index].data());
                      } else {
                        return Container();
                      }
                    });
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildSearchItemCardUser(
                          context, snapshot.data!.docs[index].data());
                    });
            }
          });
    });
  }

  /// Build Search Bar Item For '@'s
  buildUsernameSearchItemList(BuildContext context) {
    return Builder(builder: (context) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                      // Empty Search bar
                      if (keyword.isEmpty) {
                        return Text(keyword);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['username']
                          .toString()
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase())) {
                        return buildSearchItemCardUser(
                            context, snapshot.data!.docs[index].data());
                      } else {
                        return Container();
                      }
                    });
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildSearchItemCardUser(
                          context, snapshot.data!.docs[index].data());
                    });
            }
          });
    });
  }

  /// Build Searh Bar Item for '#'s
  buildHashtagsSearchItemList(BuildContext context) {
    return Builder(builder: (context) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('hashtags').snapshots(),
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
                      // Empty Search bar
                      if (keyword.isEmpty) {
                        return Text(keyword);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['tag']
                          .toString()
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase())) {
                        return buildSearchItemCard(
                            context, snapshot.data!.docs[index].data());
                      } else {
                        return Container();
                      }
                    });
              case ConnectionState.done:
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // Empty Search bar
                      if (keyword.isEmpty) {
                        return Text(keyword);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['tag']
                          .toString()
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase())) {
                        return buildSearchItemCard(
                            context, snapshot.data!.docs[index].data());
                      } else {
                        return Container();
                      }
                    });
            }
          });
    });
  }

  // Builds User Card
  buildSearchItemCardUser(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/profile/${data['uid']}');
      },
      child: Card(
        color: navBarColor,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          margin: const EdgeInsets.all(2),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                data['profile_image']),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize),
                        ),
                        Text(data['username']),
                        Row(
                          children: [
                            Text(
                                'followers ${data['followers'].length.toString()}   '),
                            Text(
                                'following ${data['following'].length.toString()}'),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Search
  buildSearchItemCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        String tag = data['tag'].toString().substring(1);
        context.router.pushNamed('/search/$tag');
      },
      child: Card(
        color: navBarColor,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['tag'],
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: double.infinity,
                    child: Text(
                      '${data['posts'].length.toString()} tags',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .fontSize),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  } */