import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'search_media_tab')
class MediaSearchPage extends StatefulWidget {
  final String keyword;
  const MediaSearchPage({super.key, required this.keyword});

  @override
  State<MediaSearchPage> createState() => _MediaSearchPageState();
}

class _MediaSearchPageState extends State<MediaSearchPage>
    with AutomaticKeepAliveClientMixin<MediaSearchPage> {
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
