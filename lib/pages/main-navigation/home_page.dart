import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/widgets/post_card_widget.dart';

@RoutePage(name: 'home')
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: isSmallPage(context, "Drawer"),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: isSmallPage(context, "Leading IconButton"),
        backgroundColor: navBarColor,
        centerTitle: true,
        title: Text(
          userProvider.name,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
        ),
        actions: [
          isMobileScreen(MediaQuery.of(context).size.width)
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.add))),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Replace with Stream.builder/Future.builder
              Draggable(
                  data: 1,
                  feedback: Container(
                    height: 150,
                    width: 300,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: primaryColor),
                    child: Column(
                      children: [],
                    ),
                  ),
                  child: const BuildPostCard()),
              Draggable(
                  data: 5,
                  feedback: Container(
                    height: 150,
                    width: 300,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: primaryColor),
                    child: Column(
                      children: [],
                    ),
                  ),
                  child: const BuildPostCard()),
              Draggable(
                  data: 8,
                  feedback: Container(
                    height: 150,
                    width: 300,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: primaryColor),
                    child: Column(
                      children: [],
                    ),
                  ),
                  child: const BuildPostCard()),
            ],
          ),
        ),
      ),
    );
  }
}
