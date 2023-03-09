import 'dart:ui';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  PageController controller = PageController(viewportFraction: .8);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildNewsHeadlines(),
                buildTrendingNews(),
                buildHotNewsTopics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds PageView of Headlining News, from the use of a News API's
  //////////////////////////////////////////////////////////////////////////////
  buildNewsHeadlines() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Headlines",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .9,
                child: PageView.builder(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return buildNewsHeadlineCard();
                    }),
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
      ],
    );
  }

  // Builds List of Trending News, from the use of searched "#'s" or Keywords
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingNews() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Trending",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width * .8,
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .08,
                    alignment: Alignment.center,
                    color: Theme.of(context).cardColor,
                    child: Text(index.toString()),
                  ),
                );
              })),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
      ],
    );
  }

  // Builds GridView of other news stories, from the use both Headlines and Trending
  /////////////////////////////////////////////////////////////////////////////////
  buildHotNewsTopics() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Recent News Stories",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .6,
          width: MediaQuery.of(context).size.width * .9,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: GridView.count(
            childAspectRatio: 3,
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            children: [
              GridTile(
                  child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.purple,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Sports",
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                ),
              )),
              GridTile(
                  child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.red,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Politics",
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                ),
              )),
              GridTile(
                  child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.green,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "World News",
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                ),
              )),
              GridTile(
                  child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.pink,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Entertainment",
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                ),
              )),
              GridTile(
                  child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.orange,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Economy",
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                ),
              )),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
      ],
    );
  }

  // Builds News Headline UI Card
  buildNewsHeadlineCard() {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * .35,
        width: MediaQuery.of(context).size.width * .7,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
