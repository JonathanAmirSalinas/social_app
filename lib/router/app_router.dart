import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/main.dart';
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
import 'package:social_app/pages/sub-navigation/content/view_content_page.dart';
import 'package:social_app/pages/sub-navigation/settings/account/settings_account_page.dart';
import 'package:social_app/pages/sub-navigation/profile/profile_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_chatroom_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_home_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_message_page.dart';
import 'package:social_app/pages/sub-navigation/settings/settings_privacy_and_saftety_page.dart';
import 'package:social_app/pages/sub-navigation/settings/settings_profiles_page.dart';
import 'package:social_app/pages/sub-navigation/settings_page.dart';
import 'package:social_app/router/app_router_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Inital Route
        RedirectRoute(path: '/', redirectTo: '/main'),
        RedirectRoute(path: '/login', redirectTo: '/auth'),
        AutoRoute(
          page: Auth.page,
          path: '/auth',
          initial: true,
        ),
        // Auth Routes /////////////////////////////////////////////////////////
        AutoRoute(page: Login.page, path: '/login', maintainState: false),
        AutoRoute(page: Register.page, path: '/register', maintainState: false),
        // Main Routes /////////////////////////////////////////////////////////
        AutoRoute(
            page: Main.page,
            path: '/main',
            guards: [AuthGuard()],
            usesPathAsKey: true,
            keepHistory: true,
            children: [
              // Home
              CustomRoute(
                  page: Home.page,
                  path: 'home',
                  guards: [AuthGuard()],
                  transitionsBuilder: TransitionsBuilders.noTransition),
              // Explore
              CustomRoute(
                  page: Explore.page,
                  path: 'explore',
                  guards: [AuthGuard()],
                  transitionsBuilder: TransitionsBuilders.noTransition,
                  children: [
                    AutoRoute(
                      page: Trending_tab.page,
                      path: 'trending',
                    ),
                    AutoRoute(
                      page: News_tab.page,
                      path: 'news',
                    ),
                    AutoRoute(
                      page: Media_tab.page,
                      path: 'media',
                    ),
                    AutoRoute(
                      page: Servers_tab.page,
                      path: 'servers',
                    )
                  ]),
              // Activity
              AutoRoute(page: Activity.page, path: 'activity', guards: [
                AuthGuard()
              ], children: [
                AutoRoute(
                  page: Notification_tab.page,
                  path: 'notifications',
                ),
                AutoRoute(
                  page: Mentions_tab.page,
                  path: 'mentions',
                ),
              ]),
              // Servers
              AutoRoute(page: Servers.page, path: 'servers', children: [
                AutoRoute(
                  page: Server_home.page,
                  path: 'home',
                ),
                AutoRoute(
                  page: Server_messages.page,
                  path: 'messages',
                ),
                AutoRoute(
                  page: Server_chatroom.page,
                  path: ':sid',
                ),
              ]),
              RedirectRoute(path: '*', redirectTo: ''),
            ]),
        // Profile /////////////////////////////////////////////////////////////
        AutoRoute(
          page: Profile.page,
          path: '/profile/:uid',
          usesPathAsKey: true,
        ),
        // View Post /////////////////////////////////////////////////////////////
        AutoRoute(
          page: View_content.page,
          path: '/content/:pid',
          usesPathAsKey: true,
        ),
        // Bookmark ////////////////////////////////////////////////////////////
        AutoRoute(
          page: Bookmark.page,
          path: '/bookmark',
          keepHistory: false,
        ),
        // Settings ////////////////////////////////////////////////////////////
        AutoRoute(
          page: Settings.page,
          path: '/settings',
        ),
        AutoRoute(
          page: Settings_Account.page,
          path: '/settings/account',
          usesPathAsKey: true,
        ),
        AutoRoute(
          page: Settings_Profiles.page,
          path: '/settings/profiles',
          usesPathAsKey: true,
        ),
        AutoRoute(
          page: Settings_Privacy_And_Safety.page,
          path: '/settings/privacyandsafety',
          usesPathAsKey: true,
        ),
        // Help ////////////////////////////////////////////////////////////
        AutoRoute(page: Help.page, path: '/help'),
      ];
}
