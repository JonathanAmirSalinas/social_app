import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/pages/sub-navigation/post/create_post_page.dart';
import 'package:social_app/providers/feed_provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/widgets/post_widget.dart';

@RoutePage(name: 'home')
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController feedController = ScrollController();
  String scrollPostion = "";
  late List<Map<String, dynamic>> feed;

  @override
  void initState() {
    //feedController.addListener(_feedController);
    super.initState();
  }

  /*void _feedController() {
    if (feedController.position.pixels ==
        feedController.position.maxScrollExtent) {
      scrollPostion = 'bottom';
      print('Bottom');
    } else if (feedController.position.pixels ==
        feedController.position.minScrollExtent) {
      scrollPostion = 'top';
      print('Top');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
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
                      onPressed: () {
                        buildCreatePostDialog(userProvider);
                      },
                      icon: const Icon(Icons.add))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LoadMoreListView.builder(
                shrinkWrap: true,
                hasMoreItem: true,
                refreshEdgeOffset: 40,
                padding: const EdgeInsets.only(bottom: 16),
                onLoadMore: feedProvider.refreshBottomFeed,
                onRefresh: () => feedProvider.refreshTopFeed(false),
                itemCount: feedProvider.getFeed.length,
                itemBuilder: (context, index) {
                  //String pid = feedProvider.getFeed[index]['id_content'];
                  //return PostWidget(pid: pid);
                  var snap = feedProvider.getFeed[index];
                  return BuildPostCard(snap: snap);
                }),
          ),
        ],
      ),
    );
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

class PostWidget extends StatelessWidget {
  final String pid;
  const PostWidget({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('posts').doc(pid).snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var post = snapshot.data!.data();
          return BuildPostCard(snap: post!);
        });
  }
}

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