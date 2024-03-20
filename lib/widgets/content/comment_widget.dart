import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/view_content.dart';

class BuildCommentContent extends StatelessWidget {
  final Map<String, dynamic> content;
  const BuildCommentContent({super.key, required this.content});
  @override
  Widget build(BuildContext context) {
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () {
        //feedProvider.refreshPost(widget.content['id_content']);
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 3, color: mainNavRailBackgroundColor))),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.fromLTRB(4, 4, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              // BODY
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  buildUserProfileImage(context, content['id_content_owner']),
                  Expanded(
                    child: Column(
                      children: [
                        // User Identification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildUserInfo(context, content, true),
                            )
                          ],
                        ),
                        // Post
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: buildDetectableStatement(
                                            context,
                                            content['statement'],
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    // Checks if Post has media
                                    content['hasMedia'] == true
                                        ? GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ViewContent(
                                                        snap: content);
                                                  });
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .45,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              content[
                                                                  'media_url']),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16))),
                                            ),
                                            // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                            onDoubleTap: () {},
                                          )
                                        : Container(),
                                    // Icons
                                    buildInteractiveIconSection(
                                        context, content),
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
            ),
          ],
        ),
      ),
    );
  }
}
