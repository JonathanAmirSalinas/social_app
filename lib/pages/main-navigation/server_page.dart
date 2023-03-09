import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServerPage extends StatefulWidget {
  final String? sid;
  const ServerPage({super.key, this.sid});

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  late String serverRailController;
  List sid = ["first1212121212", "second54454554", "third3434434343434"];

  @override
  void initState() {
    if (widget.sid == null) {
      serverRailController = 'main';
    } else {
      serverRailController = widget.sid!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildServerRail(),
          buildSelectedServer(serverRailController),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Server Navigation Rail
  //////////////////////////////////////////////////////////////////////////////
  buildServerRail() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 60,
      color: Theme.of(context).cardColor,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(children: [
            // Server Home Menu
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      serverRailController = "main";
                      context.go("/servers");
                    });
                  },
                  tooltip: "Home",
                  splashRadius: 20,
                  icon: const Icon(Icons.view_comfortable_rounded)),
            ),
            const Divider(
              thickness: 3,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            /////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: MediaQuery.of(context).size.height * .78,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: sid.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          serverRailController = sid[index];
                          context.goNamed("sid", params: {"sid": sid[index]});
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const Divider(
              thickness: 3,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),

            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                  onPressed: () {},
                  tooltip: "Create Server",
                  splashRadius: 20,
                  icon: const Icon(Icons.add)),
            ),

            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                  onPressed: () {},
                  tooltip: "Share Server",
                  splashRadius: 20,
                  icon: const Icon(Icons.account_tree_rounded)),
            ),
          ]),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Controller Function for Navigating through Navigation Rail
  //////////////////////////////////////////////////////////////////////////////
  buildSelectedServer(String sid) {
    if (sid == "main") {
      return buildServerHomeMenu();
    } else {
      return buildServerChat(sid);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds The Main Chat Block Using Server ID
  //////////////////////////////////////////////////////////////////////////////
  buildServerChat(String sid) {
    return Expanded(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).cardColor,
            title: Text(
              sid,
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      sid,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds the User's Home Menu Panel
  //////////////////////////////////////////////////////////////////////////////
  buildServerHomeMenu() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .14,
                            width: MediaQuery.of(context).size.height * .14,
                            margin: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.indigoAccent),
                            child: const Text("Image"),
                          ),
                          Row(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Friends"),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Servers"),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .11,
                                margin: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Colors.indigoAccent),
                                child: const Text("Awards"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .fontSize),
                                  ),
                                  const Text("  @username")
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .12,
                              width: MediaQuery.of(context).size.width * .2,
                              margin: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.indigoAccent),
                              child: const Text("Options Panel (Grid)"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Text("Stats"),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Text("Manage Servers"),
                  ),
                ),
              )
            ],
          ),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text("Pinned Item/Media"),
            ),
          ),
        ],
      ),
    ));
  }

////////////////
}
