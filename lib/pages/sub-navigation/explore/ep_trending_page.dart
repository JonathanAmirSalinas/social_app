import 'package:auto_route/annotations.dart';
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
                buildHeadline(),
                buildTrending(),
                buildTrendingTopics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Trending Headline, built from the most "#'s" & searched topic
  //////////////////////////////////////////////////////////////////////////////
  buildHeadline() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Headline",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
          ),
        ),
        Card(
          color: fillColor,
          child: Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .8,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Column(
              children: [],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
      ],
    );
  }

  // Trending Headlines, built from most "#'s" & searched topic in a week
  //////////////////////////////////////////////////////////////////////////////
  buildTrending() {
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
              itemCount: 8,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: fillColor),
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

  // Built from under top 10 trending topics
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingTopics() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Trending Topics",
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
}
