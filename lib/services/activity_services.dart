import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/content%20models/notification_model.dart';
import 'package:uuid/uuid.dart';

class ActivityServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Mark Notification as Seen (False -> True)
  Future<void> seenNotification() async {}
  // Like Notification
  Future<void> likeNotification(
    String sender,
    String receiver,
    String pid,
    String type,
  ) async {
    try {
      String nid = const Uuid().v1();
      LikeNotificationModel notification = LikeNotificationModel(
        nid: nid,
        pid: pid,
        receiver: receiver,
        sender: sender,
        seen: false,
        type: type, // Type
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      // Sends Notification of a Like
      _firestore
          .collection('users')
          .doc(receiver)
          .collection('notifications')
          .doc(nid)
          .set(notification.toJson());
    } catch (e) {}
  }

  // Comment Notification
  Future<void> commentNotification(String sender, String commentID,
      String receiver, String referenceID, String type, int time) async {
    try {
      String nid = const Uuid().v1();
      CommentNotificationModel notification = CommentNotificationModel(
        cid: commentID,
        nid: nid,
        pid: referenceID,
        receiver: receiver,
        sender: sender,
        seen: false,
        type: type, // Type
        timestamp: time,
      );
      // Sends Notification of a Comment
      _firestore
          .collection('users')
          .doc(receiver)
          .collection('notifications')
          .doc(nid)
          .set(notification.toJson());
    } catch (e) {}
  }

  // Mention Notification
  Future<void> mentionNotification(String sender, String receiver,
      String referenceID, String type, int time) async {
    try {
      // Sends Notification of a Mention
      String nid = const Uuid().v1();
      MentionNotificationModel notification = MentionNotificationModel(
        nid: nid,
        pid: referenceID,
        receiver: receiver,
        sender: sender,
        seen: false,
        type: type, // Type
        timestamp: time,
      );
      // Sends Notification of a Comment
      _firestore
          .collection('users')
          .doc(receiver)
          .collection('notifications')
          .doc(nid)
          .set(notification.toJson());
    } catch (e) {}
  }

  // Friend Request Notification
  Future<void> friendRequestNotification() async {}
  // Accepted Friend Request Notification
  Future<void> acceptedFriendRequestNotification() async {}
  // New Follower Notification
  Future<void> followNotification(
    String receiver,
    String pid,
    String sender,
  ) async {
    try {
      String nid = const Uuid().v1();
      FollowNotificationModel notification = FollowNotificationModel(
        nid: nid,
        receiver: receiver,
        sender: sender,
        seen: false,
        type: 'follow', // Type
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      // Sends Notification of a follow
      _firestore
          .collection('users')
          .doc(receiver)
          .collection('notifications')
          .doc(nid)
          .set(notification.toJson());
    } catch (e) {}
  }

  // Message Notification
  Future<void> messageNotification() async {}
}
