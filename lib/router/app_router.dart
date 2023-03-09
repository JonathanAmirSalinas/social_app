import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/main.dart';
import 'package:social_app/pages/sub-navigation/bookmark_page.dart';
import 'package:social_app/pages/main-navigation/activity_page.dart';
import 'package:social_app/pages/main-navigation/explore_page.dart';
import 'package:social_app/pages/main-navigation/home_page.dart';
import 'package:social_app/pages/main-navigation/server_page.dart';
import 'package:social_app/pages/sub-navigation/profile_page.dart';
import 'package:social_app/pages/responsive/main_page.dart';
import 'package:social_app/pages/sub-navigation/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: ProfilePage());
      },
    ),
    GoRoute(
      path: '/bookmark',
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: BookmarkPage());
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SettingsPage());
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: HomePage());
          },
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: ExplorePage());
          },
        ),
        GoRoute(
          path: '/activity',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: ActivityPage());
          },
        ),
        GoRoute(
            name: 'servers',
            path: '/servers',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: ServerPage());
            },
            routes: [
              GoRoute(
                name: "sid",
                path: ':sid',
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: ServerPage(sid: state.params["sid"]!));
                },
              ),
            ]),
      ],
    )
  ],
);
