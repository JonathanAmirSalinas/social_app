import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

buildChannelAppbarTitle(BuildContext context, String channel) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('server-channels')
        .doc(channel)
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var channel = snapshot.data!.data()!;
        return Text(
          '#${channel['channel_name']}',
          style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
        );
      } else {
        return Container();
      }
    },
  );
}

buildDrawerChannelTabName(BuildContext context, String channel) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('server-channels')
        .doc(channel)
        .snapshots(),
    builder: (context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.hasData) {
        var channel = snapshot.data!.data()!;
        return Text(
          '#${channel['channel_name']}',
          style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: Theme.of(context).textTheme.labelLarge!.fontSize),
        );
      } else {
        return Container();
      }
    },
  );
}
