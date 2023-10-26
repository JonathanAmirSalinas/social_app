import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'search_recent_tab')
class RecentSearchPage extends StatefulWidget {
  final String keyword;
  const RecentSearchPage({super.key, required this.keyword});

  @override
  State<RecentSearchPage> createState() => _RecentSearchPageState();
}

class _RecentSearchPageState extends State<RecentSearchPage>
    with AutomaticKeepAliveClientMixin<RecentSearchPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: Text(widget.keyword)),
    );
  }
}
