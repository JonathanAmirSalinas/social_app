import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/sub-navigation/post/create_post_page.dart';
import 'package:social_app/widgets/content/re_post_widget.dart';
import 'package:social_app/providers/user_provider.dart';
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
    UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return Scaffold(
        backgroundColor: backgroundColorSolid,
        drawer: isSmallPage(context, "Drawer"),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: isSmallPage(context, "Leading IconButton"),
          backgroundColor: navBarColor,
          centerTitle: true,
          title: Text(
            '${userProvider.name} ${MediaQuery.of(context).size.width}',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
          ),
          actions: [
            isMobileScreen(MediaQuery.of(context).size.width)
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                        onPressed: () {
                          buildCreatePostDialog(userProvider);
                        },
                        icon: const Icon(Icons.add))),
          ],
        ),
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

  // Creates a Dialog Used to create a Post
  buildCreatePostDialog(UserModel userProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        return const CreatePostPage();
      },
    );
  }
}

/* Expanded(
              child: LoadMoreListView.builder(
                  shrinkWrap: true,
                  hasMoreItem: true,
                  addAutomaticKeepAlives: true,
                  refreshEdgeOffset: 40,
                  padding: const EdgeInsets.only(bottom: 16),
                  onLoadMore: feedProvider.refreshBottomFeed,
                  onRefresh: () => feedProvider.refreshTopFeed(false),
                  itemCount: feedProvider.getFeed.length,
                  itemBuilder: (context, index) {
                    String content = feedProvider.getFeed[index]['type'];
                    switch (content) {
                      case 'post':
                        return BuildPostContent(
                            content: feedProvider.getFeed[index]);
                      case 're_post':
                        return BuildRePostContent(
                            content: feedProvider.getFeed[index]);
                      case 'ad':
                        return Container();
                      case 'server_link':
                        return Container();
                      case 'server_post':
                        return Container();

                      default:
                        return Container();
                    }
                  }),
            ), */

/* String content = feed.getFeed[index]['type'];
              switch (content) {
                case 'post':
                  return BuildPostContent(content: feed.getFeed[index]);
                case 're_post':
                  return BuildRePostContent(content: feed.getFeed[index]);
                case 'ad':
                  return Container();
                case 'server_link':
                  return Container();
                case 'server_post':
                  return Container();

                default:
                  return Container();
              } */

/*StreamBuilder(
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

                        default:
                          return Container();
                      }
                    });
            }
          }), */




/*StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(feedProvider.getFeed[index]['id_content'])
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    var post = snapshot.data!.data();
                    return BuildPostCard(snap: post!);
                  }); */


/* Draggable(
                data: 1,
                feedback: Container(
                  height: 150,
                  width: 300,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: primaryColor),
                  child: const Column(
                    children: [],
                  ),
                ),
                child: const BuildPostCard(),
              ), */