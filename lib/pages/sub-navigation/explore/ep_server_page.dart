import 'package:auto_route/annotations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'servers_tab')
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
          child: Text(
            "   Trending Servers",
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
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * .9,
                child: PageView.builder(
                    controller: trendingController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return buildServerBanner();
                    }),
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  // Built from list of servers with most joined users
  //////////////////////////////////////////////////////////////////////////////
  buildPopularServers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "   Popular Servers",
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
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * .9,
                child: PageView.builder(
                    controller: popularController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return buildServerBanner();
                    }),
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        )
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
          child: Text(
            "   Server You Might Like",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width * .9,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width * .9,
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
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: [
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                    buildGridServerBanner(),
                  ],
                ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        )
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  // Built from given Server Parameters
  //////////////////////////////////////////////////////////////////////////////
  Widget buildServerBanner() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Clicked on Server Banner")));
      },
      child: Card(
        color: fillColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .28,
          child: Stack(
            children: [
              //////////////////////////// TOP LEFT IMAGE //////////////////////
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    height: MediaQuery.of(context).size.height * .5,
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
                  height: MediaQuery.of(context).size.height * .08,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * .04,
                  width: 50,
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.group_sharp), Text("0")],
                  ),
                ),
              ),
              ///////////////////////////// BOTTOM LEFT TEXT ///////////////////
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    height: MediaQuery.of(context).size.height * .07,
                    width: MediaQuery.of(context).size.width * .85,
                    decoration: const BoxDecoration(),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Server Name",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70),
                        ),
                        Text(
                          "   s/ID",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70),
                        ),
                      ],
                    )),
              ),

              ///////////////////////////// JOIN BUTTON ////////////////////////
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: 80,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Join",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
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
      child: Card(
        color: fillColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .20,
          child: Stack(
            children: [
              //////////////////////////// TOP LEFT IMAGE //////////////////////
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    height: MediaQuery.of(context).size.height * .3,
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
                  height: MediaQuery.of(context).size.height * .07,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                ),
              ),

              ///////////////////////////// BOTTOM LEFT TEXT ///////////////////
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    height: MediaQuery.of(context).size.height * .06,
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
    );
  }
}
