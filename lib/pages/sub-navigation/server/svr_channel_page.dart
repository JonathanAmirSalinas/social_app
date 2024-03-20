import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/server/server_chatroom_widgets.dart';
import 'package:social_app/widgets/server/server_message.dart';
import 'package:social_app/widgets/server/server_text_bar_widget.dart';

@RoutePage(name: 'server_channel')
class ServerChannel extends StatefulWidget {
  final String channel;
  final String sid;
  const ServerChannel(
      {super.key,
      @PathParam('channel') required this.channel,
      required this.sid});

  @override
  State<ServerChannel> createState() => _ServerChannelState();
}

class _ServerChannelState extends State<ServerChannel> {
  ScrollController chatScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: buildChannelChat(),
    );
  }

  // Build Channel Chat Body
  buildChannelChat() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SingleChildScrollView(
            reverse: true,
            controller: chatScrollController,
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: mainServerRailBackgroundColor))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize),
                      ),
                      buildChannelAppbarTitle(context, widget.channel),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('server-channels')
                      .doc(widget.channel)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var chat = snapshot.data!.docs[index].data();
                              return ChannelMessage(
                                message: chat,
                                sid: widget.sid,
                              );
                            });
                      case ConnectionState.done:
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var chat = snapshot.data!.docs[index].data();
                              return ChannelMessage(
                                message: chat,
                                sid: widget.sid,
                              );
                            });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        ServerTextBar(sid: widget.sid, channel: widget.channel)
      ],
    );
  }

  //Builds Chat Losding UI
  buildLoadingChat() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            reverse: true,
            controller: chatScrollController,
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: mainServerRailBackgroundColor))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize),
                      ),
                      Text(
                        ' #${widget.channel}',
                        style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize),
                      ),
                    ],
                  ),
                ),
                /*ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Builder(builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: shimmerBase,
                                    highlightColor: shimmerHighlight,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 150,
                                          margin: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 16),
                                          decoration: const BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                        ),
                                        Shimmer.fromColors(
                                          baseColor: shimmerBase,
                                          highlightColor: shimmerHighlight,
                                          child: Container(
                                            height: 15,
                                            width: double.infinity,
                                            margin: const EdgeInsets.fromLTRB(
                                                12, 2, 12, 4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                          ),
                                        ),
                                        Shimmer.fromColors(
                                          baseColor: shimmerBase,
                                          highlightColor: shimmerHighlight,
                                          child: Container(
                                            height: 15,
                                            width: (math.Random().nextInt(150) +
                                                    150)
                                                .toDouble(),
                                            margin: const EdgeInsets.fromLTRB(
                                                12, 2, 12, 4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                          ),
                                        ),
                                        Shimmer.fromColors(
                                          baseColor: shimmerBase,
                                          highlightColor: shimmerHighlight,
                                          child: Container(
                                            height: 15,
                                            width:
                                                (math.Random().nextInt(50) + 50)
                                                    .toDouble(),
                                            margin: const EdgeInsets.fromLTRB(
                                                12, 2, 12, 4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                    }),*/
              ],
            ),
          ),
        ),
        ServerTextBar(sid: widget.sid, channel: widget.channel)
      ],
    );
  }
}
