import 'package:cloud_firestore/cloud_firestore.dart';

////////////////////////////////////////////////// Like Notification Model ///
class LikeNotificationModel {
  final String nid; // notification
  final String pid; // target post
  final String receiver; // target user
  final String sender; // owner
  final String type; // message
  final bool seen;
  final int timestamp;

  LikeNotificationModel({
    required this.nid,
    required this.pid,
    required this.receiver,
    required this.sender,
    required this.seen,
    required this.type,
    required this.timestamp,
  }); // user that commented

  Map<String, dynamic> toJson() => {
        'id_notification': nid,
        'id_content': pid,
        'id_receiver': receiver,
        'id_sender': sender,
        'seen': seen,
        'type': type,
        'timestamp': timestamp,
      };

  static LikeNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LikeNotificationModel(
      nid: snapshot['id_notification'],
      pid: snapshot['id_content'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      seen: snapshot['seen'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}

////////////////////////////////////////////////// Comment Notification Model ///
class CommentNotificationModel {
  final String cid;
  final String nid; // notification
  final String pid; // target post
  final String receiver; // target user
  final String sender; // owner
  final String type; // message
  final bool seen;
  final int timestamp;

  CommentNotificationModel({
    required this.cid,
    required this.nid,
    required this.pid,
    required this.receiver,
    required this.sender,
    required this.type,
    required this.seen,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id_comment': cid,
        'id_notification': nid,
        'id_content': pid,
        'id_receiver': receiver,
        'id_sender': sender,
        'seen': seen,
        'type': type,
        'timestamp': timestamp,
      };

  static CommentNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentNotificationModel(
      cid: snapshot['id_comment'],
      nid: snapshot['id_notification'],
      pid: snapshot['id_content'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      seen: snapshot['seen'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}

////////////////////////////////////////////////// Follow Notification Model ///
class FollowNotificationModel {
  final String nid; // notification
  final String receiver; // target user
  final String sender; // owner
  final String type; // message
  final bool seen;
  final int timestamp;

  FollowNotificationModel({
    required this.nid,
    required this.receiver,
    required this.sender,
    required this.type,
    required this.seen,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id_notification': nid,
        'id_receiver': receiver,
        'id_sender': sender,
        'seen': seen,
        'type': type,
        'timestamp': timestamp,
      };

  static FollowNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return FollowNotificationModel(
      nid: snapshot['id_notification'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      seen: snapshot['seen'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}

////////////////////////////////////////// Friend Request Notification Model ///
class FriendRequestNotificationModel {
  final String nid; // notification
  final String receiver; // target user
  final String sender; // owner
  final String type; // message
  final int timestamp;

  FriendRequestNotificationModel({
    required this.nid,
    required this.receiver,
    required this.sender,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id_notification': nid,
        'id_receiver': receiver,
        'id_sender': sender,
        'type': type,
        'timestamp': timestamp,
      };

  static FriendRequestNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return FriendRequestNotificationModel(
      nid: snapshot['id_notification'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}

////////////////////////////////////////////////// Mention Notification Model ///
class MentionNotificationModel {
  final String nid; // notification id
  final String pid; // target post/content
  final String receiver; // target user
  final String sender; // owner
  final String type; // message
  final bool seen;
  final int timestamp;

  MentionNotificationModel({
    required this.nid,
    required this.pid,
    required this.receiver,
    required this.sender,
    required this.type,
    required this.seen,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id_notification': nid,
        'id_content': pid,
        'id_receiver': receiver,
        'id_sender': sender,
        'seen': seen,
        'type': type,
        'timestamp': timestamp,
      };

  static MentionNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MentionNotificationModel(
      nid: snapshot['id_notification'],
      pid: snapshot['id_content'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      seen: snapshot['seen'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}

////////////////////////////////////////// Server Mention Notification Model ///
class ServerMentionNotificationModel {
  final String nid; // notification id
  final String pid; // target post/content
  final String receiver; // target user
  final String sender; // owner
  final String server; // Server ID
  final String channel; // Channel ID/Channel Name
  final String type; // message
  final bool seen;
  final int timestamp;

  ServerMentionNotificationModel({
    required this.nid,
    required this.pid,
    required this.receiver,
    required this.sender,
    required this.server,
    required this.channel,
    required this.type,
    required this.seen,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id_notification': nid,
        'id_content': pid,
        'id_receiver': receiver,
        'id_sender': sender,
        'server': server,
        'channel': channel,
        'seen': seen,
        'type': type,
        'timestamp': timestamp,
      };

  static ServerMentionNotificationModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerMentionNotificationModel(
      nid: snapshot['id_notification'],
      pid: snapshot['id_content'],
      receiver: snapshot['id_receiver'],
      sender: snapshot['sender'],
      server: snapshot['server'],
      channel: snapshot['channel'],
      seen: snapshot['seen'],
      type: snapshot['type'],
      timestamp: snapshot['timestamp'],
    );
  }
}
