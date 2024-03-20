import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/models/chat/message_model.dart';
import 'package:social_app/models/server_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/activity_services.dart';
import 'package:social_app/services/auth_services.dart';
import 'package:social_app/services/storage_services.dart';
import 'package:uuid/uuid.dart';

class ServerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///////////////////////////////////////////////////// Main Server Services ///
  Future<List<Map<String, dynamic>>> getServerList() async {
    List<Map<String, dynamic>> userServers = [];
    try {
      await _firestore
          .collection('servers')
          .where('members',
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        for (final doc in value.docs) {
          userServers.add(doc.data());
        }
      });
      return userServers;
    } catch (e) {
      return userServers;
    }
  }

  Future<List<String>> getChannelList(String server) async {
    List<String> serverChannels = [];
    try {
      await _firestore.collection('servers').doc(server).get().then((value) {
        for (final channel in value.data()!['channels']) {
          serverChannels.add(channel);
        }
      });
      return serverChannels;
    } catch (e) {
      return serverChannels;
    }
  }

  // Create Server
  Future<void> createServer(
      String owner,
      String serverName,
      String serverLink,
      File? serverImage,
      Uint8List? serverImageBytes,
      File? serverBannerImage,
      Uint8List? serverBannerImageBytes,
      String privacy,
      String description,
      List tags) async {
    try {
      String serverImageUrl;
      String serverBannerUrl;
      int time = DateTime.now().millisecondsSinceEpoch;
      String sid = 's-${const Uuid().v1()}';
      // Server Image
      if (serverImage == null) {
        serverImageUrl = await StorageServices()
            .uploadImageBytesToStorage('server_image', serverImageBytes!, sid);
      } else {
        serverImageUrl = await StorageServices()
            .uploadImageFileToStorage('server_image', serverImage, sid);
      }
      // Server Banner
      if (serverBannerImage == null) {
        serverBannerUrl = await StorageServices().uploadImageBytesToStorage(
            'server_banner', serverBannerImageBytes!, sid);
      } else {
        serverBannerUrl = await StorageServices()
            .uploadImageFileToStorage('server_banner', serverBannerImage, sid);
      }

      /////////////////// Server Model /////////////////
      ServerModel server = ServerModel(
          creator: owner,
          serverID: sid,
          serverLink: serverLink,
          serverName: serverName,
          description: description,
          timestamp: time,
          serverBannerImage: serverBannerUrl,
          serverProfileImage: serverImageUrl,
          privacy: privacy,
          tags: tags,
          channels: [],
          members: [owner],
          bannedMembers: []);

      /// Create Server
      await _firestore.collection('servers').doc(sid).set(server.toJson());

      ////////////////// Add Members Server Collection //////////////////////////
      UserModel user = await AuthServices().getUser();
      ServerMemberModel member = ServerMemberModel(
          memberId: owner,
          name: user.name,
          color: "FF00000FF",
          role: 'Owner',
          timeJoined: time);

      // Creates members collection
      await _firestore
          .collection('servers')
          .doc(sid)
          .collection('members')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(member.toJson());

      //////////////////// Add Roles Collection /////////////////////////
      ServerRolesModel serverRoles = ServerRolesModel(
          deleteServer: true,
          roleName: 'Owner',
          manageMembers: true,
          manageMessages: true,
          manageRoles: true,
          manageServer: true,
          members: [owner],
          rank: 10);

      // Creates Role collection
      await _firestore
          .collection('servers')
          .doc(sid)
          .collection('roles')
          .doc('Owner')
          .set(serverRoles.toJson());

      //////////////////////// Default Server Rooms ////////////////////////////

      // Sets Default Welcome
      ServerChannelModel welcome = const ServerChannelModel(
          channelId: 'welcome', name: "welcome", empty: true, position: 0);
      await _firestore
          .collection('server-channels')
          .doc('$sid-welcome')
          .set(welcome.toJson());
      await _firestore.collection('servers').doc(sid).update({
        'channels': FieldValue.arrayUnion(['$sid-welcome'])
      });

      // Sets Default Rules
      ServerChannelModel rules = const ServerChannelModel(
          channelId: 'rules', name: "rules", empty: true, position: 1);
      await _firestore
          .collection('server-channels')
          .doc('$sid-rules')
          .set(rules.toJson());
      await _firestore.collection('servers').doc(sid).update({
        'channels': FieldValue.arrayUnion(['$sid-rules'])
      });

      // Sets Default Announcements
      ServerChannelModel announcements = const ServerChannelModel(
          channelId: 'announcements',
          name: "announcements",
          empty: true,
          position: 2);
      await _firestore
          .collection('server-channels')
          .doc('$sid-announcments')
          .set(announcements.toJson());
      await _firestore.collection('servers').doc(sid).update({
        'channels': FieldValue.arrayUnion(['$sid-announcments'])
      });

      // Makes a Default Main
      ServerChannelModel channelModel = const ServerChannelModel(
          channelId: 'main', name: "main", empty: true, position: 3);
      await _firestore
          .collection('server-channels')
          .doc('$sid-main')
          .set(channelModel.toJson());

      await _firestore.collection('servers').doc(sid).update({
        'channels': FieldValue.arrayUnion(['$sid-main'])
      });

      // Add Server to User List
      await _firestore.collection('users').doc(owner).update({
        'servers': FieldValue.arrayUnion([sid])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteServer() async {}
  ////////////////////////////////////////////////////////// Server Services ///
  Future<void> joinServer() async {}
  Future<void> leaveServer() async {}
  Future<void> shareServer() async {}
  Future<void> reportServer() async {}
  Future<void> pinServer() async {}
  Future<void> updateServerName() async {}
  Future<void> updateServerDescription() async {}
  Future<void> updateServerImage() async {}
  Future<void> updateServerBanner() async {}
  Future<void> updateServerMemberRole() async {}
  //////////////////////////////////////////////////// Roles Server Services ///
  Future<void> createServerMember(String uid, String name, String role) async {}
  Future<void> kickServerMember() async {}
  Future<void> muteServerMember() async {}
  Future<void> banServerMember() async {}
  Future<void> unBanServerMember() async {}
  ///////////////////////////////////////////////////// User Server Services ///
  Future<void> updateUserServerName() async {}
  Future<void> updateUserServerDescription() async {}
  Future<void> updateUserServerImage() async {}
  Future<void> updateUserServerColor() async {}
  ///////////////////////////////////////////////// Server channel Services ///
  Future<void> createServerchannel() async {}
  Future<void> deleteServerchannel() async {}
  Future<void> updateServerchannelName() async {}
  //////////////////////////////////////////////////// Server Chat Messaging ///

  // First Instance of the Creation of the Message Collection
  Future<void> createChannelMessage(
    String sender,
    String server,
    String channel,
    String message,
    List<String> mentions,
  ) async {
    try {
      // Timestamp
      int time = DateTime.now().millisecondsSinceEpoch;

      // Message ID
      String mid = 'm-${const Uuid().v1()}';

      // Mentions Notifications
      await checkMentions(mentions, mid, server, channel, time);

      MessageModel messageModel = MessageModel(
          from: sender,
          messageID: mid,
          message: message,
          media: "",
          seen: false,
          hasMedia: false,
          timestamp: time,
          type: 'server_message',
          mentions: mentions);

      // Creates MEssage Collection
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .collection('messages')
          .doc(mid)
          .set(messageModel.toJson());

      // Changes Channel 'empty' value to false
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .update({'empty': false});
    } catch (e) {}
  }

  // First Instance of the Creation of the Message Collection w/ Media
  Future<void> createChannelMediaMessage(
    String sender,
    String server,
    String channel,
    String message,
    File? file,
    Uint8List? bytes,
    List<String> mentions,
  ) async {
    try {
      String imageUrl;
      int time = DateTime.now().millisecondsSinceEpoch;

      //String pid = '${time}_${const Uuid().v1()}';
      String mid = 'm-${const Uuid().v1()}';

      // Chacks if uploaded image is file or bytes format
      if (file == null) {
        imageUrl = await StorageServices()
            .uploadImageBytesToStorage('server_message_media', bytes!, mid);
      } else {
        imageUrl = await StorageServices()
            .uploadImageFileToStorage('server_message_media', file, mid);
      }

      //Mentions Notifications
      await checkMentions(mentions, mid, server, channel, time);

      MessageModel messageModel = MessageModel(
          from: sender,
          messageID: mid,
          message: message,
          media: imageUrl,
          seen: false,
          hasMedia: true,
          timestamp: time,
          type: 'server_message',
          mentions: mentions);

      // Creates MEssage Collection
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .collection('messages')
          .doc(mid)
          .set(messageModel.toJson());

      // Changes Channel 'empty' value to false
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .collection('channels')
          .doc(channel)
          .update({'empty': false});
    } catch (e) {}
  }

  // Send Server Message
  Future<void> sendChannelMessage(
    String sender,
    String server,
    String channel,
    String message,
    List<String> mentions,
  ) async {
    try {
      // Timestamp
      int time = DateTime.now().millisecondsSinceEpoch;

      // Message ID
      String mid = 'm-${const Uuid().v1()}';

      // Server Mentions Notifications
      await checkMentions(mentions, mid, server, channel, time);

      // Message Model
      MessageModel messageModel = MessageModel(
          from: sender,
          messageID: mid,
          message: message,
          media: '',
          seen: false,
          hasMedia: false,
          timestamp: time,
          type: 'server_message',
          mentions: mentions);
      // Message Collections
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .collection('messages')
          .doc(mid)
          .set(messageModel.toJson());
    } catch (e) {}
  }

  // Send Server Message w/ Media
  Future<void> sendChannelMediaMessage(
    String sender,
    String server,
    String channel,
    String message,
    File? file,
    Uint8List? bytes,
    List<String> mentions,
  ) async {
    try {
      String imageUrl;

      // Timestamp
      int time = DateTime.now().millisecondsSinceEpoch;

      // Message ID
      String mid = 'm-${const Uuid().v1()}';

      // Chacks if uploaded image is file or bytes format
      if (file == null) {
        imageUrl = await StorageServices()
            .uploadImageBytesToStorage('server_message_media', bytes!, mid);
      } else {
        imageUrl = await StorageServices()
            .uploadImageFileToStorage('server_message_media', file, mid);
      }

      // Server Mentions Notifications
      await checkMentions(mentions, mid, server, channel, time);

      // Message Model
      MessageModel messageModel = MessageModel(
          from: sender,
          messageID: mid,
          message: message,
          media: imageUrl,
          seen: false,
          hasMedia: true,
          timestamp: time,
          type: 'server_message',
          mentions: mentions);
      // Message Collections
      await _firestore
          .collection('server-channels')
          .doc(channel)
          .collection('messages')
          .doc(mid)
          .set(messageModel.toJson());
    } catch (e) {}
  }

  // Sends mention notifications from server messages
  Future<void> checkMentions(List<String> mentions, String messageID,
      String server, String channel, int time) async {
    for (var mention in mentions) {
      // Gets Mentioned User ID
      var mentionedUser = await AuthServices().getMentionedUser(mention);

      // Checks of the User Mentions themseleves
      if (mentionedUser['uid'] != FirebaseAuth.instance.currentUser!.uid) {
        await ActivityServices().serverMentionNotification(
            FirebaseAuth.instance.currentUser!.uid,
            mentionedUser['uid'],
            messageID,
            server,
            channel,
            'server_mention',
            time);
      }
    }
  }
}
