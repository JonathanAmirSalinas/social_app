class ActivityServices {
  // Mark Notification as Seen (False -> True)
  Future<void> seenNotification() async {}
  // Like Notification
  Future<void> likeNotification() async {}
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
