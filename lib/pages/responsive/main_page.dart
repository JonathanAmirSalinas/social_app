import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:social_app/pages/responsive/side_menu_page.dart';
import 'package:social_app/pages/sub-navigation/content/create_post_page.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_bloc.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_event.dart';
import 'package:social_app/providers/navigation_provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/widgets/content/post_widget.dart';
import 'package:social_app/widgets/drawers/nav_drawer_widget.dart';

@RoutePage(name: 'main')
class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focus = FocusNode();
  late String keyword;
  bool loadingState = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focus.dispose();
    super.dispose();
  }

  getData() async {
    setState(() {
      loadingState = true;
    });
    try {
      SportsBloc sportProvider = Provider.of(context, listen: false);
      sportProvider.add(GetSportsList());
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.refreshUser();
      //FeedProvider feedProvider = Provider.of(context, listen: false);
      //await feedProvider.getUserFeed();
    } catch (e) {
      print(e);
    }
    setState(() {
      loadingState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadingState
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(builder: (context, constraints) {
            return AutoTabsRouter(
              routes: [
                const Home(), // 0
                const Explore(), // 1
                const Activity(), // 2
                Servers(), // 3
              ],
              duration: Duration.zero,
              builder: (context, child) {
                final tabsRouter = AutoTabsRouter.of(context);
                return buildRoute(tabsRouter, child, constraints.maxWidth);
              },
            );
          });
  }

  Widget buildRoute(TabsRouter tabsRouter, Widget child, double constraints) {
    NavigationProvider navProvider = Provider.of<NavigationProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.red,
        appBar: buildAppBar(tabsRouter),
        drawer: const SliverNavigationDrawer(),
        body: Row(
          children: [
            !isMobileScreen(constraints)
                ? buildWebNavigationRail(
                    tabsRouter) //buildNavigationRail(tabsRouter)
                : Container(),
            Expanded(child: child),
            constraints > 1280
                ? Container(
                    height: double.infinity,
                    width: 5,
                    color: mainNavRailBackgroundColor,
                  )
                : Container(),
            constraints > 1280 ? const SideMenuPage() : Container(),
          ],
        ),
        floatingActionButton:
            isMobileScreen(constraints) ? generateFloatingActionButton() : null,
        bottomNavigationBar: isMobileScreen(constraints)
            ? BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                backgroundColor: mainNavRailBackgroundColor,
                onTap: (value) {
                  navProvider.changeRouterIndex(value);
                  tabsRouter.setActiveIndex(value);
                },
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: "Explore"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_active_outlined),
                        label: "Activity"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.space_dashboard), label: "Servers"),
                  ])
            : null,
      ),
    );
  }

  buildAppBar(TabsRouter tabsRouter) {
    switch (tabsRouter.activeIndex) {
      // Home Page AppBar
      case 0:
        return AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: mainNavRailBackgroundColor,
          title: const Text('Home'),
          actions: [
            isMobileScreen(MediaQuery.of(context).size.width)
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                        onPressed: () {
                          buildCreatePostDialog(context);
                        },
                        icon: const Icon(Icons.add))),
          ],
        );
      // Explore Page AppBar
      case 1:
        return AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: mainNavRailBackgroundColor,
          title: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: mainServerRailBackgroundColor),
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

                              tabsRouter.setActiveIndex(1);
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
                    // Set Tab Index to 0 (Hub)
                    tabsRouter.setActiveIndex(1);
                  } else {
                    setState(() {
                      keyword = value;
                      context.router.navigate(Search(keyword: keyword));
                    });
                  }
                },
              ),
            ),
          ),
        );
      // Activity Page AppBar
      case 2:
        return AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: mainNavRailBackgroundColor,
          title: const Text('Activity'),
          actions: [
            isMobileScreen(MediaQuery.of(context).size.width)
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_active_outlined))),
          ],
        );
      // Server Page AppBar
      case 3:
        return AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: mainNavRailBackgroundColor,
        );

      default:
        return AppBar();
    }
  }

  // Navigational Layout Builder
  buildWebNavigationRail(TabsRouter tabsRouter) {
    return LayoutBuilder(builder: ((context, constraints) {
      return constraints.maxWidth < webScreenSize
          ? buildExpandedRail(tabsRouter)
          : buildCompressedRail(tabsRouter);
    }));
  }

  // Expanded Vertical Navigation Rail
  buildExpandedRail(TabsRouter tabsRouter) {
    return Container(width: 250, color: Colors.red);
  }

  // Compressed Vertical Navigation Rail
  buildCompressedRail(TabsRouter tabsRouter) {
    return Container(
      width: 60,
      color: mainNavRailBackgroundColor,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  tabsRouter.setActiveIndex(0);
                },
                style: ElevatedButton.styleFrom(
                    elevation: tabsRouter.activeIndex == 0 ? 2 : 0,
                    backgroundColor: tabsRouter.activeIndex == 0
                        ? mainServerRailBackgroundColor
                        : mainNavRailBackgroundColor,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: const Icon(
                  Icons.home,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  tabsRouter.setActiveIndex(1);
                },
                style: ElevatedButton.styleFrom(
                    elevation: tabsRouter.activeIndex == 1 ? 2 : 0,
                    backgroundColor: tabsRouter.activeIndex == 1
                        ? mainServerRailBackgroundColor
                        : mainNavRailBackgroundColor,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: const Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  tabsRouter.setActiveIndex(2);
                },
                style: ElevatedButton.styleFrom(
                    elevation: tabsRouter.activeIndex == 2 ? 2 : 0,
                    backgroundColor: tabsRouter.activeIndex == 2
                        ? mainServerRailBackgroundColor
                        : mainNavRailBackgroundColor,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  tabsRouter.setActiveIndex(3);
                },
                style: ElevatedButton.styleFrom(
                    elevation: tabsRouter.activeIndex == 3 ? 2 : 0,
                    backgroundColor: tabsRouter.activeIndex == 3
                        ? mainServerRailBackgroundColor
                        : mainNavRailBackgroundColor,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: const Icon(
                  Icons.space_dashboard,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////
// FloatingAction Button                                                     ///
////////////////////////////////////////////////////////////////////////////////
  generateFloatingActionButton() {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return const CreatePostPage();
              }));
        },
        tooltip: "Create Post",
        backgroundColor: mainNavRailBackgroundColor,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
