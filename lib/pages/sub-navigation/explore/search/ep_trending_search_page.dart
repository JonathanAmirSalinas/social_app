import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'search_trending_tab')
class TrendingSearchPage extends StatefulWidget {
  final String keyword;
  const TrendingSearchPage(
      {super.key, @PathParam('keyword') required this.keyword});

  @override
  State<TrendingSearchPage> createState() => _TrendingSearchPageState();
}

class _TrendingSearchPageState extends State<TrendingSearchPage>
    with AutomaticKeepAliveClientMixin<TrendingSearchPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Center(child: Text(widget.keyword)),
    );
  }
}
