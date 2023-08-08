import 'package:cloud_firestore/cloud_firestore.dart';

class ServerModel {
  final String creator;
  final String serverID;
  final String serverLink;
  final String serverName;
  final String description;
  final Timestamp timestamp;
  final String serverBannerUrl;
  final String serverProfileUrl;
  final String privacy;
  final List tags;
  final List members;
  final List bannedMembers;

  const ServerModel({
    required this.creator,
    required this.serverID,
    required this.serverLink,
    required this.serverName,
    required this.description,
    required this.timestamp,
    required this.serverBannerUrl,
    required this.serverProfileUrl,
    required this.privacy,
    required this.tags,
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
        'banner_image': serverBannerUrl,
        'server_image': serverProfileUrl,
        'privacy': privacy,
        'tags': tags,
        'members': members,
        'banned_members': bannedMembers,
      };

  static ServerModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerModel(
      creator: snapshot['id_creator'],
      serverID: snapshot['id_server'],
      serverLink: snapshot['server_link'],
      serverName: snapshot['server_name'],
      description: snapshot['description'],
      timestamp: snapshot['created_timestamp'],
      serverBannerUrl: snapshot['banner_image'],
      serverProfileUrl: snapshot['server_image'],
      privacy: snapshot['privacy'],
      tags: snapshot['tags'],
      members: snapshot['members'],
      bannedMembers: snapshot['banned_members'],
    );
  }
}

//////////////////////////////////////////////////////// Server Member Model ///
class ServerMemberModel {
  final String memberId;
  final String name;
  final String memberImage;
  final String color;
  final String role;
  final Timestamp timeJoined;

  const ServerMemberModel({
    required this.memberId,
    required this.name,
    required this.memberImage,
    required this.color,
    required this.role,
    required this.timeJoined,
  });

  Map<String, dynamic> toJson() => {
        'id_member': memberId,
        'member_name': name,
        'member_image': memberImage,
        'member_color': color,
        'role': role,
        'timeJoined': timeJoined,
      };

  static ServerMemberModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerMemberModel(
      memberId: snapshot['id_member'],
      name: snapshot['member_name'],
      memberImage: snapshot['member_image'],
      color: snapshot['member_color'],
      role: snapshot['role'],
      timeJoined: snapshot['timeJoined'],
    );
  }
}

////////////////////////////////////////////////////// Server Chatroom Model ///
class ServerChatroomModel {
  final String chatroomId;
  final String name;
  final bool empty;
  final int position;

  const ServerChatroomModel({
    required this.chatroomId,
    required this.name,
    required this.empty,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'id_chatroom': chatroomId,
        'chatroom_name': name,
        'empty': empty,
        'position': position,
      };

  static ServerChatroomModel dataFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ServerChatroomModel(
      chatroomId: snapshot['id_chatroom'],
      name: snapshot['chatroom_name'],
      empty: snapshot['empty'],
      position: snapshot['position'],
    );
  }
}

////////////////////////////////////////////////////////// Server Role Model ///
class ServerRolesModel {
  final bool deleteServer;
  final String roleID;
  final String roleName;
  final bool manageServer;
  final bool manageMessages;
  final bool manageMembers;
  final bool manageRoles;
  final List members;
  final int rank; // priority members 0 - 5

  const ServerRolesModel({
    required this.deleteServer,
    required this.roleID,
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
        'id_role': roleID,
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
      roleID: snapshot['id_role'],
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
