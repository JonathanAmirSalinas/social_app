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
    Auth.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPage(),
      );
    },
    Login.name: (routeData) {
      final args = routeData.argsAs<LoginArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(
          key: args.key,
          onResult: args.onResult,
        ),
      );
    },
    Register.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
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
    Help.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpPage(),
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
    Server_home.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServerHomePage(),
      );
    },
    Server_messages.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServerMessagesPage(),
      );
    },
    Settings.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    View_content.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<View_contentArgs>(
          orElse: () => View_contentArgs(pid: pathParams.getString('pid')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewContentPage(
          key: args.key,
          pid: args.pid,
        ),
      );
    },
    Profile.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileArgs>(
          orElse: () => ProfileArgs(uid: pathParams.getString('uid')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    Settings_Privacy_And_Safety.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrivacyAndSafetySettingsPage(),
      );
    },
    Settings_Account.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountSettingsPage(),
      );
    },
    Settings_Profiles.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileSettingsPage(),
      );
    },
  };
}

/// generated route for
/// [AuthPage]
class Auth extends PageRouteInfo<void> {
  const Auth({List<PageRouteInfo>? children})
      : super(
          Auth.name,
          initialChildren: children,
        );

  static const String name = 'Auth';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class Login extends PageRouteInfo<LoginArgs> {
  Login({
    Key? key,
    required dynamic Function(bool?) onResult,
    List<PageRouteInfo>? children,
  }) : super(
          Login.name,
          args: LoginArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'Login';

  static const PageInfo<LoginArgs> page = PageInfo<LoginArgs>(name);
}

class LoginArgs {
  const LoginArgs({
    this.key,
    required this.onResult,
  });

  final Key? key;

  final dynamic Function(bool?) onResult;

  @override
  String toString() {
    return 'LoginArgs{key: $key, onResult: $onResult}';
  }
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
/// [SettingsPage]
class Settings extends PageRouteInfo<void> {
  const Settings({List<PageRouteInfo>? children})
      : super(
          Settings.name,
          initialChildren: children,
        );

  static const String name = 'Settings';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ViewContentPage]
class View_content extends PageRouteInfo<View_contentArgs> {
  View_content({
    Key? key,
    required String pid,
    List<PageRouteInfo>? children,
  }) : super(
          View_content.name,
          args: View_contentArgs(
            key: key,
            pid: pid,
          ),
          rawPathParams: {'pid': pid},
          initialChildren: children,
        );

  static const String name = 'View_content';

  static const PageInfo<View_contentArgs> page =
      PageInfo<View_contentArgs>(name);
}

class View_contentArgs {
  const View_contentArgs({
    this.key,
    required this.pid,
  });

  final Key? key;

  final String pid;

  @override
  String toString() {
    return 'View_contentArgs{key: $key, pid: $pid}';
  }
}

/// generated route for
/// [ProfilePage]
class Profile extends PageRouteInfo<ProfileArgs> {
  Profile({
    Key? key,
    required String uid,
    List<PageRouteInfo>? children,
  }) : super(
          Profile.name,
          args: ProfileArgs(
            key: key,
            uid: uid,
          ),
          rawPathParams: {'uid': uid},
          initialChildren: children,
        );

  static const String name = 'Profile';

  static const PageInfo<ProfileArgs> page = PageInfo<ProfileArgs>(name);
}

class ProfileArgs {
  const ProfileArgs({
    this.key,
    required this.uid,
  });

  final Key? key;

  final String uid;

  @override
  String toString() {
    return 'ProfileArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [PrivacyAndSafetySettingsPage]
class Settings_Privacy_And_Safety extends PageRouteInfo<void> {
  const Settings_Privacy_And_Safety({List<PageRouteInfo>? children})
      : super(
          Settings_Privacy_And_Safety.name,
          initialChildren: children,
        );

  static const String name = 'Settings_Privacy_And_Safety';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountSettingsPage]
class Settings_Account extends PageRouteInfo<void> {
  const Settings_Account({List<PageRouteInfo>? children})
      : super(
          Settings_Account.name,
          initialChildren: children,
        );

  static const String name = 'Settings_Account';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileSettingsPage]
class Settings_Profiles extends PageRouteInfo<void> {
  const Settings_Profiles({List<PageRouteInfo>? children})
      : super(
          Settings_Profiles.name,
          initialChildren: children,
        );

  static const String name = 'Settings_Profiles';

  static const PageInfo<void> page = PageInfo<void>(name);
}
