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
import 'package:social_app/pages/sub-navigation/explore/search/ep_accounts_search_page.dart';
import 'package:social_app/pages/sub-navigation/explore/search/ep_recent_search_page.dart';
import 'package:social_app/pages/sub-navigation/explore/search/ep_search_page.dart';
import 'package:social_app/pages/sub-navigation/explore/search/ep_trending_search_page.dart';
import 'package:social_app/pages/sub-navigation/explore/search/ep_media_search_page.dart';
import 'package:social_app/pages/sub-navigation/help_page.dart';
import 'package:social_app/pages/sub-navigation/content/view_content_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_channel_page.dart';
import 'package:social_app/pages/sub-navigation/settings/account/settings_account_page.dart';
import 'package:social_app/pages/sub-navigation/profile/profile_page.dart';
import 'package:social_app/pages/sub-navigation/server/svr_chatroom_page.dart';
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
        CustomRoute(
          page: Auth.page,
          path: '/auth',
          initial: true,
        ),
        // Auth Routes /////////////////////////////////////////////////////////
        CustomRoute(
          page: Login.page,
          path: '/login',
          maintainState: false,
        ),
        AutoRoute(page: Register.page, path: '/register', maintainState: false),
        // Main Routes /////////////////////////////////////////////////////////
        CustomRoute(
            page: Main.page,
            path: '/main',
            guards: [AuthGuard()],
            usesPathAsKey: true,
            keepHistory: true,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            children: [
              // Home
              CustomRoute(
                page: Home.page,
                path: 'home',
                keepHistory: true,
                guards: [AuthGuard()],
                transitionsBuilder: TransitionsBuilders.noTransition,
              ),
              // Explore
              CustomRoute(
                  page: Explore.page,
                  path: 'explore',
                  guards: [AuthGuard()],
                  usesPathAsKey: true,
                  keepHistory: true,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                  children: [
                    // Explore Hub Page
                    AutoRoute(
                      page: Hub_trending_tab.page,
                      path: 'trending',
                    ),
                    AutoRoute(
                      page: Hub_news_tab.page,
                      path: 'news',
                    ),
                    AutoRoute(
                      page: Hub_media_tab.page,
                      path: 'media',
                    ),
                    AutoRoute(
                      page: Hub_servers_tab.page,
                      path: 'servers',
                    ),
                  ]),

              // Activity
              CustomRoute(
                page: Activity.page,
                path: 'activity',
                guards: [AuthGuard()],
                transitionsBuilder: TransitionsBuilders.noTransition,
                children: [
                  AutoRoute(
                    page: Notification_tab.page,
                    path: 'notifications',
                  ),
                  AutoRoute(
                    page: Mentions_tab.page,
                    path: 'mentions',
                  ),
                ],
              ),
              // Servers
              CustomRoute(
                page: Servers.page,
                path: 'servers',
                transitionsBuilder: TransitionsBuilders.noTransition,
                children: [
                  CustomRoute(
                    page: Server_messages.page,
                    path: 'messages',
                    transitionsBuilder: TransitionsBuilders.noTransition,
                  ),
                  CustomRoute(
                      page: Server_chatroom.page,
                      path: ':sid',
                      keepHistory: false,
                      transitionsBuilder: TransitionsBuilders.noTransition,
                      children: [
                        CustomRoute(
                          page: Server_channel.page,
                          path: ':channel',
                          maintainState: false,
                          keepHistory: false,
                          transitionsBuilder: TransitionsBuilders.fadeIn,
                        ),
                      ]),
                ],
              ),
              RedirectRoute(path: '*', redirectTo: ''),
              // Explore Search //////////////////////////////////////////////////////////////
            ]), // End of Main
        // Profile /////////////////////////////////////////////////////////////
        CustomRoute(
          page: Profile.page,
          path: '/profile/:uid',
          usesPathAsKey: true,
          keepHistory: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
            page: Search.page,
            path: '/search',
            transitionsBuilder: TransitionsBuilders.fadeIn,
            children: [
              AutoRoute(
                page: Search_trending_tab.page,
                path: ':keyword&f=trending',
              ),
              AutoRoute(
                page: Search_account_tab.page,
                path: ':keyword&f=accounts',
              ),
              AutoRoute(
                page: Search_media_tab.page,
                path: ':keyword&f=media',
              ),
              AutoRoute(
                page: Search_recent_tab.page,
                path: ':keyword&f=recent',
              ),
            ]),
        // View Post /////////////////////////////////////////////////////////////
        CustomRoute(
          page: View_content.page,
          path: '/content/:pid',
          usesPathAsKey: true,
          keepHistory: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        // Bookmark ////////////////////////////////////////////////////////////
        CustomRoute(
          page: Bookmark.page,
          path: '/bookmark',
          keepHistory: false,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        // Settings ////////////////////////////////////////////////////////////
        CustomRoute(
          page: Settings.page,
          path: '/settings',
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: Settings_Account.page,
          path: '/settings/account',
          usesPathAsKey: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: Settings_Profiles.page,
          path: '/settings/profiles',
          usesPathAsKey: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: Settings_Privacy_And_Safety.page,
          path: '/settings/privacyandsafety',
          usesPathAsKey: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        // Help ////////////////////////////////////////////////////////////
        CustomRoute(
          page: Help.page,
          path: '/help',
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
      ];
}
