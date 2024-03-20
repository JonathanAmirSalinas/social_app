import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/explore/news_sports_widgets.dart';

@RoutePage(name: 'hub_news_tab')
class NewsTabPage extends StatefulWidget {
  const NewsTabPage({super.key});

  @override
  State<NewsTabPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsTabPage>
    with AutomaticKeepAliveClientMixin<NewsTabPage> {
  @override
  bool get wantKeepAlive => true;
  PageController trendingNewsMediaController =
      PageController(viewportFraction: .8);
  PageController trendingNewsHeadlineController =
      PageController(viewportFraction: .8);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //buildFilterBar(),
                buildNewsHeadlines(),
                buildTrendingNewsMedia(),
                buildTrendingNews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Filter Bar (TODO: Convert To Tab-Like Functionality (Nested Navigation))
  //////////////////////////////////////////////////////////////////////////////
  buildFilterBar() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: fillColor,
              size: 18,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildFilterButton('Home'),
                    buildFilterButton('Sports'), // Only Current Api
                    buildFilterButton('Entertainment'),
                    buildFilterButton('Economy'),
                    buildFilterButton('Politics'),
                    buildFilterButton('Weather'),
                    buildFilterButton('Science'),
                    buildFilterButton('Technology'),
                    buildFilterButton('Trending'),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: fillColor,
              size: 18,
            ),
          ],
        ),
        const Divider(color: mainNavRailBackgroundColor)
      ],
    );
  }

  // Filter Bar Button
  buildFilterButton(String title) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          child: Text(title)),
    );
  }

  // Builds PageView of Headlining News, from the use of a News API's (Only Current Api category "Sports")
  //////////////////////////////////////////////////////////////////////////////
  buildNewsHeadlines() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Headlines",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SingleChildScrollView(
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: AspectRatio(
                aspectRatio: kIsWeb ? 1.8 : 1.4,
                child: SizedBox(
                  child: PageView.builder(
                      controller: trendingNewsHeadlineController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return buildSportNewsHeadlines(context, index);
                      }),
                ),
              )),
        ),
        const Divider(color: mainNavRailBackgroundColor),
      ],
    );
  }

  // Trending News Media
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingNewsMedia() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "News Media",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SingleChildScrollView(
            child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: AspectRatio(
            aspectRatio: kIsWeb ? 4 : 2.8,
            child: ListView.builder(
                controller: trendingNewsMediaController,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: kIsWeb ? 1 : .9,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: fillColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: kIsWeb ? 1 : .9,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  size: 32,
                                  color: mainSecondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        )),
        const Divider(color: mainNavRailBackgroundColor),
      ],
    );
  }

  // Builds List of Trending News (Only Current Api category "Sports")
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingNews() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "News Topics",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: ((context, index) {
              return buildSportNewsTopics(context, index + 3);
            })),
        const Divider(color: mainNavRailBackgroundColor),
      ],
    );
  }
}
