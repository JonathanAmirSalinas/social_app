// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    Activity.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ActivityPage(),
      );
    },
    Explore.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExplorePage(),
      );
    },
    Home.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    Servers.name: (routeData) {
      final args =
          routeData.argsAs<ServersArgs>(orElse: () => const ServersArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServersPage(
          key: args.key,
          sid: args.sid,
        ),
      );
    },
    Main.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    Mentions_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MentionsPage(),
      );
    },
    Notification_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPage(),
      );
    },
    Bookmark.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BookmarkPage(),
      );
    },
    Media_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MediaTabPage(),
      );
    },
    News_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewsTabPage(),
      );
    },
    Servers_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServersTabPage(),
      );
    },
    Trending_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrendingTabPage(),
      );
    },
    Profile.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    Setting.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    Server_home.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServerHomePage(),
      );
    },
    Server_chatroom.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<Server_chatroomArgs>(
          orElse: () => Server_chatroomArgs(sid: pathParams.getString('sid')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServerChatroomPage(
          key: args.key,
          sid: args.sid,
        ),
      );
    },
    Server_messages.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServerMessagesPage(),
      );
    },
    Login.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    Register.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    Help.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpPage(),
      );
    },
  };
}

/// generated route for
/// [ActivityPage]
class Activity extends PageRouteInfo<void> {
  const Activity({List<PageRouteInfo>? children})
      : super(
          Activity.name,
          initialChildren: children,
        );

  static const String name = 'Activity';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ExplorePage]
class Explore extends PageRouteInfo<void> {
  const Explore({List<PageRouteInfo>? children})
      : super(
          Explore.name,
          initialChildren: children,
        );

  static const String name = 'Explore';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class Home extends PageRouteInfo<void> {
  const Home({List<PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServersPage]
class Servers extends PageRouteInfo<ServersArgs> {
  Servers({
    Key? key,
    String? sid,
    List<PageRouteInfo>? children,
  }) : super(
          Servers.name,
          args: ServersArgs(
            key: key,
            sid: sid,
          ),
          initialChildren: children,
        );

  static const String name = 'Servers';

  static const PageInfo<ServersArgs> page = PageInfo<ServersArgs>(name);
}

class ServersArgs {
  const ServersArgs({
    this.key,
    this.sid,
  });

  final Key? key;

  final String? sid;

  @override
  String toString() {
    return 'ServersArgs{key: $key, sid: $sid}';
  }
}

/// generated route for
/// [MainPage]
class Main extends PageRouteInfo<void> {
  const Main({List<PageRouteInfo>? children})
      : super(
          Main.name,
          initialChildren: children,
        );

  static const String name = 'Main';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MentionsPage]
class Mentions_tab extends PageRouteInfo<void> {
  const Mentions_tab({List<PageRouteInfo>? children})
      : super(
          Mentions_tab.name,
          initialChildren: children,
        );

  static const String name = 'Mentions_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationPage]
class Notification_tab extends PageRouteInfo<void> {
  const Notification_tab({List<PageRouteInfo>? children})
      : super(
          Notification_tab.name,
          initialChildren: children,
        );

  static const String name = 'Notification_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BookmarkPage]
class Bookmark extends PageRouteInfo<void> {
  const Bookmark({List<PageRouteInfo>? children})
      : super(
          Bookmark.name,
          initialChildren: children,
        );

  static const String name = 'Bookmark';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MediaTabPage]
class Media_tab extends PageRouteInfo<void> {
  const Media_tab({List<PageRouteInfo>? children})
      : super(
          Media_tab.name,
          initialChildren: children,
        );

  static const String name = 'Media_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewsTabPage]
class News_tab extends PageRouteInfo<void> {
  const News_tab({List<PageRouteInfo>? children})
      : super(
          News_tab.name,
          initialChildren: children,
        );

  static const String name = 'News_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServersTabPage]
class Servers_tab extends PageRouteInfo<void> {
  const Servers_tab({List<PageRouteInfo>? children})
      : super(
          Servers_tab.name,
          initialChildren: children,
        );

  static const String name = 'Servers_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrendingTabPage]
class Trending_tab extends PageRouteInfo<void> {
  const Trending_tab({List<PageRouteInfo>? children})
      : super(
          Trending_tab.name,
          initialChildren: children,
        );

  static const String name = 'Trending_tab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class Profile extends PageRouteInfo<void> {
  const Profile({List<PageRouteInfo>? children})
      : super(
          Profile.name,
          initialChildren: children,
        );

  static const String name = 'Profile';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class Setting extends PageRouteInfo<void> {
  const Setting({List<PageRouteInfo>? children})
      : super(
          Setting.name,
          initialChildren: children,
        );

  static const String name = 'Setting';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServerHomePage]
class Server_home extends PageRouteInfo<void> {
  const Server_home({List<PageRouteInfo>? children})
      : super(
          Server_home.name,
          initialChildren: children,
        );

  static const String name = 'Server_home';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServerChatroomPage]
class Server_chatroom extends PageRouteInfo<Server_chatroomArgs> {
  Server_chatroom({
    Key? key,
    required String sid,
    List<PageRouteInfo>? children,
  }) : super(
          Server_chatroom.name,
          args: Server_chatroomArgs(
            key: key,
            sid: sid,
          ),
          rawPathParams: {'sid': sid},
          initialChildren: children,
        );

  static const String name = 'Server_chatroom';

  static const PageInfo<Server_chatroomArgs> page =
      PageInfo<Server_chatroomArgs>(name);
}

class Server_chatroomArgs {
  const Server_chatroomArgs({
    this.key,
    required this.sid,
  });

  final Key? key;

  final String sid;

  @override
  String toString() {
    return 'Server_chatroomArgs{key: $key, sid: $sid}';
  }
}

/// generated route for
/// [ServerMessagesPage]
class Server_messages extends PageRouteInfo<void> {
  const Server_messages({List<PageRouteInfo>? children})
      : super(
          Server_messages.name,
          initialChildren: children,
        );

  static const String name = 'Server_messages';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class Login extends PageRouteInfo<void> {
  const Login({List<PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class Register extends PageRouteInfo<void> {
  const Register({List<PageRouteInfo>? children})
      : super(
          Register.name,
          initialChildren: children,
        );

  static const String name = 'Register';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HelpPage]
class Help extends PageRouteInfo<void> {
  const Help({List<PageRouteInfo>? children})
      : super(
          Help.name,
          initialChildren: children,
        );

  static const String name = 'Help';

  static const PageInfo<void> page = PageInfo<void>(name);
}
