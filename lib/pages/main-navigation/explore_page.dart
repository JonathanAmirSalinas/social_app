import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

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
  late String name;

  @override
  void dispose() {
    _focus.dispose();
    exploreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        Trending_tab(),
        News_tab(),
        Media_tab(),
        Servers_tab(),
      ],
      builder: (context, child, tabController) {
        final tabsRouter = AutoTabsRouter.of(context);
        tabController.index = tabsRouter.activeIndex;
        return _focus.hasFocus
            ? buildSearchPage()
            : buildExploreTabs(tabsRouter, child, tabController);
      },
    );
  }

  // Builds Search Page (Search Bar)
  //////////////////////////////////////////////////////////////////////////////
  buildSearchPage() {
    return Scaffold(
        backgroundColor: backgroundColorSolid,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                //exploreController.clear();
                _focus.unfocus();
                setState(() {});
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
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
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Explore the App',
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _focus.hasFocus
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                exploreController.clear();
                              });
                            },
                            splashRadius: 20,
                            icon: const Icon(Icons.clear))
                        : null),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                onTap: () {
                  setState(() {
                    name = exploreController.text;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
          ),
        ),
        body: buildSearchItemList(context));
  }

  /// Build Searh Bar Item
  buildSearchItemList(BuildContext context) {
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
                      if (name.isEmpty) {
                        return Text(name);
                      }
                      //
                      else if (snapshot.data!.docs[index]
                          .data()['name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return buildSearchItemCard(
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
                      return buildSearchItemCard(
                          context, snapshot.data!.docs[index].data());
                    });
            }
          });
    });
  }

  buildSearchItemCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/profile/${data['uid']}');
      },
      child: Card(
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

  buildExploreTabs(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          //exploreController.clear();
          _focus.unfocus();
          setState(() {});
        },
        child: DefaultTabController(
            length: 4,
            initialIndex: tabController.index,
            child: Scaffold(
              backgroundColor: backgroundColor,
              drawer: isSmallPage(context, "Drawer"),
              resizeToAvoidBottomInset: false,
              body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        pinned: true,
                        floating: true,
                        snap: true,
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _focus.hasFocus
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              exploreController.clear();
                                            });
                                          },
                                          splashRadius: 20,
                                          icon: const Icon(Icons.clear))
                                      : null),
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  name = exploreController.text;
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // TABBAR
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          TabBar(
                            controller: tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
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
