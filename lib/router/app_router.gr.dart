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
    Search_account_tab.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<Search_account_tabArgs>(
          orElse: () =>
              Search_account_tabArgs(keyword: pathParams.getString('keyword')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountSearchPage(
          key: args.key,
          keyword: args.keyword,
        ),
      );
    },
    Settings_Account.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountSettingsPage(),
      );
    },
    Activity.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ActivityPage(),
      );
    },
    Auth.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPage(),
      );
    },
    Bookmark.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BookmarkPage(),
      );
    },
    Explore.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExplorePage(),
      );
    },
    Help.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HelpPage(),
      );
    },
    Home.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
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
    Main.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    Search_media_tab.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<Search_media_tabArgs>(
          orElse: () =>
              Search_media_tabArgs(keyword: pathParams.getString('keyword')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MediaSearchPage(
          key: args.key,
          keyword: args.keyword,
        ),
      );
    },
    Hub_media_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MediaTabPage(),
      );
    },
    Mentions_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MentionsPage(),
      );
    },
    Hub_news_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewsTabPage(),
      );
    },
    Notification_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPage(),
      );
    },
    Settings_Privacy_And_Safety.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrivacyAndSafetySettingsPage(),
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
    Settings_Profiles.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileSettingsPage(),
      );
    },
    Search_recent_tab.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<Search_recent_tabArgs>(
          orElse: () =>
              Search_recent_tabArgs(keyword: pathParams.getString('keyword')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecentSearchPage(
          key: args.key,
          keyword: args.keyword,
        ),
      );
    },
    Register.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    Search.name: (routeData) {
      final args = routeData.argsAs<SearchArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPage(
          key: args.key,
          keyword: args.keyword,
        ),
      );
    },
    Server_channel.name: (routeData) {
      final args = routeData.argsAs<Server_channelArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServerChannel(
          key: args.key,
          channel: args.channel,
          sid: args.sid,
        ),
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
    Hub_servers_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServersTabPage(),
      );
    },
    Settings.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    Search_trending_tab.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<Search_trending_tabArgs>(
          orElse: () => Search_trending_tabArgs(
              keyword: pathParams.getString('keyword')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TrendingSearchPage(
          key: args.key,
          keyword: args.keyword,
        ),
      );
    },
    Hub_trending_tab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrendingTabPage(),
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
  };
}

/// generated route for
/// [AccountSearchPage]
class Search_account_tab extends PageRouteInfo<Search_account_tabArgs> {
  Search_account_tab({
    Key? key,
    required String keyword,
    List<PageRouteInfo>? children,
  }) : super(
          Search_account_tab.name,
          args: Search_account_tabArgs(
            key: key,
            keyword: keyword,
          ),
          rawPathParams: {'keyword': keyword},
          initialChildren: children,
        );

  static const String name = 'Search_account_tab';

  static const PageInfo<Search_account_tabArgs> page =
      PageInfo<Search_account_tabArgs>(name);
}

class Search_account_tabArgs {
  const Search_account_tabArgs({
    this.key,
    required this.keyword,
  });

  final Key? key;

  final String keyword;

  @override
  String toString() {
    return 'Search_account_tabArgs{key: $key, keyword: $keyword}';
  }
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
/// [MediaSearchPage]
class Search_media_tab extends PageRouteInfo<Search_media_tabArgs> {
  Search_media_tab({
    Key? key,
    required String keyword,
    List<PageRouteInfo>? children,
  }) : super(
          Search_media_tab.name,
          args: Search_media_tabArgs(
            key: key,
            keyword: keyword,
          ),
          rawPathParams: {'keyword': keyword},
          initialChildren: children,
        );

  static const String name = 'Search_media_tab';

  static const PageInfo<Search_media_tabArgs> page =
      PageInfo<Search_media_tabArgs>(name);
}

class Search_media_tabArgs {
  const Search_media_tabArgs({
    this.key,
    required this.keyword,
  });

  final Key? key;

  final String keyword;

  @override
  String toString() {
    return 'Search_media_tabArgs{key: $key, keyword: $keyword}';
  }
}

/// generated route for
/// [MediaTabPage]
class Hub_media_tab extends PageRouteInfo<void> {
  const Hub_media_tab({List<PageRouteInfo>? children})
      : super(
          Hub_media_tab.name,
          initialChildren: children,
        );

  static const String name = 'Hub_media_tab';

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
/// [NewsTabPage]
class Hub_news_tab extends PageRouteInfo<void> {
  const Hub_news_tab({List<PageRouteInfo>? children})
      : super(
          Hub_news_tab.name,
          initialChildren: children,
        );

  static const String name = 'Hub_news_tab';

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

/// generated route for
/// [RecentSearchPage]
class Search_recent_tab extends PageRouteInfo<Search_recent_tabArgs> {
  Search_recent_tab({
    Key? key,
    required String keyword,
    List<PageRouteInfo>? children,
  }) : super(
          Search_recent_tab.name,
          args: Search_recent_tabArgs(
            key: key,
            keyword: keyword,
          ),
          rawPathParams: {'keyword': keyword},
          initialChildren: children,
        );

  static const String name = 'Search_recent_tab';

  static const PageInfo<Search_recent_tabArgs> page =
      PageInfo<Search_recent_tabArgs>(name);
}

class Search_recent_tabArgs {
  const Search_recent_tabArgs({
    this.key,
    required this.keyword,
  });

  final Key? key;

  final String keyword;

  @override
  String toString() {
    return 'Search_recent_tabArgs{key: $key, keyword: $keyword}';
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
/// [SearchPage]
class Search extends PageRouteInfo<SearchArgs> {
  Search({
    Key? key,
    required String keyword,
    List<PageRouteInfo>? children,
  }) : super(
          Search.name,
          args: SearchArgs(
            key: key,
            keyword: keyword,
          ),
          initialChildren: children,
        );

  static const String name = 'Search';

  static const PageInfo<SearchArgs> page = PageInfo<SearchArgs>(name);
}

class SearchArgs {
  const SearchArgs({
    this.key,
    required this.keyword,
  });

  final Key? key;

  final String keyword;

  @override
  String toString() {
    return 'SearchArgs{key: $key, keyword: $keyword}';
  }
}

/// generated route for
/// [ServerChannel]
class Server_channel extends PageRouteInfo<Server_channelArgs> {
  Server_channel({
    Key? key,
    required String channel,
    required String sid,
    List<PageRouteInfo>? children,
  }) : super(
          Server_channel.name,
          args: Server_channelArgs(
            key: key,
            channel: channel,
            sid: sid,
          ),
          rawPathParams: {'channel': channel},
          initialChildren: children,
        );

  static const String name = 'Server_channel';

  static const PageInfo<Server_channelArgs> page =
      PageInfo<Server_channelArgs>(name);
}

class Server_channelArgs {
  const Server_channelArgs({
    this.key,
    required this.channel,
    required this.sid,
  });

  final Key? key;

  final String channel;

  final String sid;

  @override
  String toString() {
    return 'Server_channelArgs{key: $key, channel: $channel, sid: $sid}';
  }
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
/// [ServersTabPage]
class Hub_servers_tab extends PageRouteInfo<void> {
  const Hub_servers_tab({List<PageRouteInfo>? children})
      : super(
          Hub_servers_tab.name,
          initialChildren: children,
        );

  static const String name = 'Hub_servers_tab';

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
/// [TrendingSearchPage]
class Search_trending_tab extends PageRouteInfo<Search_trending_tabArgs> {
  Search_trending_tab({
    Key? key,
    required String keyword,
    List<PageRouteInfo>? children,
  }) : super(
          Search_trending_tab.name,
          args: Search_trending_tabArgs(
            key: key,
            keyword: keyword,
          ),
          rawPathParams: {'keyword': keyword},
          initialChildren: children,
        );

  static const String name = 'Search_trending_tab';

  static const PageInfo<Search_trending_tabArgs> page =
      PageInfo<Search_trending_tabArgs>(name);
}

class Search_trending_tabArgs {
  const Search_trending_tabArgs({
    this.key,
    required this.keyword,
  });

  final Key? key;

  final String keyword;

  @override
  String toString() {
    return 'Search_trending_tabArgs{key: $key, keyword: $keyword}';
  }
}

/// generated route for
/// [TrendingTabPage]
class Hub_trending_tab extends PageRouteInfo<void> {
  const Hub_trending_tab({List<PageRouteInfo>? children})
      : super(
          Hub_trending_tab.name,
          initialChildren: children,
        );

  static const String name = 'Hub_trending_tab';

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
