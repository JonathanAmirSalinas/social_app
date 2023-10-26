import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'hub')
class HubPage extends StatefulWidget {
  const HubPage({
    super.key,
  });

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  TextEditingController exploreController = TextEditingController();
  bool searched = false;
  late String name;

  @override
  void dispose() {
    exploreController.dispose();
    super.dispose();
  }

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
