import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/providers/feed_provider.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/services/time_services.dart';

class BuildPostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const BuildPostCard({super.key, required this.snap});

  @override
  State<BuildPostCard> createState() => _BuildPostCardState();
}

class _BuildPostCardState extends State<BuildPostCard> {
  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () {
        feedProvider.refreshPost(widget.snap);
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.fromLTRB(4, 4, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              // BODY
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  buildUserPostProfileImage(
                      context, widget.snap['id_content_owner']),
                  Expanded(
                    child: Column(
                      children: [
                        // User Identification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildUserPostInfo(
                                  context,
                                  widget.snap['id_content_owner'],
                                  widget.snap['timestamp']),
                            )
                          ],
                        ),
                        // Post
                        widget.snap['statement'] == ""
                            ? Container()
                            : Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.snap['statement'],
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    // Checks if Post has media
                                    widget.snap['hasMedia'] == true
                                        ? GestureDetector(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              widget.snap[
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
                                    // Icons
                                    buildIconPostSection(context, feedProvider),
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
      ),
    );
  }

  buildIconPostSection(BuildContext context, FeedProvider feedProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Like Icon
            IconButton(
              onPressed: () async {
                await ContentServices().likePost(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.snap['id_content_owner'],
                    widget.snap['id_content']);
                feedProvider.refreshPost(widget.snap);
              },
              padding: const EdgeInsets.symmetric(horizontal: 1),
              constraints: const BoxConstraints(),
              splashRadius: 16,
              icon: widget.snap['likes']
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                widget.snap['likes'].length.toString(),
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .01,
            ),
            // Comment Icon
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 1),
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.insert_comment_outlined,
                size: 16,
                color: Colors.white54,
              ),
              splashRadius: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                '0',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .01,
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
          ],
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
    );
  }
}

buildUserPostProfileImage(BuildContext context, String uid) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/profile', arguments: user);
          },
          child: Container(
            height: 55,
            width: 55,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(user['profile_image']),
                  fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    },
  );
}

buildUserPostInfo(BuildContext context, String userID, int timestamp) {
  return StreamBuilder(
    stream:
        FirebaseFirestore.instance.collection('users').doc(userID).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 0, 4),
          child: GestureDetector(
              onTap: () {
                //Navigator.of(context).pushNamed('/profile', arguments: user);
              },
              child: SizedBox(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user['name'],
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize),
                            ),
                            // Timestamp
                            Text(
                              ' \u2022 ${timeAgoSinceDate(timestamp)}',
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .fontSize),
                            )
                          ],
                        ),
                        Text(
                          user['username'],
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) => Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: ["Delete", "Report"]
                                          .map((e) => InkWell(
                                                onTap: () {},
                                                child: Center(
                                                  child: Container(
                                                    width: 200,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16,
                                                    ),
                                                    child: Text(e),
                                                  ),
                                                ),
                                              ))
                                          .toList()))));
                        },
                        icon: const Icon(Icons.more_vert_rounded)),
                  ],
                ),
              )),
        );
      } else {
        return Container();
      }
    },
  );
}
