import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/main/main_web_navigation_rail.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'search')
class SearchPage extends StatefulWidget {
  final String keyword;
  const SearchPage({super.key, required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focus = FocusNode();
  late String keyword;

  @override
  void initState() {
    keyword = widget.keyword;
    searchController.text = widget.keyword;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: [
        Search_recent_tab(keyword: widget.keyword),
        Search_trending_tab(keyword: widget.keyword),
        Search_account_tab(keyword: widget.keyword),
        Search_media_tab(keyword: widget.keyword)
      ],
      builder: (context, child, tabController) {
        final tabsRouter = AutoTabsRouter.of(context);
        tabController.index = tabsRouter.activeIndex;
        return buildSearchTabs(tabsRouter, child, tabController);
      },
    );
  }

  // Main Explore Page
  buildSearchTabs(
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
                appBar: buildSearchAppBar(tabsRouter),
                backgroundColor: mainBackgroundColor,
                drawer: isSmallPage(context, "Drawer"),
                resizeToAvoidBottomInset: false,
                body: Row(
                  children: [
                    buildWebNavigationRail(context),
                    Flexible(
                      child: NestedScrollView(
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
                                    onTap: tabsRouter.setActiveIndex,
                                    tabs: const [
                                      Tab(text: "Recent"),
                                      Tab(text: "Trending"),
                                      Tab(text: "Accounts"),
                                      Tab(text: "Media"),
                                    ],
                                  ),
                                ),
                              )
                            ];
                          },
                          body: child),
                    ),
                  ],
                ))));
  }

  // Build Search Bar
  buildSearchAppBar(TabsRouter tabsRouter) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: mainNavRailBackgroundColor,
      title: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: mainServerRailBackgroundColor,
          ),
          child: TextField(
            controller: searchController,
            focusNode: _focus,
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            _focus.unfocus();
                            searchController.clear();
                          });
                          context.router.pop();
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
              } else {
                setState(() {
                  keyword = value;
                });
              }
            },
            onTap: () {
              setState(() {
                keyword = searchController.text.trim();
              });
            },
            onSubmitted: (value) {
              if (value.isEmpty) {
                FocusManager.instance.primaryFocus?.unfocus();
                _focus.unfocus();
                setState(() {
                  keyword = value;
                });
                context.router.pop();
              } else {
                setState(() {
                  keyword = value;
                  context.router.popAndPush(Search(keyword: keyword));
                  //context.router.navigate(Search(keyword: keyword));
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
