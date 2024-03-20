import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/responsive/side_menu_page.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/services/time_services.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/content/comment_widget.dart';
import 'package:social_app/widgets/main/main_web_navigation_rail.dart';
import 'package:social_app/widgets/view_content.dart';

// TO-DO ///////////////////////////////////////////////////////////////////////
// 1: Make sure buttons work and refresh state
// 2: Deep Linking State errors (like and commenting)
// 3:

@RoutePage(name: 'view_content')
class ViewContentPage extends StatefulWidget {
  final String pid;

  const ViewContentPage({super.key, @PathParam('pid') required this.pid});

  @override
  State<ViewContentPage> createState() => _ViewContentPageState();
}

class _ViewContentPageState extends State<ViewContentPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: mainNavRailBackgroundColor,
            leading: IconButton(
                onPressed: (() {
                  context.router.back();
                }),
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          backgroundColor: Colors.black87,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildWebNavigationRail(context),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  decoration: const BoxDecoration(
                      color: mainBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildMainContent(),
                        buildCommentsList(),
                      ],
                    ),
                  ),
                ),
              ),
              constraints.maxWidth > 1280 ? const SideMenuPage() : Container(),
            ],
          ));
    }));
  }

  // Main Content
  buildMainContent() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.pid[0] == 'c' ? 'comments' : 'posts')
          .doc(widget.pid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var content = snapshot.data!.data()!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Body
              buildContent(content),
              // Post Stats
              buildContentStats(content),
              // Icons
              buildIconSection(content),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Builds Comment Sections
  buildCommentsList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('id_reference', isEqualTo: widget.pid)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var content = snapshot.data!.docs[index].data();
                    return BuildCommentContent(content: content);
                  });
            case ConnectionState.done:
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var content = snapshot.data!.docs[index].data();
                    return BuildCommentContent(
                      content: content,
                    );
                  });
          }
        }));
  }

  buildContent(Map<String, dynamic> content) {
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () async {
        //await feedProvider.refreshPost(content['id_content']);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(4, 1, 4, 1),
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // BODY
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile Image
                    buildUserProfileImage(context, content["id_content_owner"]),
                    Expanded(
                      child: buildUserInfo(context, content, false),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Post
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: buildDetectableStatement(
                                          context,
                                          content['statement'],
                                          TextOverflow.visible)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Image or Media
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Column(
                                children: [
                                  // Checks if Post has media
                                  content['hasMedia'] == true
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewContent(
                                                      snap: content);
                                                });
                                          },
                                          child: AspectRatio(
                                            aspectRatio: kIsWeb ? 2 : 1.5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              content[
                                                                  'media_url']),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16))),
                                            ),
                                          ),
                                          // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                          onDoubleTap: () {},
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildContentStats(Map<String, dynamic> content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              // Timestamp
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  timeAgoSinceDate(content['timestamp']),
                  style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).month.toString()}/${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).day.toString()}/${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).year.toString()}',
                  style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 3, color: mainNavRailBackgroundColor))),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(content['likes'].length.toString()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Likes'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(content['comments'].length.toString()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Comments'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildIconSection(Map<String, dynamic> content) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 3, color: mainNavRailBackgroundColor))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Like Icon

              IconButton(
                onPressed: () async {
                  await ContentServices().likePost(
                      FirebaseAuth.instance.currentUser!.uid,
                      content['id_content_owner'],
                      content['id_content'],
                      content['type']);
                  //await updateContentData();
                  //await feedProvider.refreshPost(content['id_content']);
                },
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                splashRadius: 16,
                icon: content['likes']
                        .toString()
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline_rounded,
                        size: 16,
                        color: Colors.white54,
                      ),
              ),

              // Comment Icon
              IconButton(
                onPressed: () async {
                  buildCommentDialog(context, content);
                  //await updateContentData();
                  //await feedProvider.refreshPost(content['id_content']);
                },
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.insert_comment_outlined,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),

              IconButton(
                onPressed: () {},
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.share,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),
              IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.bookmark_border_outlined,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 3, color: mainNavRailBackgroundColor))),
        ),
      ],
    );
  }
}

  /*

  bool loading = false;
  Map<String, dynamic> content = {};
  List<Map<String, dynamic>> comments = [];
  ScrollController scrollController = ScrollController();

  // Update Content Values
  Future<void> updateContentData() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.pid)
          .get()
          .then((value) {
        setState(() {
          content = value.data()!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getContent() async {
    setState(() {
      loading = true;
    });
    try {
      if (widget.pid[0] == 'p') {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.pid)
            .get()
            .then((value) {
          setState(() {
            content = value.data()!;
          });
        });
        await getCommentList(content['comments'].length);
      } else {
        await FirebaseFirestore.instance
            .collection('comments')
            .doc(widget.pid)
            .get()
            .then((value) {
          setState(() {
            content = value.data()!;
          });
        });
        await getCommentList(content['comments'].length);
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  getCommentList(int commentSize) async {
    try {
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < commentSize; i++) {
        await FirebaseFirestore.instance
            .collection('comments')
            .where('id_reference', isEqualTo: widget.pid)
            .get()
            .then((value) {
          for (final doc in value.docs) {
            list.add(doc.data());
          }
        });
      }
      setState(() {
        comments = list;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return loading
        ? Container(
            color: backgroundColorSolid,
            child: const Center(
                child: CircularProgressIndicator(
              backgroundColor: backgroundColorSolid,
            )),
          )
        : Scaffold(
            backgroundColor: cardColor,
            appBar: AppBar(
              backgroundColor: navBarColor,
              leading: IconButton(
                  onPressed: () {
                    context.router.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
            ),
            body: LoadMoreListView.builder(
                shrinkWrap: true,
                hasMoreItem: true,
                refreshEdgeOffset: 40,
                padding: const EdgeInsets.only(bottom: 16),
                onLoadMore: getContent,
                onRefresh: getContent,
                itemCount: content['comments'].length + 1, // + 1 for view
                itemBuilder: (context, index) {
                  // Main Post
                  if (index == 0) {
                    return Column(
                      children: [
                        // Body
                        buildContent(content),
                        // Post Stats
                        buildContentStats(feedProvider),
                        // Icons
                        buildIconSection(feedProvider),
                      ],
                    );
                  } else {
                    return BuildCommentContent(content: comments[index - 1]);
                  }
                }),
          );
  }

  buildContent(Map<String, dynamic> content) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () async {
        await feedProvider.refreshPost(content['id_content']);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // BODY
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile Image
                    buildUserProfileImage(context, content),
                    Expanded(
                      child: buildUserInfo(context, content),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Post
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      content['statement'],
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .fontSize),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Image or Media
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Column(
                                children: [
                                  // Checks if Post has media
                                  content['hasMedia'] == true
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewContent(
                                                      snap: content);
                                                });
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            content[
                                                                'media_url']),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16))),
                                          ),
                                          // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                          onDoubleTap: () {},
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  buildContentStats(FeedProvider feedProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              // Timestamp
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  timeAgoSinceDate(content['timestamp']),
                  style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).month.toString()}/${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).day.toString()}/${DateTime.fromMillisecondsSinceEpoch(content['timestamp']).year.toString()}',
                  style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 3, color: navBarColor))),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(content['likes'].length.toString()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Likes'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(content['comments'].length.toString()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Comments'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildIconSection(FeedProvider feedProvider) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Like Icon

              IconButton(
                onPressed: () async {
                  await ContentServices().likePost(
                      FirebaseAuth.instance.currentUser!.uid,
                      content['id_content_owner'],
                      content['id_content'],
                      content['type']);
                  await updateContentData();
                  await feedProvider.refreshPost(content['id_content']);
                },
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                splashRadius: 16,
                icon: content['likes']
                        .toString()
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline_rounded,
                        size: 16,
                        color: Colors.white54,
                      ),
              ),

              // Comment Icon
              IconButton(
                onPressed: () async {
                  print(content);
                  buildCommentDialog(context, content);
                  await updateContentData();
                  await feedProvider.refreshPost(content['id_content']);
                },
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.insert_comment_outlined,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),

              IconButton(
                onPressed: () {},
                padding: const EdgeInsets.symmetric(horizontal: 1),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.share,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),
              IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.bookmark_border_outlined,
                  size: 16,
                  color: Colors.white54,
                ),
                splashRadius: 16,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
        ),
      ],
    );
  }
}


SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Column(
                    children: [
                      // Body
                      buildContent(content),
                      // Post Stats
                      buildContentStats(feedProvider),
                      // Icons
                      buildIconSection(feedProvider),
                    ],
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where('id_reference', isEqualTo: widget.pid)
                          .snapshots(),
                      builder: ((context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Container();
                          case ConnectionState.active:
                            return LoadMoreListView.builder(
                                shrinkWrap: true,
                                hasMoreItem: true,
                                refreshEdgeOffset: 40,
                                padding: const EdgeInsets.only(bottom: 16),
                                onLoadMore: getContent,
                                onRefresh: getContent,
                                itemCount:
                                    content['comments'].length, // + 1 for view
                                itemBuilder: (context, index) {
                                  var content =
                                      snapshot.data!.docs[index].data();
                                  return BuildCommentContent(content: content);
                                });
                          case ConnectionState.done:
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: commentFeedLength >
                                        snapshot.data!.docs.length
                                    ? snapshot.data!.docs.length
                                    : commentFeedLength,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var content =
                                      snapshot.data!.docs[index].data();
                                  return BuildCommentContent(
                                    content: content,
                                  );
                                });
                        }
                      })),
                ],
              ),
            ),

*/
