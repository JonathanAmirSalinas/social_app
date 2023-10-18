import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/time_services.dart';
import 'package:social_app/widgets/activity/activity_content.dart';
import 'package:social_app/widgets/constant_widgets.dart';

@RoutePage(name: 'notification_tab')
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorSolid,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: ((context,
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var notification = snapshot.data!.docs[index].data();
                      switch (notification['type']) {
                        case 'liked_content':
                          return buildLikedPostNotification(
                              context, notification);
                        case 'commented_content':
                          return buildCommentedNotification(
                              context, notification);
                        case 'mention':
                          return buildMentionNotification(
                              context, notification);
                        default:
                          return Container();
                      }
                    });

              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var notification = snapshot.data!.docs[index].data();
                      switch (notification['type']) {
                        case 'liked_content':
                          return Container();
                        case 'commented_content':
                          return Container();

                        case 'mention':
                          return Container();
                        default:
                          return Container();
                      }
                    });
            }
          })),
    );
  }
}

// Builds Liked Post Notification Widget
buildLikedPostNotification(
    BuildContext context, Map<String, dynamic> notification) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: backgroundColorSolid),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserProfileImage(context, notification['id_sender']),
              Expanded(
                child: Column(
                  children: [
                    // User Info (Sender)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildNotificationUserInfo(
                              context, notification['id_sender']),
                          Text(
                            'has liked your post!',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize),
                          ),
                          // Timestamp
                          Text(
                            ' \u2022 ${timeAgoSinceDate(notification['timestamp'])}',
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize),
                          )
                        ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

buildCommentedNotification(
    BuildContext context, Map<String, dynamic> notification) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: backgroundColorSolid),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserProfileImage(context, notification['id_sender']),
              Expanded(
                child: Column(
                  children: [
                    // User Info (Sender)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildNotificationUserInfo(
                              context, notification['id_sender']),
                          Text(
                            'commented on...',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize),
                          ),
                          // Timestamp
                          Text(
                            ' \u2022 ${timeAgoSinceDate(notification['timestamp'])}',
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize),
                          )
                        ]),
                    buildNotificationContentBuilder(
                        context, notification['id_content'])
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

// Comment Builder (Selects what collection the content is locateed in)
buildNotificationContentBuilder(BuildContext context, String content) {
  return Builder(builder: (context) {
    switch (content[0]) {
      case 'p':
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: buildNotificationContent(context, content, 'posts'),
        );
      case 'c':
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: buildNotificationContent(context, content, 'comments'),
        );
      default:
        return Container();
    }
  });
}

// Builds the Commented Content
buildNotificationContent(
    BuildContext context, String contentID, String collection) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .doc(contentID)
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var content = snapshot.data!.data()!;
          return Card(
              color: navBarColor,
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: BuildActivityContent(content: content));
        } else {
          return Container();
        }
      }));
}

buildMentionNotification(
    BuildContext context, Map<String, dynamic> notification) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: backgroundColorSolid),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserProfileImage(context, notification['id_sender']),
              Expanded(
                child: Column(
                  children: [
                    // User Info (Sender)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildNotificationUserInfo(
                              context, notification['id_sender']),
                          Text(
                            'mentioned you...',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize),
                          ),
                          // Timestamp
                          Text(
                            ' \u2022 ${timeAgoSinceDate(notification['timestamp'])}',
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize),
                          )
                        ]),
                    buildNotificationContentBuilder(
                        context, notification['id_content'])
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
