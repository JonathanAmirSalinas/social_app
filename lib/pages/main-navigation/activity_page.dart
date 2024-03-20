import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

@RoutePage(name: 'activity')
class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        Notification_tab(),
        Mentions_tab(),
      ],
      builder: (context, child, tabController) {
        final tabsRouter = AutoTabsRouter.of(context);
        tabController.index = tabsRouter.activeIndex;
        return buildActivityTabs(tabsRouter, child, tabController);
      },
    );
  }

  buildActivityTabs(
      TabsRouter tabsRouter, Widget child, TabController tabController) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _focus.unfocus();
        setState(() {});
      },
      child: DefaultTabController(
          initialIndex: tabsRouter.activeIndex,
          length: 2,
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
                        indicatorColor: mainSecondaryColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: "Notifications"),
                          Tab(text: "Mentions"),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: child,
            ),
          )),
    );
  }
}
