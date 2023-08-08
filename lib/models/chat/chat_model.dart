import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final List members;
  final String chatID;
  final String recentMessage;
  final int timestamp;

  const ChatModel({
    required this.members,
    required this.chatID,
    required this.recentMessage,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'members': members,
        'id_chat': chatID,
        'recent_message': recentMessage,
        'timestamp': timestamp
      };

  static ChatModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatModel(
      members: snapshot['members'],
      chatID: snapshot['id_chat'],
      recentMessage: snapshot['recent_message'],
      timestamp: snapshot['timestamp'],
    );
  }
}

// ChatLabelModel is used for acquiring the specific chat ID saved between users
class ChatLabelModel {
  final String chatID;

  const ChatLabelModel({
    required this.chatID,
  });

  Map<String, dynamic> toJson() => {
        'id_chat': chatID,
      };

  static ChatLabelModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatLabelModel(
      chatID: snapshot['id_chat'],
    );
  }
}
