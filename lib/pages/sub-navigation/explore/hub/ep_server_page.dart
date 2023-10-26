import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'hub_servers_tab')
class ServersTabPage extends StatefulWidget {
  const ServersTabPage({super.key});

  @override
  State<ServersTabPage> createState() => _ServersTabState();
}

class _ServersTabState extends State<ServersTabPage>
    with AutomaticKeepAliveClientMixin<ServersTabPage> {
  @override
  bool get wantKeepAlive => true;
  PageController trendingController = PageController(viewportFraction: .8);
  PageController popularController = PageController(viewportFraction: .8);

  @override
  void dispose() {
    trendingController.dispose();
    popularController.dispose();
    super.dispose();
  }

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
                buildTrendingServers(),
                buildPopularServers(),
                buildSuggestedServers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  // Built from server with the most amount of joined user in a week/month
  //////////////////////////////////////////////////////////////////////////////
  buildTrendingServers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Trending Servers",
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize),
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
                      controller: trendingController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return buildServerBanner();
                      }),
                ),
              )),
        ),
        const Divider(color: navBarColor),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  // Built from server with the most amount of activity
  //////////////////////////////////////////////////////////////////////////////
  buildPopularServers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Popular Servers",
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
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
                      controller: trendingController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return buildServerBanner();
                      }),
                ),
              )),
        ),
        const Divider(color: navBarColor),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  // Built from user recent intrested topics (eg. #'s and searches)
  //////////////////////////////////////////////////////////////////////////////
  buildSuggestedServers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Server You Might Like",
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
            ),
          ),
        ),
        buildServerFilterBar(),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: MediaQuery.of(context).size.width < 500
              ? SingleChildScrollView(
                  child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: SizedBox(
                        child: PageView.builder(
                            controller: popularController,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return buildServerBanner();
                            }),
                      )),
                )
              : GridView.count(
                  childAspectRatio: 2,
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                  ],
                ),
        ),
      ],
    );
  }

  /// Filter Bar (TODO: Convert To Tab-Like Functionality (Nested Navigation))
  //////////////////////////////////////////////////////////////////////////////
  buildServerFilterBar() {
    return Row(
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
                buildFilterButton('Recommended'),
                buildFilterButton('Sports'),
                buildFilterButton('Entertainment'),
                buildFilterButton('Chill'),
                buildFilterButton('Gaming'),
                buildFilterButton('Science'),
                buildFilterButton('Anime'),
                buildFilterButton('Music'),
                buildFilterButton('Memes'),
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

  //////////////////////////////////////////////////////////////////////////////
  // Built from given Server Parameters
  //////////////////////////////////////////////////////////////////////////////
  Widget buildServerBanner() {
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
                        "Server",
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
                          's/ServerID',
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

  //////////////////////////////////////////////////////////////////////////////
  // Smaller Grid Server Banner
  //////////////////////////////////////////////////////////////////////////////
  buildGridServerBanner() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clicked on Server Banner Grid")));
      },
      child: AspectRatio(
        aspectRatio: kIsWeb ? 3 : 1,
        child: Card(
          color: fillColor,
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                //////////////////////////// TOP LEFT IMAGE //////////////////////
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      height: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: fillColor
                          /*image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                snap['serverBannerUrl']),
                            fit: BoxFit.fill)*/
                          )),
                ),
                ////////////////////////// Outline Box UI ////////////////////////
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.black38),
                  ),
                ),

                ///////////////////////////// BOTTOM LEFT TEXT ///////////////////
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      height: 60,
                      width: MediaQuery.of(context).size.width * .65,
                      decoration: const BoxDecoration(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Server Name",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                          Text(
                            "   s/ID",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
