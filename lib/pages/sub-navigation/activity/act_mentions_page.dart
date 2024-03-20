import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/activity/act_notifications_page.dart';

@RoutePage(name: 'mentions_tab')
class MentionsPage extends StatefulWidget {
  const MentionsPage({super.key});

  @override
  State<MentionsPage> createState() => _MentionsPageState();
}

class _MentionsPageState extends State<MentionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
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
                        case 'mention':
                          return buildMentionNotification(
                              context, notification);
                        default:
                          return Container();
                      }
                    });
            }
          })),
    );
  }
}
