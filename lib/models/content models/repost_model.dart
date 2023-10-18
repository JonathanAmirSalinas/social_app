import 'package:cloud_firestore/cloud_firestore.dart';

class RePostModel {
  final String contentOwnerID;
  final String contentID;
  final String referenceID;
  final String type;
  final String statement;
  final int timestamp;
  final String postUrl;
  final bool hasMedia;
  final List likes;
  final List comments;
  final List<String> hashtags;
  final List<String> mentions;

  const RePostModel({
    required this.contentOwnerID,
    required this.contentID,
    required this.referenceID,
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
        'id_reference': referenceID,
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

  static RePostModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return RePostModel(
      contentOwnerID: snapshot['id_content_owner'],
      contentID: snapshot['id_content'],
      referenceID: snapshot['id_reference'],
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
