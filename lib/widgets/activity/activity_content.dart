import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/view_content.dart';

class BuildActivityContent extends StatefulWidget {
  final Map<String, dynamic> content;
  const BuildActivityContent({super.key, required this.content});

  @override
  State<BuildActivityContent> createState() => _BuildActivityContentState();
}

class _BuildActivityContentState extends State<BuildActivityContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () {
        //feedProvider.refreshPost(widget.content['id_content']);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // BODY
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile Image
                    buildUserProfileImage(
                        context, widget.content['id_content_owner']),
                    Expanded(
                      child: Column(
                        children: [
                          // User Identification
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: buildReferenceUserInfo(
                                    context, widget.content),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Post
                Row(
                  children: [
                    widget.content['statement'] == ''
                        ? Container()
                        : Flexible(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: buildDetectableStatement(
                                          context,
                                          widget.content['statement'],
                                          TextOverflow.visible)),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                // Image or Media
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            // Checks if Post has media
                            widget.content['hasMedia'] == true
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ViewContent(
                                                snap: widget.content);
                                          });
                                    },
                                    child: AspectRatio(
                                      aspectRatio: kIsWeb ? 2 : 1.5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        widget.content[
                                                            'media_url']),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6))),
                                      ),
                                    ),
                                    // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                    onDoubleTap: () {},
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
