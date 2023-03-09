import 'package:flutter/material.dart';
import 'package:social_app/pages/constants/constants.dart';
import 'package:social_app/widgets/sliver_appbar_widget.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();

        _focus.unfocus();
        setState(() {});
      },
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: isSmallPage(context, "Drawer"),
            resizeToAvoidBottomInset: false,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      pinned: true,
                      floating: true,
                      snap: true,
                      leading: isSmallPage(
                        context,
                        "Leading IconButton",
                      ),
                      title: Text(
                        "Activity",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize),
                      )),

                  // TABBAR
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Notifications"),
                          Tab(text: "Messages"),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: const TabBarView(
                children: [
                  Center(
                    child: Text("Notifications"),
                  ),
                  Center(
                    child: Text("Messages"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
