import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';

@RoutePage(name: 'explore')
class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController exploreController = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool searched = false;
  late String keyword;

  @override
  void dispose() {
    _focus.dispose();
    exploreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
        physics: const NeverScrollableScrollPhysics(),
        routes: [
          const Hub(),
          Search(keyword: exploreController.text.trim()),
        ],
        builder: (context, child, tabController) {
          final tabsRouter = AutoTabsRouter.of(context);
          tabController.index = tabsRouter.activeIndex;
          return Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                backgroundColor: navBarColor,
                leading: isSmallPage(
                  context,
                  "Leading IconButton",
                ),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: Theme.of(context).canvasColor,
                    ),
                    child: TextField(
                      controller: exploreController,
                      focusNode: _focus,
                      decoration: InputDecoration(
                          hintText: 'Explore the App',
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _focus.hasFocus
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _focus.unfocus();
                                      exploreController.clear();
                                    });

                                    tabsRouter.setActiveIndex(0);
                                  },
                                  splashRadius: 20,
                                  icon: const Icon(Icons.clear))
                              : null),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _focus.unfocus();
                          setState(() {
                            keyword = value;
                          });
                          // Set Tab Index to 0 (Hub)
                          tabsRouter.setActiveIndex(0);
                        } else {
                          setState(() {
                            keyword = value;
                          });
                        }
                      },
                      onTap: () {
                        setState(() {
                          keyword = exploreController.text.trim();
                        });
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _focus.unfocus();
                          setState(() {
                            keyword = value;
                          });
                          // Set Tab Index to 0 (Hub)
                          tabsRouter.setActiveIndex(0);
                        } else {
                          setState(() {
                            keyword = value;
                          });
                          // Used to refresh Search url arguments (probably need a refresh of tab index 1 or route data)
                          tabsRouter.setActiveIndex(0);
                          // Set Tab Index to 1 (Search)
                          tabsRouter.setActiveIndex(1);
                        }
                      },
                    ),
                  ),
                ),
                actions: [
                  tabsRouter.activeIndex == 1
                      ? TextButton(onPressed: () {}, child: Text('close'))
                      : Container()
                ],
              ),
              body: _focus.hasFocus ? buildSearchQuery() : child);
        });
  }

  buildSearchQuery() {
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
  }
}
