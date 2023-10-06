import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/responsive/side_menu_page.dart';
import 'package:social_app/pages/sub-navigation/content/create_post_page.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_bloc.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_event.dart';
import 'package:social_app/providers/feed_provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/router/app_router.dart';
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
  bool _extended = false;
  bool loadingState = false;

  checkExtended(double constraint) {
    setState(() {
      if (constraint < webScreenSize) {
        _extended = false;
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
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
      FeedProvider feedProvider = Provider.of(context, listen: false);
      await feedProvider.getUserFeed();
    } catch (e) {
      print(e);
    }
    setState(() {
      loadingState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkExtended(MediaQuery.of(context).size.width);
    return loadingState
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(builder: (context, constraints) {
            return AutoTabsRouter(
              routes: [
                const Home(),
                const Explore(),
                const Activity(),
                Servers(),
              ],
              homeIndex: 0,
              duration: Duration.zero,
              builder: (context, child) {
                final tabsRouter = AutoTabsRouter.of(context);
                return buildRoute(tabsRouter, child, constraints.maxWidth);
              },
            );
          });
  }

  Widget buildRoute(TabsRouter tabsRouter, Widget child, double constraints) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        drawer: const SliverNavigationDrawer(),
        body: Row(
          children: [
            !isMobileScreen(constraints)
                ? buildNavigationRail(tabsRouter)
                : Container(),
            Expanded(child: child),
            constraints > 1280
                ? Container(
                    height: double.infinity,
                    width: 5,
                    color: navBarColor,
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
                backgroundColor: navBarColor,
                onTap: tabsRouter.setActiveIndex,
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

//////////////////////////////////////////////////////////////////////////////////
//// NAVIGATION RAIL
////////////////////////////////////////////////////////////////////////////////
  buildNavigationRail(TabsRouter tabsRouter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (MediaQuery.of(context).size.width > webScreenSize) {
            _extended = !_extended;
          }
        });
      },
      child: NavigationRail(
        selectedIndex: tabsRouter.activeIndex,
        extended: _extended,
        elevation: 2,
        // NAVIGATION RAIL UI
        backgroundColor: navBarColor,
        selectedIconTheme: Theme.of(context).primaryIconTheme,
        selectedLabelTextStyle: TextStyle(
            color: Theme.of(context).primaryIconTheme.color,
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            fontWeight: FontWeight.w600),
        unselectedIconTheme: Theme.of(context).iconTheme,
        unselectedLabelTextStyle: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
        // LEADING WIDGET
        leading: const LeadingExtendedRail(),
        //TRAILING WIDGET
        trailing: Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _extended
                                ? Container(
                                    width: 80,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Divider(
                                      thickness: 2,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color,
                                    ),
                                  )
                                : Container(
                                    width: 20,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Divider(
                                      thickness: 2,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color,
                                    ),
                                  ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: false,
                                menuItemIcon: Icons.account_box_rounded,
                                menuLabel: "Profile",
                                itemRoute: '/profile',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: false,
                                menuItemIcon: Icons.workspaces_filled,
                                menuLabel: "Premium",
                                itemRoute: '/premium',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: false,
                                menuItemIcon: Icons.settings,
                                menuLabel: "Settings",
                                itemRoute: '/settings',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: true,
                                menuItemIcon: Icons.help_center,
                                menuLabel: "Help",
                                itemRoute: '/help',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: true,
                                menuItemIcon: Icons.logout_rounded,
                                menuLabel: "Logout",
                                itemRoute: '',
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )),

        // MAIN NAVIAGTION FUNCTIONALITY
        onDestinationSelected: (int index) {
          tabsRouter.setActiveIndex(index);
        },
        // NAVIGATION BUTTONS
        destinations: const [
          NavigationRailDestination(
              padding: EdgeInsets.symmetric(vertical: 4),
              icon: Icon(Icons.home),
              label: Text("Home")),
          NavigationRailDestination(
              padding: EdgeInsets.symmetric(vertical: 4),
              icon: Icon(Icons.search),
              label: Text("Explore")),
          NavigationRailDestination(
              padding: EdgeInsets.symmetric(vertical: 4),
              icon: Icon(Icons.notifications_active_rounded),
              label: Text("Activity")),
          NavigationRailDestination(
              padding: EdgeInsets.symmetric(vertical: 4),
              icon: Icon(Icons.space_dashboard),
              label: Text("Servers")),
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
        backgroundColor: navBarColor,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// LEADING RAIL WIDGET: HANDLES PROFILE RAIL UI                              ///
////////////////////////////////////////////////////////////////////////////////
class LeadingExtendedRail extends StatelessWidget {
  const LeadingExtendedRail({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // The extended fab has a shorter height than the regular fab.
        return animation.value == 0
            ? Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.symmetric(
                  horizontal: lerpDouble(0, 7, animation.value)!,
                  vertical: lerpDouble(0, 7, animation.value)!,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        userProvider.profileUrl,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              )
            : Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: animation.value,
                child: Container(
                    height: 160,
                    width: 240,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      userProvider.profileUrl,
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.donut_large_rounded,
                                      color: secondaryColorSolid,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.account_circle_rounded,
                                      color: secondaryColorSolid,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          userProvider.name,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(userProvider.username),
                        ),
                      ],
                    )),
              );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// TRAILING SUB-MENU ITEMS WIDGETS
////////////////////////////////////////////////////////////////////////////////
class ExtendedSubMenuRail extends StatelessWidget {
  final bool onlyOnExtended;
  final IconData menuItemIcon;
  final String menuLabel;
  final String itemRoute;
  const ExtendedSubMenuRail({
    super.key,
    required this.menuItemIcon,
    required this.menuLabel,
    required this.itemRoute,
    required this.onlyOnExtended,
  });
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // The extended fab has a shorter height than the regular fab.
        return Container(
          height: 60,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(6, 6, animation.value)!,
          ),
          child: animation.value == 0
              ? !onlyOnExtended
                  ? IconButton(
                      onPressed: () async {
                        if (menuLabel == 'Logout') {
                          FirebaseAuth.instance.signOut();
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.clear();
                          context.router.navigateNamed('/');
                        } else if (menuLabel == 'Profile') {
                          context.router.pushNamed(
                              '/profile/${FirebaseAuth.instance.currentUser!.uid}');
                        } else {
                          context.router.pushNamed(itemRoute);
                        }
                      },
                      icon: Icon(
                        menuItemIcon,
                        color: Theme.of(context).disabledColor,
                      ),
                    )
                  : Container()
              : Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: animation.value,
                  child: SizedBox(
                    width: 200,
                    child: ListTile(
                      onTap: () async {
                        // Logout
                        if (menuLabel == 'Logout') {
                          FirebaseAuth.instance.signOut();
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.clear();
                          context.router.navigateNamed('/');
                        } else if (menuLabel == 'Profile') {
                          context.router.pushNamed(
                              '/profile/${FirebaseAuth.instance.currentUser!.uid}');
                        } else {
                          context.router.pushNamed(itemRoute);
                        }
                      },
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      leading: Icon(menuItemIcon),
                      title: Text(menuLabel),
                    ),
                  )),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// BUTTON TAHT HANDLE THE EXTENDED STATE OF THE NAVIAGTION RAIL (TRUE/FALSE)
////////////////////////////////////////////////////////////////////////////////
class ExtendedRailController extends StatelessWidget {
  const ExtendedRailController({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // The extended fab has a shorter height than the regular fab.
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(0, 6, animation.value)!,
          ),
          child: animation.value == 0
              ? IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.keyboard_double_arrow_right_sharp),
                  splashRadius: 25,
                )
              : Align(
                  alignment: Alignment.centerRight,
                  widthFactor: animation.value,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 180),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.keyboard_double_arrow_left_sharp,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      splashRadius: 25,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
