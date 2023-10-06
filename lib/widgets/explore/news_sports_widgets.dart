import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_bloc.dart';
import 'package:social_app/providers/api/news/sports_news/bloc/sports_state.dart';
import 'package:social_app/providers/api/news/sports_news/model/sports_model.dart';

// Builds Explore/News/Sports Headline Widgets
buildSportNewsHeadlines(BuildContext context, int index) {
  return BlocConsumer<SportsBloc, SportsState>(
    listener: (context, state) {
      if (state is SportsError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
    },
    builder: (context, state) {
      if (state is SportsInitial) {
        return buildSportsHeadlineLoadingCard(context);
      } else if (state is SportsLoading) {
        return buildSportsHeadlineLoadingCard(context);
      } else if (state is SportsLoaded) {
        return buildSportNewsHeadlineCard(
            context, state.sportsModel.articles![index]);
      } else if (state is SportsError) {
        return buildSportsHeadlineErrorCard(context, state.errorMessage);
      } else {
        return Container();
      }
    },
  );
}

//////////////////////////////////////////////////////////////////////////////
/// Sprots News Card
//////////////////////////////////////////////////////////////////////////////
buildSportNewsHeadlineCard(BuildContext context, Article article) {
  return GestureDetector(
      onTap: () {},
      child: LayoutBuilder(builder: ((context, constraints) {
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
                    // Article Image
                    Expanded(
                      child: article.urlToImage == null
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          article.urlToImage!),
                                      fit: BoxFit.cover)),
                            ),
                    ),
                    // Article Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          article.title == null
                              ? Container()
                              : Text(
                                  article.title!,
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth >
                                              mobileScreenSize
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .fontSize
                                          : Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .fontSize,
                                      fontWeight: FontWeight.w600),
                                ),
                          // Article Author
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: article.author == null
                                ? Container()
                                : Text(
                                    article.author,
                                    style: TextStyle(
                                        fontSize: constraints.maxWidth >
                                                mobileScreenSize
                                            ? Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .fontSize),
                                    overflow: TextOverflow.visible,
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
      })));
}

// Loading News Headlline
////////////////////////////////////////////////////////////////////////////////
buildSportsHeadlineLoadingCard(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: LayoutBuilder(builder: ((context, constraints) {
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
                    // Article Image
                    Expanded(
                        child: Card(
                      child: Container(),
                    )),
                    // Article Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: double.infinity,
                            child: Card(),
                          ),
                          SizedBox(
                            height: 20,
                            width: double.infinity,
                            child: Card(),
                          ),

                          // Article Author
                          SizedBox(
                            height: 20,
                            width: 100,
                            child: Card(),
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
      })));
}

// Build Error Headline Widget
buildSportsHeadlineErrorCard(BuildContext context, String? errorMessage) {
  return GestureDetector(
      onTap: () {},
      child: LayoutBuilder(builder: ((context, constraints) {
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
                    // Article Image
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: const Placeholder(),
                      ),
                    ),
                    // Article Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            errorMessage!,
                            style: TextStyle(
                                fontSize:
                                    constraints.maxWidth > mobileScreenSize
                                        ? Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .fontSize
                                        : Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .fontSize,
                                fontWeight: FontWeight.w600),
                          ),
                          // Article Author
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize:
                                      constraints.maxWidth > mobileScreenSize
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .fontSize
                                          : Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .fontSize),
                              overflow: TextOverflow.visible,
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
      })));
}

/// Builds List of Articles
////////////////////////////////////////////////////////////////////////////////
buildSportNewsTopics(BuildContext context, int index) {
  return BlocConsumer<SportsBloc, SportsState>(
    listener: (context, state) {
      if (state is SportsError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
    },
    builder: (context, state) {
      if (state is SportsInitial) {
        return buildSportNewsTopicsLoadingTile(context);
      } else if (state is SportsLoading) {
        return buildSportNewsTopicsLoadingTile(context);
      } else if (state is SportsLoaded) {
        return buildSportNewsTopicsTile(
            context, state.sportsModel.articles![index]);
      } else if (state is SportsError) {
        return buildSportNewsTopicsErrorTile(context, state.errorMessage!);
      } else {
        return Container();
      }
    },
  );
}

/// Builds Sports News Topic
////////////////////////////////////////////////////////////////////////////////
buildSportNewsTopicsTile(BuildContext context, Article article) {
  return GestureDetector(
      // Redirect to Article Link
      onTap: () {},
      child: LayoutBuilder(builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: kIsWeb ? 5 : 3.2,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: article.urlToImage == null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        article.urlToImage!),
                                    fit: BoxFit.cover)),
                          ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Article Title
                        article.title == null
                            ? Container()
                            : Flexible(
                                child: Text(
                                  article.title!,
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth >
                                              mobileScreenSize
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .fontSize
                                          : Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .fontSize,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                        // Article Author
                        article.author == null
                            ? Container()
                            : Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    article.author,
                                    style: TextStyle(
                                        fontSize: constraints.maxWidth >
                                                mobileScreenSize
                                            ? Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .fontSize),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ))
                ],
              )),
        );
      }));
}

// Loading News Topic Tile
////////////////////////////////////////////////////////////////////////////////
buildSportNewsTopicsLoadingTile(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: LayoutBuilder(builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: kIsWeb ? 5 : 3.2,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: const Placeholder(),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        // Article Title
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: double.infinity,
                                child: Card(),
                              ),

                              // Article Author
                              SizedBox(
                                height: 20,
                                width: 150,
                                child: Card(),
                              ),
                              SizedBox(
                                height: 20,
                                width: 100,
                                child: Card(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              )),
        );
      }));
}

/// Builds Sports News Topic
////////////////////////////////////////////////////////////////////////////////
buildSportNewsTopicsErrorTile(BuildContext context, String errorMessage) {
  return GestureDetector(
      // Redirect to Article Link
      onTap: () {},
      child: LayoutBuilder(builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: kIsWeb ? 5 : 3.2,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: const Placeholder(),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Article Title
                        Flexible(
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                                fontSize:
                                    constraints.maxWidth > mobileScreenSize
                                        ? Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .fontSize
                                        : Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .fontSize,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              )),
        );
      }));
}
