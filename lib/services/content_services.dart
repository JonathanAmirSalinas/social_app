import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:social_app/models/content%20models/comment_model.dart';
import 'package:social_app/models/content%20models/post_model.dart';
import 'package:social_app/models/content%20models/repost_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/activity_services.dart';
import 'package:social_app/services/storage_services.dart';
import 'package:uuid/uuid.dart';

class ContentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //
  Future<void> generateFeed(List<String> usersFriends) async {
    List<Map<String, dynamic>> feed = [];

    // Initially Load 10 post into the feed
    await _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        //.where('id_content_owner', whereIn: usersFriends)
        .limit(50)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        feed.add(doc.data());
      }
    });
  }

  // Retrieves Initial User Feed
  Future<List<Map<String, dynamic>>> getPost() async {
    List<Map<String, dynamic>> feed = [];

    User currentUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    UserModel user = UserModel.dataFromDoc(snap);

    String pid = user.posts[0];

    // Initially Load 10 post into the feed

    await _firestore.collection('posts').doc(pid).get().then((value) {
      feed.add(value.data()!);
    });

    return feed;
  }

  Future<Map<String, dynamic>> getUpdatedPost(String pid) async {
    Map<String, dynamic> updatedPost = {};

    try {
      await _firestore.collection('posts').doc(pid).get().then((value) {
        updatedPost = value.data()!;
        return updatedPost;
      });
    } on Exception catch (e) {
      print(e);
    }

    return updatedPost;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Should Saved 'Last Seen Feed' for user when closing and opening app
  // Save Feed Provider
  //////////////////////////////////////////////////////////////////////////////
  // Retrieves Initial User Feed
  Future<List<Map<String, dynamic>>> getUserFeed() async {
    List<Map<String, dynamic>> feed = [];

    // Initially Load 15 post into the feed
    await _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(15)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        feed.add(doc.data());
      }
    });

    return feed;
  }

  /////////////////////////////////////////////// Add new Posts to the User Feed
  Future<List<Map<String, dynamic>>> refreshFeed(
      int limit, bool top, int timestamp) async {
    List<Map<String, dynamic>> feed = [];

    if (top) {
      await _firestore
          .collection('posts')
          .where('timestamp', isGreaterThan: timestamp) // Refresh Top
          .limit(limit)
          .get()
          .then((value) {
        for (final doc in value.docs) {
          feed.add(doc.data());

          feed.shuffle(); // ?
        }
      });
    } else {
      await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .where('timestamp', isLessThan: timestamp) // Refresh Bottom
          .limit(limit)
          .get()
          .then((value) {
        for (final doc in value.docs) {
          feed.add(doc.data());
        }
      });
    }

    //
    return feed;
  }

  //////////////////////////////////////////////////////////// Post Services ///
  /// Post With Media
  Future<void> uploadMediaPost(String statement, File? file, Uint8List bytes,
      String contentType, String? ref) async {
    try {
      String postUrl;
      int time = DateTime.now().millisecondsSinceEpoch;
      //String pid = '${time}_${const Uuid().v1()}';
      String pid = 'p-${const Uuid().v1()}'; // 'p' Post collection indicator

      // Chacks if uploaded image is file or bytes format
      if (file == null) {
        postUrl = await StorageServices()
            .uploadImageBytesToStorage('user_media', bytes, pid);
      } else {
        postUrl = await StorageServices()
            .uploadImageFileToStorage('user_media', file, pid);
      }
      switch (contentType) {
        case 'post':
          {
            PostModel post = PostModel(
                contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
                contentID: pid,
                type: contentType,
                statement: statement,
                timestamp: time,
                postUrl: postUrl,
                hasMedia: true,
                likes: [],
                comments: []);
            // Sets to post into the Users's posts collection
            await _firestore.collection('posts').doc(pid).set(post.toJson());
            break;
          }
        case 're_post':
          {
            RePostModel post = RePostModel(
              contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
              contentID: pid,
              referenceID: ref!,
              type: contentType,
              statement: statement,
              timestamp: time,
              postUrl: postUrl,
              hasMedia: true,
              likes: [],
              comments: [],
            );

            // Sets to post into the Users's posts collection
            await _firestore.collection('posts').doc(pid).set(post.toJson());
            break;
          }

        default:
          print('Post Error');
      }

      // Adds new post into user's posts list
      await addPost(FirebaseAuth.instance.currentUser!.uid, pid);
    } catch (e) {
      print(e);
    }
  }

  // Post Without Media
  Future<void> uploadMessagePost(
      String statement, String contentType, String? ref) async {
    try {
      try {
        int time = DateTime.now().millisecondsSinceEpoch;
        // Used for quering
        //String pid = '${time}_${const Uuid().v1()}';
        String pid = 'p-${const Uuid().v1()}'; // 'p' Post collection indicator
        switch (contentType) {
          case 'post':
            {
              PostModel post = PostModel(
                  contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
                  contentID: pid,
                  type: contentType,
                  statement: statement,
                  timestamp: time,
                  postUrl: "",
                  hasMedia: false,
                  likes: [],
                  comments: []);
              // Sets to post into the Users's posts collection
              await _firestore.collection('posts').doc(pid).set(post.toJson());
              break;
            }
          case 're_post':
            {
              RePostModel post = RePostModel(
                contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
                contentID: pid,
                referenceID: ref!,
                type: contentType,
                statement: statement,
                timestamp: time,
                postUrl: "",
                hasMedia: false,
                likes: [],
                comments: [],
              );

              // Sets to post into the Users's posts collection
              await _firestore.collection('posts').doc(pid).set(post.toJson());
              break;
            }

          default:
            print('Post Error');
        }
        await addPost(FirebaseAuth.instance.currentUser!.uid, pid);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  // Add post into user's post list (used to count number of post user has posted)
  Future<void> addPost(String userId, String pid) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'posts': FieldValue.arrayUnion([pid])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost() async {}

  Future<void> bookmarkPost() async {}
  ///////////////////////////////////////////////////////// Comment Services ///
  Future<void> uploadMediaComment(String referenceOwner, String referencePostID,
      String type, String statement, File? file, Uint8List bytes) async {
    try {
      String commentUrl;
      int time = DateTime.now().millisecondsSinceEpoch;
      //String pid = '${time}_${const Uuid().v1()}';
      String cid = 'c-${const Uuid().v1()}';

      // Chacks if uploaded image is file or bytes format
      if (file == null) {
        commentUrl = await StorageServices()
            .uploadImageBytesToStorage('user_media', bytes, cid);
      } else {
        commentUrl = await StorageServices()
            .uploadImageFileToStorage('user_media', file, cid);
      }
      CommentModel comment = CommentModel(
          contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
          contentID: cid,
          referenceOwnerID: referenceOwner,
          referenceID: referencePostID,
          type: 'comment',
          statement: statement,
          timestamp: time,
          commentUrl: commentUrl,
          hasMedia: true,
          likes: [],
          comments: []);
      // Sets to post into the Users's posts collection
      await _firestore.collection('comments').doc(cid).set(comment.toJson());
      // Adds comment id into target comment's list
      if (type == 'comment') {
        await _firestore.collection('comments').doc(referencePostID).update({
          'comments': FieldValue.arrayUnion([cid])
        });
      } else {
        await _firestore.collection('posts').doc(referencePostID).update({
          'comments': FieldValue.arrayUnion([cid])
        });
        // Sends Notification that a user has commented on their post
        await ActivityServices().commentNotification(
            FirebaseAuth.instance.currentUser!.uid,
            cid,
            referenceOwner,
            referencePostID,
            'commented_post',
            time);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadMessageComment(
    String referenceOwner,
    String referencePostID,
    String type,
    String statement,
  ) async {
    try {
      int time = DateTime.now().millisecondsSinceEpoch;
      //String pid = '${time}_${const Uuid().v1()}';
      String cid = 'c-${const Uuid().v1()}';

      // Chacks if uploaded image is file or bytes format
      CommentModel comment = CommentModel(
          contentOwnerID: FirebaseAuth.instance.currentUser!.uid,
          contentID: cid,
          referenceOwnerID: referenceOwner,
          referenceID: referencePostID,
          type: 'comment',
          statement: statement,
          timestamp: time,
          commentUrl: "",
          hasMedia: false,
          likes: [],
          comments: []);
      // Sets to post into the Users's posts collection
      await _firestore.collection('comments').doc(cid).set(comment.toJson());
      // Adds comment id into target comment's list
      if (type == 'comment') {
        await _firestore.collection('comments').doc(referencePostID).update({
          'comments': FieldValue.arrayUnion([cid])
        });
      } else {
        await _firestore.collection('posts').doc(referencePostID).update({
          'comments': FieldValue.arrayUnion([cid])
        });
        // Sends Notification that a user has commented on their post
        await ActivityServices().commentNotification(
          FirebaseAuth.instance.currentUser!.uid,
          cid,
          referenceOwner,
          referencePostID,
          'commented_post',
          time,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteComment() async {}
  Future<void> likeComment() async {}
  Future<void> bookmarkComment() async {}
  ////////////////////////////////////////////////////////// Server Services ///
  Future<void> uploadServerPost() async {}
  Future<void> deleteServerPost() async {}
  Future<void> likeServerPost() async {}
  Future<void> bookmarkServer() async {}

  //////////////////////////////////////////////////////////////////////////////
  // Like Post
  Future<void> likePost(
      String sender, String receiver, String pid, String type) async {
    bool isLiked = await postIsLiked(sender, receiver, pid, type);
    try {
      if (type == 'comment') {
        if (isLiked) {
          await _firestore.collection('comments').doc(pid).update({
            'likes': FieldValue.arrayRemove([sender])
          });
        } else {
          await _firestore.collection('comments').doc(pid).update({
            'likes': FieldValue.arrayUnion([sender])
          });
          // Send Notification of who like the user post
          await ActivityServices()
              .likeNotification(sender, receiver, pid, 'liked_post');
        }
      } else {
        if (isLiked) {
          await _firestore.collection('posts').doc(pid).update({
            'likes': FieldValue.arrayRemove([sender])
          });
        } else {
          await _firestore.collection('posts').doc(pid).update({
            'likes': FieldValue.arrayUnion([sender])
          });
          // Send Notification of who like the user post
          await ActivityServices()
              .likeNotification(sender, receiver, pid, 'liked_post');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Checks if Post is Liked
  Future<bool> postIsLiked(
      String sender, String receiver, String pid, String type) async {
    try {
      if (type == 'comment') {
        DocumentSnapshot snap =
            await _firestore.collection('comments').doc(pid).get();
        List likes = (snap.data()! as dynamic)['likes'];
        if (likes.contains(sender)) {
          return true;
        }
      } else {
        DocumentSnapshot snap =
            await _firestore.collection('posts').doc(pid).get();
        List likes = (snap.data()! as dynamic)['likes'];
        if (likes.contains(sender)) {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // User Follow/Unfolloe
  Future<void> followUser(String user, String currentUser) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(currentUser)) {
        // UNFOLLOWS currentUser
        await _firestore.collection('users').doc(currentUser).update({
          'followers': FieldValue.arrayRemove([user])
        });
        await _firestore.collection('users').doc(user).update({
          'following': FieldValue.arrayRemove([currentUser])
        });
      } else {
        // FOLLOWS currentUser
        await _firestore.collection('users').doc(currentUser).update({
          'followers': FieldValue.arrayUnion([user])
        });
        await _firestore.collection('users').doc(user).update({
          'following': FieldValue.arrayUnion([currentUser])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
