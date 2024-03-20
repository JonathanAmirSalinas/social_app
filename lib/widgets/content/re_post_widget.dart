import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/content/post_reference_widget.dart';
import 'package:social_app/widgets/view_content.dart';

// TO-DO ////////////////////////////////////////////////////////////// TO-DO //
// 1: Make sure user cant spam post button while post is loading
// 2: Make sure user cant post with empty values, message or image needed
// 3: Make sure Mobile UI is similar to Web UI
// 4: Make sure all input widgets are disabled while Post is loading
// 5: Make sure when feed is refreshed current user post is on top (Important)
// 6: Add Filter/PageView option to scroll between create (post/story/server)

class BuildRePostContent extends StatefulWidget {
  final Map<String, dynamic> content;
  const BuildRePostContent({super.key, required this.content});

  @override
  State<BuildRePostContent> createState() => _BuildRePostContentState();
}

class _BuildRePostContentState extends State<BuildRePostContent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: mainServerRailBackgroundColor,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(4, 1, 4, 1),
              padding: const EdgeInsets.fromLTRB(4, 4, 24, 0),
              decoration: const BoxDecoration(
                color: mainBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              // BODY
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              child:
                                  buildUserInfo(context, widget.content, true),
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
                                            widget.content['statement'],
                                            TextOverflow.visible)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Image or Media
                        Row(children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
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
                                                          Radius.circular(16))),
                                            ),
                                          ),
                                          // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                          onDoubleTap: () {},
                                        )
                                      : Container(),
                                  // Reference ////////////////////////////////////
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        color: mainNavRailBackgroundColor,
                                        shape: const ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: BuildPostReferenceContent(
                                            reference: widget
                                                .content['id_reference'])),
                                  ),

                                  // Icons
                                  buildInteractiveIconSection(
                                      context, widget.content),
                                ],
                              ),
                            ),
                          ),
                        ]),
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

  buildReferenceDivider() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white54,
            ),
          ),
          const Icon(
            Icons.question_answer_rounded,
            size: 18,
            color: Colors.white54,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text("Referencing post")),
          Expanded(
            flex: 8,
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  buildReferenceContent() {
    return Container();
  }
}
