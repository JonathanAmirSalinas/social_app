import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String from;
  final String messageID;
  final String message;
  final String media;
  final bool seen;
  final bool hasMedia;
  final int timestamp;
  final String type;
  final List mentions;

  const MessageModel(
      {required this.from,
      required this.messageID,
      required this.message,
      required this.media,
      required this.seen,
      required this.hasMedia,
      required this.timestamp,
      required this.type,
      required this.mentions});

  Map<String, dynamic> toJson() => {
        'from': from,
        'id_message': messageID,
        'message': message,
        'media': media,
        'seen': seen,
        'hasMedia': hasMedia,
        'timestamp': timestamp,
        'message_type': type,
        'mentions': mentions
      };

  static MessageModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
        from: snapshot['from'],
        messageID: snapshot['id_message'],
        message: snapshot['message'],
        media: snapshot['media'],
        seen: snapshot['seen'],
        hasMedia: snapshot['hasMedia'],
        timestamp: snapshot['created_timestamp'],
        type: snapshot['message_type'],
        mentions: snapshot['mentions']);
  }
}
