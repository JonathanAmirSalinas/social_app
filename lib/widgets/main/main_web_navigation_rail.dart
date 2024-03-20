import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

// Builds Vertical Navigation Rail
buildWebNavigationRail(BuildContext context) {
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
                context.router.navigateNamed('/main/home');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: mainNavRailBackgroundColor,
                  backgroundColor: mainNavRailBackgroundColor,
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
                context.router.navigateNamed('/main/explore/trending');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: mainNavRailBackgroundColor,
                  backgroundColor: mainNavRailBackgroundColor,
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
                context.router.navigateNamed('/main/activity/notifications');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: mainNavRailBackgroundColor,
                  backgroundColor: mainNavRailBackgroundColor,
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
                context.router.navigateNamed('/main/servers');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: mainNavRailBackgroundColor,
                  backgroundColor: mainNavRailBackgroundColor,
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
