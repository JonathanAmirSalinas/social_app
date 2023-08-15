import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/notification_model.dart';
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
  Future<void> commentNotification() async {}
  // Mention Notification
  Future<void> mentionNotification() async {}
  // Friend Request Notification
  Future<void> friendRequestNotification() async {}
  // Accepted Friend Request Notification
  Future<void> acceptedFriendRequestNotification() async {}
  // New Follower Notification
  Future<void> followNotification() async {}
  // Message Notification
  Future<void> messageNotification() async {}
}
