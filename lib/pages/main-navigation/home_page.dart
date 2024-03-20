import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/content/re_post_widget.dart';
import 'package:social_app/widgets/content/post_widget.dart';

@RoutePage(name: 'home')
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return Scaffold(
        backgroundColor: mainBackgroundColor,
        drawer: isSmallPage(context, "Drawer"),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var content = snapshot.data!.docs[index].data();
                        switch (content['type']) {
                          case 'post':
                            return BuildPostContent(content: content);
                          case 're_post':
                            return BuildRePostContent(content: content);
                          case 'ad':
                            return Container();
                          case 'server_link':
                            return Container();
                          case 'server_post':
                            return Container();
                          default:
                            return Container();
                        }
                      });

                case ConnectionState.done:
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var content = snapshot.data!.docs[index].data();
                        switch (content['type']) {
                          case 'post':
                            return BuildPostContent(content: content);
                          case 're_post':
                            return BuildRePostContent(content: content);
                          case 'ad':
                            return Container();
                          case 'server_link':
                            return Container();
                          case 'server_post':
                            return Container();
                          default:
                            return Container();
                        }
                      });
              }
            }));
  }
}
