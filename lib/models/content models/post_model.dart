import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String contentOwnerID;
  final String contentID;
  final String type;
  final String statement;
  final int timestamp;
  final String postUrl;
  final bool hasMedia;
  final List likes;
  final List<String> comments;
  final List<String> hashtags;
  final List<String> mentions;

  const PostModel({
    required this.contentOwnerID,
    required this.contentID,
    required this.type,
    required this.statement,
    required this.timestamp,
    required this.postUrl,
    required this.hasMedia,
    required this.likes,
    required this.comments,
    required this.hashtags,
    required this.mentions,
  });

  Map<String, dynamic> toJson() => {
        'id_content_owner': contentOwnerID,
        'id_content': contentID,
        'type': type,
        'statement': statement,
        'timestamp': timestamp,
        'media_url': postUrl,
        'hasMedia': hasMedia,
        'likes': likes,
        'comments': comments,
        'hashtags': hashtags,
        'mentions': mentions,
      };

  static PostModel dataFromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      contentOwnerID: snapshot['id_content_owner'],
      contentID: snapshot['id_content'],
      type: snapshot['type'],
      statement: snapshot['statement'],
      timestamp: snapshot['timestamp'],
      postUrl: snapshot['media_url'],
      hasMedia: snapshot['hasMedia'],
      likes: snapshot['likes'],
      comments: snapshot['comments'],
      hashtags: snapshot['hashtags'],
      mentions: snapshot['mentions'],
    );
  }
}
