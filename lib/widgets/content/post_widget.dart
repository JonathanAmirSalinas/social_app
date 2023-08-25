import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
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
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return GestureDetector(
      onTap: () {
        //feedProvider.refreshPost(widget.content['id_content']);
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 3, color: navBarColor))),
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
                  buildUserProfileImage(context, widget.content),
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
                                            child: Text(
                                              widget.content['statement'],
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .fontSize),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
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
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .5,
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
