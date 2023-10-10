import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/sub-navigation/content/create_comment_page.dart';
import 'package:social_app/pages/sub-navigation/content/create_repost_page.dart';
import 'package:social_app/router/app_router.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/services/time_services.dart';

//////////////////////////////////////////////////////////////////////// Dialogs
buildRePostDialog(BuildContext context, Map<String, dynamic> content) {
  return showDialog(
    context: context,
    builder: (context) {
      return CreateRePostPage(content: content);
    },
  );
}

buildCommentDialog(BuildContext context, Map<String, dynamic> content) {
  return showDialog(
    context: context,
    builder: (context) {
      return CreateCommentPage(content: content);
    },
  );
}

buildContentMenu(BuildContext context) {
  return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'Mute':
            //context.router.back();
            break;
          case 'Block':
            //context.router.back();
            break;
          case 'Report':
            //context.router.back();
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
            const PopupMenuItem(value: 'Report', child: Text('Mute')),
            const PopupMenuItem(child: Text('Block')),
            const PopupMenuItem(child: Text('Report')),
          ]);
}

////////////////////////////////////////////////////////////////// Icon Sections
buildBlankIconSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Share
          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.switch_access_shortcut,
              size: 18,
              color: Colors.white54,
            ),
          ),

          // Like Icon
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline_rounded,
              size: 18,
              color: Colors.white54,
            ),
            label: const Text(
              '0',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          // Comment Icon
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.insert_comment_outlined,
              size: 18,
              color: Colors.white54,
            ),
            label: const Text(
              '0',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.share,
              size: 18,
              color: Colors.white54,
            ),
            splashRadius: 20,
          ),
        ],
      ),
      IconButton(
        onPressed: () {},
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.bookmark_border_outlined,
          size: 18,
          color: Colors.white54,
        ),
        splashRadius: 20,
      ),
    ],
  );
}

// Interactive Icon Section
buildInteractiveIconSection(BuildContext context, Map<String, dynamic> data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Share
          IconButton(
            onPressed: () {
              buildRePostDialog(context, data);
            },
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.switch_access_shortcut,
              size: 18,
              color: Colors.white54,
            ),
          ),

          // Like Icon
          TextButton.icon(
            onPressed: () async {
              await ContentServices().likePost(
                  FirebaseAuth.instance.currentUser!.uid,
                  data['id_content_owner'],
                  data['id_content'],
                  data['type']);
              //await feedProvider.refreshPost(data['id_content']);
            },
            icon: data['likes']
                    .toString()
                    .contains(FirebaseAuth.instance.currentUser!.uid)
                ? const Icon(
                    Icons.favorite,
                    size: 18,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_outline_rounded,
                    size: 18,
                    color: Colors.white54,
                  ),
            label: Text(
              data['likes'].length.toString(),
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          // Comment Icon
          TextButton.icon(
            onPressed: () {
              buildCommentDialog(context, data);
            },
            icon: const Icon(
              Icons.insert_comment_outlined,
              size: 18,
              color: Colors.white54,
            ),
            label: Text(
              data['comments'].length.toString(),
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.share,
              size: 18,
              color: Colors.white54,
            ),
            splashRadius: 20,
          ),
        ],
      ),
      IconButton(
        onPressed: () {},
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.bookmark_border_outlined,
          size: 18,
          color: Colors.white54,
        ),
        splashRadius: 20,
      ),
    ],
  );
}

// Non Interactive Icon Section
buildNonInteractiveIconSection(
    BuildContext context, Map<String, dynamic> data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Share
          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.switch_access_shortcut,
              size: 18,
              color: Colors.white54,
            ),
          ),

          // Like Icon
          TextButton.icon(
            onPressed: () {},
            icon: data['likes']
                    .toString()
                    .contains(FirebaseAuth.instance.currentUser!.uid)
                ? const Icon(
                    Icons.favorite,
                    size: 18,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_outline_rounded,
                    size: 18,
                    color: Colors.white54,
                  ),
            label: Text(
              data['likes'].length.toString(),
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          // Comment Icon
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.insert_comment_outlined,
              size: 18,
              color: Colors.white54,
            ),
            label: Text(
              data['comments'].length.toString(),
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ),

          IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.share,
              size: 18,
              color: Colors.white54,
            ),
            splashRadius: 20,
          ),
        ],
      ),
      IconButton(
        onPressed: () {},
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.bookmark_border_outlined,
          size: 18,
          color: Colors.white54,
        ),
        splashRadius: 20,
      ),
    ],
  );
}

///////////////////////////////////////////////////////////// User Profile Image
///
buildUserProfileImage(BuildContext context, String data) {
  return StreamBuilder(
    stream:
        FirebaseFirestore.instance.collection('users').doc(data).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return GestureDetector(
          onTap: () {
            context.router.pushNamed('/profile/${data}');
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

buildReferenceProfileImage(BuildContext context, Map<String, dynamic> data) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(data['id_content_owner'])
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return GestureDetector(
          onTap: () {
            context.router.pushNamed('/profile/${data['id_content_owner']}');
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

////////////////////////////////////////////////////////////////////// User Data
///
buildUserInfo(
    BuildContext context, Map<String, dynamic> data, bool interactive) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(data['id_content_owner'])
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 0, 4),
          child: GestureDetector(
              onTap: () {
                context.router
                    .pushNamed('/profile/${data['id_content_owner']}');
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
                              ' \u2022 ${timeAgoSinceDate(data['timestamp'])}',
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
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (interactive) {
                          context.router
                              .pushNamed('/content/${data['id_content']}');
                        }
                      },
                      child: Container(
                        color: const Color.fromARGB(0, 255, 255, 255),
                      ),
                    )),
                    buildContentMenu(context),
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

buildReferenceUserInfo(BuildContext context, Map<String, dynamic> data) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(data['id_content_owner'])
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 0, 4),
          child: GestureDetector(
              onTap: () {
                context.router
                    .pushNamed('/profile/${data['id_content_owner']}');
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
                              ' \u2022 ${timeAgoSinceDate(data['timestamp'])}',
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
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        context.router.push(View_content(
                          pid: data['id_content'],
                        ));
                      },
                      child: Container(
                        color: const Color.fromARGB(0, 255, 255, 255),
                      ),
                    )),
                    //buildContentMenu(context)
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

// Notification User's Info
////////////////////////////////////////////////////////////////////////////////
buildNotificationUserInfo(BuildContext context, String data) {
  return StreamBuilder(
    stream:
        FirebaseFirestore.instance.collection('users').doc(data).snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data!.data()!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 0, 4),
          child: GestureDetector(
              onTap: () {
                context.router.pushNamed('/profile/${data}');
              },
              child: SizedBox(
                height: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            user['name'],
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
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
