import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/pages/main-navigation/activity_page.dart';
import 'package:social_app/pages/main-navigation/explore_page.dart';
import 'package:social_app/pages/main-navigation/home_page.dart';
import 'package:social_app/pages/main-navigation/message_page.dart';
import 'package:social_app/pages/responsive/side_menu_page.dart';
import 'package:social_app/widgets/nav_drawer_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  late bool bottomNav;
  bool _extended = false;

  void selectedIndex(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        context.go('/activity');
        break;
      case 3:
        context.go('/message');
        break;
      default:
        context.go('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      constraints.maxWidth < 500 || constraints.maxWidth == 500
          ? {bottomNav = true, _extended = false}
          : bottomNav = false;

      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          drawer: const NavigationDrawer(),
          body: Row(
            children: [
              !bottomNav ? buildNavigationRail() : Container(),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: const [
                    HomePage(),
                    ExplorePage(),
                    ActivityPage(),
                    MessagePage(),
                  ],
                ),
              ),
              constraints.maxWidth > 1280
                  ? const VerticalDivider(
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    )
                  : Container(),
              constraints.maxWidth > 1280 ? const SideMenuPage() : Container(),
            ],
          ),
          bottomNavigationBar: bottomNav
              ? BottomNavigationBar(
                  currentIndex: _index,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    setState(() {
                      _index = index;
                      selectedIndex(index);
                    });
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
                          icon: Icon(Icons.space_dashboard), label: "Messages"),
                    ])
              : null,
        ),
      );
    });
  }

//////////////////////////////////////////////////////////////////////////////////
//// NAVIGATION RAIL
////////////////////////////////////////////////////////////////////////////////
  buildNavigationRail() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _extended = !_extended;
        });
      },
      child: NavigationRail(
        selectedIndex: _index,
        extended: _extended,
        elevation: 2,
        // NAVIGATION RAIL UI
        backgroundColor: Theme.of(context).primaryColor,
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
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: false,
                                menuItemIcon: Icons.account_box_rounded,
                                menuLabel: "Profile",
                                itemRoute: '/profile',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: false,
                                menuItemIcon: Icons.bookmark_outlined,
                                menuLabel: "Bookmarked",
                                itemRoute: '/bookmark',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
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
                                itemRoute: '/profile',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const ExtendedSubMenuRail(
                                onlyOnExtended: true,
                                menuItemIcon: Icons.logout_rounded,
                                menuLabel: "Logout",
                                itemRoute: '/profile',
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
          setState(() {
            _index = index;
            selectedIndex(index);
          });
        },
        // NAVIGATION BUTTONS
        destinations: const [
          NavigationRailDestination(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.home),
              label: Text("Home")),
          NavigationRailDestination(
              icon: Icon(Icons.search), label: Text("Explore")),
          NavigationRailDestination(
              icon: Icon(Icons.notifications_active_rounded),
              label: Text("Activity")),
          NavigationRailDestination(
              icon: Icon(Icons.space_dashboard), label: Text("Messages")),
        ],
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
                  horizontal: lerpDouble(0, 6, animation.value)!,
                  vertical: lerpDouble(0, 6, animation.value)!,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              )
            : Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: animation.value,
                child: Container(
                  height: 150,
                  width: 250,
                  padding: const EdgeInsetsDirectional.only(start: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.loose,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              child: const Text(" @username"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
          height: 56,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(6, 6, animation.value)!,
          ),
          child: animation.value == 0
              ? !onlyOnExtended
                  ? IconButton(
                      onPressed: () {
                        context.go(itemRoute);
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
                    height: 80,
                    width: 200,
                    child: ListTile(
                      onTap: () {
                        context.go(itemRoute);
                      },
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
          height: 56,
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
