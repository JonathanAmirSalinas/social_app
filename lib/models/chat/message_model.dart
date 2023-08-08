import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String from;
  final String messageID;
  final String message;
  final String media;
  final bool seen;
  final int timestamp;
  final String type;

  const MessageModel({
    required this.from,
    required this.messageID,
    required this.message,
    required this.media,
    required this.seen,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'from': from,
        'id_message': messageID,
        'message': message,
        'media': media,
        'seen': seen,
        'timestamp': timestamp,
        'message_type': type,
      };

  static MessageModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
        from: snapshot['from'],
        messageID: snapshot['id_message'],
        message: snapshot['message'],
        media: snapshot['media'],
        seen: snapshot['seen'],
        timestamp: snapshot['created_timestamp'],
        type: snapshot['message_type']);
  }
}
