import 'package:flutter/material.dart';
import 'package:social_app/widgets/nav_drawer_widget.dart';
import 'package:social_app/widgets/post_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MediaQuery.of(context).size.width == 500 ||
                MediaQuery.of(context).size.width < 500
            ? const NavigationDrawer()
            : null,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              MediaQuery.of(context).size.width == 500 ||
                      MediaQuery.of(context).size.width < 500
                  ? SliverAppBar(
                      pinned: true,
                      floating: true,
                      snap: true,
                      leading: Builder(builder: (BuildContext context) {
                        return IconButton(
                          alignment: Alignment.center,
                          //padding: const EdgeInsets.symmetric(horizontal: 20),
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.dehaze_rounded,
                            size: 28,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      }),
                      title: Text(
                          'Window width: ${MediaQuery.of(context).size.width.toString()}'),
                      centerTitle: true,
                      actions: const [],
                    )
                  : SliverAppBar(
                      pinned: true,
                      floating: true,
                      snap: true,
                      leading: null,
                      title: Text(
                          'Window width: ${MediaQuery.of(context).size.width.toString()}'),
                      centerTitle: true,
                      actions: const [],
                    )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  BuildPostCard(),
                  BuildPostCard(),
                  BuildPostCard(),
                ],
              ),
            ),
          ),
        ));
  }
}
