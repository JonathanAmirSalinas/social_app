class ServerServices {
  ///////////////////////////////////////////////////// Main Server Services ///
  Future<void> createServer() async {}
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
  Future<void> kickServerMember() async {}
  Future<void> muteServerMember() async {}
  Future<void> banServerMember() async {}
  Future<void> unBanServerMember() async {}
  ///////////////////////////////////////////////////// User Server Services ///
  Future<void> updateUserServerName() async {}
  Future<void> updateUserServerDescription() async {}
  Future<void> updateUserServerImage() async {}
  Future<void> updateUserServerColor() async {}
  ///////////////////////////////////////////////// Server Chatroom Services ///
  Future<void> createServerChatroom() async {}
  Future<void> deleteServerChatroom() async {}
  Future<void> updateServerChatroomName() async {}
}
