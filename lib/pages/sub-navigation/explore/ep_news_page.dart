import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'news_tab')
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
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildFilterBar(),
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
                    buildFilterButton('Sports'),
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
        const Divider(color: navBarColor)
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

  // Builds PageView of Headlining News, from the use of a News API's
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
                        return buildNewsHeadlineCard();
                      }),
                ),
              )),
        ),
        const Divider(color: navBarColor),
      ],
    );
  }

  // Trending Media
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
                                  color: secondaryColor,
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
        const Divider(color: navBarColor),
      ],
    );
  }

  // Builds List of Trending News, from the use of searched "#'s" or Keywords
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
              return AspectRatio(
                aspectRatio: kIsWeb ? 5 : 3.2,
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: fillColor),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  'Title',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .fontSize,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'Subtitles',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .fontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                      ],
                    )),
              );
            })),
        const Divider(color: navBarColor),
      ],
    );
  }

  // Builds News Headline UI Card
  buildNewsHeadlineCard() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: kIsWeb ? 1.5 : 1.15,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Placeholder(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Subtitle',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontSize),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
