import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'search')
class SearchPage extends StatefulWidget {
  final String keyword;
  const SearchPage({super.key, @PathParam('keyword') required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void dispose() {
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
              backgroundColor: backgroundColor,
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
            )));
  }
}
