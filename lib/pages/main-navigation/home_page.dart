import 'package:flutter/material.dart';
import 'package:social_app/pages/constants/constants.dart';
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
        drawer: isSmallPage(context, "Drawer"),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                leading: isSmallPage(context, "Leading IconButton"),
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
                  // Replace with Stream.builder/Future.builder
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
