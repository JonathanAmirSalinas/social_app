import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/content/create_post_page.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/view_content.dart';

class BuildPostContent extends StatefulWidget {
  final Map<String, dynamic> content;
  const BuildPostContent({super.key, required this.content});

  @override
  State<BuildPostContent> createState() => _BuildPostContentState();
}

class _BuildPostContentState extends State<BuildPostContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        //feedProvider.refreshPost(widget.content['id_content']);
      },
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
                            widget.content['statement'] == ''
                                ? Container()
                                : Flexible(
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                                                            Radius.circular(
                                                                6))),
                                              ),
                                            ),
                                            // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                            onDoubleTap: () {},
                                          )
                                        : Container(),
                                    // Icons
                                    buildInteractiveIconSection(
                                        context, widget.content),
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

// Creates a Dialog Used to create a Post
buildCreatePostDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const CreatePostPage();
    },
  );
}
