import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/time_services.dart';

class ChannelMessage extends StatefulWidget {
  final Map<String, dynamic> message;
  final String sid;
  const ChannelMessage({super.key, required this.message, required this.sid});

  @override
  State<ChannelMessage> createState() => _ChannelMessageState();
}

class _ChannelMessageState extends State<ChannelMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          //feedProvider.refreshPost(widget.content['id_content']);
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                buildServerProfileImage(context, widget.message['from']),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Identification
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: buildMemberInfo(widget.message['from'],
                                widget.message['timestamp']),
                          )
                        ],
                      ),
                      // Post
                      Row(
                        children: [
                          widget.message['message'] == ''
                              ? Container()
                              : Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: buildDetectableStatement(
                                                context,
                                                widget.message['message'],
                                                TextOverflow.visible)),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      // Image or Media

                      // Checks if Post has media
                      widget.message['hasMedia'] == true
                          ? GestureDetector(
                              onTap: () {},
                              child: AspectRatio(
                                aspectRatio: kIsWeb ? 2 : 1.5,
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  alignment: Alignment.centerLeft,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Image.network(
                                    widget.message['media'],
                                  ),
                                ),
                              ),

                              // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                              onDoubleTap: () {},
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////// User Profile Image
  ///
  buildServerProfileImage(BuildContext context, String data) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(data).snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data()!;
          return GestureDetector(
            onTap: () {
              context.router.pushNamed('/profile/${user['uid']}');
            },
            child: Container(
              height: 50,
              width: 50,
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

  // Member Name
  buildMemberInfo(String member, int time) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('servers')
          .doc(widget.sid)
          .collection('members')
          .doc(member)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var member = snapshot.data!.data()!;

          return Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  member['member_name'],
                  style: TextStyle(
                      color: Color(hexToInteger(member['member_color'])),
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                      fontWeight: FontWeight.w500),
                ),
              ),
              // Timestamp
              Text(
                ' \u2022 ${timeAgoSinceDate(time)}',
                style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
