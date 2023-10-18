import 'dart:ui';
import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'trending_tab')
class TrendingTabPage extends StatefulWidget {
  const TrendingTabPage({super.key});

  @override
  State<TrendingTabPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingTabPage>
    with AutomaticKeepAliveClientMixin<TrendingTabPage> {
  @override
  bool get wantKeepAlive => true;
  PageController trendingMediaController = PageController(viewportFraction: .8);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              buildHeadline(),
              buildTrending(),
              buildTrendingMedia(),
              buildTrendingTags(),
              buildTrendingExtra(),
            ],
          ),
        ),
      ),
    );
  }

  // Trending Headline, built from the most "#'s" & searched topic
  //////////////////////////////////////////////////////////////////////////////
  buildHeadline() {
    return GestureDetector(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: kIsWeb ? 1.8 : 1.2,
        child: Container(
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
                      color: backgroundColor),
                  child: const Placeholder(),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            fontWeight: FontWeight.w500),
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
              ),
              const Divider(color: navBarColor),
            ],
          ),
        ),
      ),
    );
  }

  // Trending Headlines, built from most "#'s" & searched topic in a week
  //////////////////////////////////////////////////////////////////////////////
  buildTrending() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Trending",
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
            itemCount: 3,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {},
                child: AspectRatio(
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
                ),
              );
            })),
        const Divider(color: navBarColor),
      ],
    );
  }

  // Trending Media
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingMedia() {
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
                controller: trendingMediaController,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
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

  // Builds Trending Tabs
  buildTrendingTags() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Trending Tags",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('hashtags')
                .orderBy('posts', descending: false)
                .snapshots()
                .take(5),
            builder: ((context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        var tag = snapshot.data!.docs[index].data();
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: navBarColor),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        margin: const EdgeInsets.all(2),
                                        child: Text(
                                          tag['tag'],
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .fontSize,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        margin: const EdgeInsets.all(2),
                                        child: Text(
                                          '${tag['posts'].length.toString()} tags',
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .fontSize,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      }));

                case ConnectionState.done:
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        var tag = snapshot.data!.docs[index].data();
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: navBarColor),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 32),
                                        margin: const EdgeInsets.all(2),
                                        child: Text(
                                          tag['tag'],
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .fontSize,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 32),
                                        margin: const EdgeInsets.all(2),
                                        child: Text(
                                          tag['posts'].length.toString(),
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .fontSize,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      }));
              }
            })),
        const Divider(color: navBarColor),
      ],
    );
  }

  /// Builds Extra Trending Stories/Topics
  /////////////////////////////////////////////////////////////////////////////
  buildTrendingExtra() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Extra",
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
              return GestureDetector(
                onTap: () {},
                child: AspectRatio(
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
                ),
              );
            })),
        const Divider(color: navBarColor),
      ],
    );
  }
}
