import 'package:cloud_firestore/cloud_firestore.dart';

class ServerModel {
  final String creator;
  final String serverID;
  final String serverLink;
  final String serverName;
  final String description;
  final int timestamp;
  final String serverBannerImage;
  final String serverProfileImage;
  final String privacy;
  final List tags;
  final List<String> channels;
  final List members;
  final List bannedMembers;

  const ServerModel({
    required this.creator,
    required this.serverID,
    required this.serverLink,
    required this.serverName,
    required this.description,
    required this.timestamp,
    required this.serverBannerImage,
    required this.serverProfileImage,
    required this.privacy,
    required this.tags,
    required this.channels,
    required this.members,
    required this.bannedMembers,
  });

  Map<String, dynamic> toJson() => {
        'id_creator': creator,
        'id_server': serverID,
        'server_link': serverLink,
        'server_name': serverName,
        'description': description,
        'created_timestamp': timestamp,
        'banner_image': serverBannerImage,
        'server_image': serverProfileImage,
        'privacy': privacy,
        'tags': tags,
        'channels': channels,
        'members': members,
        'banned_members': bannedMembers,
      };

  static ServerModel dataFromDoc(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerModel(
      creator: snapshot['id_creator'],
      serverID: snapshot['id_server'],
      serverLink: snapshot['server_link'],
      serverName: snapshot['server_name'],
      description: snapshot['description'],
      timestamp: snapshot['created_timestamp'],
      serverBannerImage: snapshot['banner_image'],
      serverProfileImage: snapshot['server_image'],
      privacy: snapshot['privacy'],
      tags: snapshot['tags'],
      channels: snapshot['channels'],
      members: snapshot['members'],
      bannedMembers: snapshot['banned_members'],
    );
  }
}

//////////////////////////////////////////////////////// Server Member Model ///
class ServerMemberModel {
  final String memberId;
  final String name;
  final String color;
  final String role;
  final int timeJoined;

  const ServerMemberModel({
    required this.memberId,
    required this.name,
    required this.color,
    required this.role,
    required this.timeJoined,
  });

  Map<String, dynamic> toJson() => {
        'id_member': memberId,
        'member_name': name,
        'member_color': color,
        'role': role,
        'timeJoined': timeJoined,
      };

  static ServerMemberModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerMemberModel(
      memberId: snapshot['id_member'],
      name: snapshot['member_name'],
      color: snapshot['member_color'],
      role: snapshot['role'],
      timeJoined: snapshot['timeJoined'],
    );
  }
}

////////////////////////////////////////////////////// Server Channel Model ///
class ServerChannelModel {
  final String channelId;
  final String name;
  final bool empty;
  final int position;

  const ServerChannelModel({
    required this.channelId,
    required this.name,
    required this.empty,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'id_channel': channelId,
        'channel_name': name,
        'empty': empty,
        'position': position,
      };

  static ServerChannelModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerChannelModel(
      channelId: snapshot['id_channel'],
      name: snapshot['channel_name'],
      empty: snapshot['empty'],
      position: snapshot['position'],
    );
  }
}

////////////////////////////////////////////////////////// Server Role Model ///
class ServerRolesModel {
  final bool deleteServer;

  final String roleName;
  final bool manageServer;
  final bool manageMessages;
  final bool manageMembers;
  final bool manageRoles;
  final List members;
  final int rank; // priority members 0 - 5

  const ServerRolesModel({
    required this.deleteServer,
    required this.roleName,
    required this.manageMembers,
    required this.manageMessages,
    required this.manageRoles,
    required this.manageServer,
    required this.members,
    required this.rank,
  });

  Map<String, dynamic> toJson() => {
        'delete_server': deleteServer,
        'role_name': roleName,
        'manage_members': manageMembers,
        'manage_messages': manageMessages,
        'manage_roles': manageRoles,
        'manage_server': manageServer,
        'members': members,
        'rank': rank,
      };

  static ServerRolesModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerRolesModel(
      deleteServer: snapshot['delete_server'],
      roleName: snapshot['role_name'],
      manageMembers: snapshot['manage_members'],
      manageMessages: snapshot['manage_messages'],
      manageRoles: snapshot['manage_roles'],
      manageServer: snapshot['manage_server'],
      members: snapshot['members'],
      rank: snapshot['rank'],
    );
  }
}
