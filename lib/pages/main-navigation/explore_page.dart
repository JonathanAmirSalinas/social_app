import 'package:flutter/material.dart';
import 'package:social_app/pages/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/ep_media_page.dart';
import 'package:social_app/pages/sub-navigation/ep_news_page.dart';
import 'package:social_app/pages/sub-navigation/ep_server_page.dart';
import 'package:social_app/pages/sub-navigation/ep_trending_page.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        exploreController.clear();
        _focus.unfocus();
        setState(() {});
      },
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: isSmallPage(context, "Drawer"),
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    leading: isSmallPage(context, "Leading IconButton"),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.height * .70,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
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
                    centerTitle: true,
                  ),
                  // TABBAR
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
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
              body: const TabBarView(
                children: [
                  TrendingPage(),
                  NewsPage(),
                  MediaPage(),
                  ServerPage()
                ],
              ),
            ),
          )),
    );
  }
}
