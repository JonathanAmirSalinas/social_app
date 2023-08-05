import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/auth/login_page.dart';
import 'package:social_app/pages/auth/register_page.dart';
import 'package:social_app/pages/main-navigation/activity_page.dart';
import 'package:social_app/pages/main-navigation/explore_page.dart';
import 'package:social_app/pages/main-navigation/home_page.dart';
import 'package:social_app/pages/main-navigation/server_page.dart';
import 'package:social_app/pages/responsive/main_page.dart';
import 'package:social_app/pages/sub-navigation/activity/act_mentions_page.dart';
import 'package:social_app/pages/sub-navigation/activity/act_notifications_page.dart';
import 'package:social_app/pages/sub-navigation/bookmark_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_media_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_news_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_server_page.dart';
import 'package:social_app/pages/sub-navigation/explore/ep_trending_page.dart';
import 'package:social_app/pages/sub-navigation/help_page.dart';
import 'package:social_app/pages/sub-navigation/profile_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_chatroom_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_home_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_message_page.dart';
import 'package:social_app/pages/sub-navigation/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Auth Routes /////////////////////////////////////////////////////////
        AutoRoute(
          page: Login.page,
          path: '/login',
          initial: true,
        ),
        AutoRoute(page: Register.page, path: '/register'),
        // Main Routes /////////////////////////////////////////////////////////
        AutoRoute(page: Main.page, path: '/', children: [
          // Home
          CustomRoute(
              page: Home.page,
              path: 'home',
              transitionsBuilder: TransitionsBuilders.noTransition),
          // Explore
          CustomRoute(
              page: Explore.page,
              path: 'explore',
              transitionsBuilder: TransitionsBuilders.noTransition,
              children: [
                AutoRoute(page: Trending_tab.page, path: 'trending'),
                AutoRoute(page: News_tab.page, path: 'news'),
                AutoRoute(page: Media_tab.page, path: 'media'),
                AutoRoute(page: Servers_tab.page, path: 'servers')
              ]),
          // Activity
          AutoRoute(page: Activity.page, path: 'activity', children: [
            AutoRoute(page: Notification_tab.page, path: 'notifications'),
            AutoRoute(page: Mentions_tab.page, path: 'mentions'),
          ]),
          // Servers
          AutoRoute(page: Servers.page, path: 'servers', children: [
            AutoRoute(page: Server_home.page, path: 'home'),
            AutoRoute(page: Server_messages.page, path: 'messages'),
            AutoRoute(
              page: Server_chatroom.page,
              path: ':sid',
            ),
          ]),
        ]),
        // Profile /////////////////////////////////////////////////////////////
        AutoRoute(page: Profile.page, path: '/profile'),
        // Bookmark ////////////////////////////////////////////////////////////
        AutoRoute(page: Bookmark.page, path: '/bookmark'),
        // Settings ////////////////////////////////////////////////////////////
        AutoRoute(page: Setting.page, path: '/settings'),
        // Help ////////////////////////////////////////////////////////////
        AutoRoute(page: Help.page, path: '/help'),
      ];
}
