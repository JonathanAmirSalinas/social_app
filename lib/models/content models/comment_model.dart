import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String contentOwnerID; // User
  final String contentID;
  final String referenceOwnerID; // Target User
  final String referenceID;
  final String type;
  final String statement;
  final int timestamp;
  final String commentUrl;
  final bool hasMedia;
  final List likes;
  final List comments;

  const CommentModel({
    required this.contentOwnerID,
    required this.contentID,
    required this.referenceOwnerID,
    required this.referenceID,
    required this.type,
    required this.statement,
    required this.timestamp,
    required this.commentUrl,
    required this.hasMedia,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toJson() => {
        'id_content_owner': contentOwnerID,
        'id_content': contentID,
        'id_reference_owner': referenceOwnerID,
        'id_reference': referenceID,
        'type': type,
        'statement': statement,
        'timestamp': timestamp,
        'media_url': commentUrl,
        'hasMedia': hasMedia,
        'likes': likes,
        'comments': comments,
      };

  static CommentModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      contentOwnerID: snapshot['id_content_owner'],
      contentID: snapshot['id_content'],
      referenceOwnerID: snapshot['id_reference_owner'],
      referenceID: snapshot['id_reference'],
      type: snapshot['type'],
      statement: snapshot['statement'],
      timestamp: snapshot['timestamp'],
      commentUrl: snapshot['media_url'],
      hasMedia: snapshot['hasMedia'],
      likes: snapshot['likes'],
      comments: snapshot['comments'],
    );
  }
}
