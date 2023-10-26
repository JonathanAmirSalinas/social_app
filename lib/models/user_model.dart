import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String username;
  final String profileUrl;
  final String bannerUrl;
  final String bio;
  final String status;
  final String renown;
  final List recentlySearched;
  final Timestamp timeJoined;
  final List friends;
  final List following;
  final List followers;
  final List posts;
  final List servers;
  final bool access;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
    required this.profileUrl,
    required this.bannerUrl,
    required this.bio,
    required this.status,
    required this.renown,
    required this.recentlySearched,
    required this.timeJoined,
    required this.friends,
    required this.following,
    required this.followers,
    required this.posts,
    required this.servers,
    required this.access,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'username': username,
        'profile_image': profileUrl,
        'banner_image': bannerUrl,
        'bio': bio,
        'status': status,
        'renown': renown,
        'recentlySearched': recentlySearched,
        'timeJoined': timeJoined,
        'friends': friends,
        'following': following,
        'followers': followers,
        'posts': posts,
        'servers': servers,
        'access': access,
      };

  static UserModel dataFromDoc(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      name: snapshot['name'],
      username: snapshot['username'],
      profileUrl: snapshot['profile_image'],
      bannerUrl: snapshot['banner_image'],
      bio: snapshot['bio'],
      status: snapshot['status'],
      renown: snapshot['renown'],
      recentlySearched: snapshot['recentlySearched'],
      timeJoined: snapshot['timeJoined'],
      friends: snapshot['friends'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      posts: snapshot['posts'],
      servers: snapshot['servers'],
      access: snapshot['access'],
    );
  }
}
