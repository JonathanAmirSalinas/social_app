import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/pages/sub-navigation/content/create_repost_page.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/view_content.dart';

class BuildPostReferenceContent extends StatefulWidget {
  final String reference;
  const BuildPostReferenceContent({super.key, required this.reference});

  @override
  State<BuildPostReferenceContent> createState() =>
      _BuildPostReferenceContentState();
}

class _BuildPostReferenceContentState extends State<BuildPostReferenceContent>
    with AutomaticKeepAliveClientMixin<BuildPostReferenceContent> {
  @override
  bool get wantKeepAlive => true;
  Map<String, dynamic> reference = {};
  bool loadingPost = false;
  // Repost Dialog
  buildRePostDialog(Map<String, dynamic> content) {
    return showDialog(
      context: context,
      builder: (context) {
        return CreateRePostPage(content: content);
      },
    );
  }

  getReference() async {
    setState(() {
      loadingPost = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.reference)
          .get()
          .then((value) {
        setState(() {
          reference = value.data()!;
        });
      });
    } catch (e) {
      print('Couldnt Load Post Reference');
    }
    setState(() {
      loadingPost = false;
    });
  }

  @override
  void initState() {
    getReference();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loadingPost
        ? const CircularProgressIndicator()
        : LayoutBuilder(builder: ((context, constraints) {
            return constraints.maxWidth > mobileScreenSize
                ? buildWeb()
                : buildMobile();
          }));
  }

  buildWeb() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          // BODY
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              buildUserProfileImage(context, reference['id_content_owner']),
              Expanded(
                child: Column(
                  children: [
                    // User Identification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildReferenceUserInfo(context, reference),
                        ),
                      ],
                    ),
                    // Post
                    Column(
                      children: [
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
                                            reference['statement'],
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
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
                                child: Column(
                                  children: [
                                    Container(
                                      child:
                                          // Checks if Post has media
                                          reference['hasMedia'] == true
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ViewContent(
                                                              snap: reference);
                                                        });
                                                  },
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .35,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                reference[
                                                                    'media_url']),
                                                            fit: BoxFit.fill),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                  ),
                                                )
                                              : Container(),
                                    ),
                                    buildInteractiveIconSection(
                                        context, reference)
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  buildMobile() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          // BODY
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              buildUserProfileImage(context, reference['id_content_owner']),
              Expanded(
                child: Column(
                  children: [
                    // User Identification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildReferenceUserInfo(context, reference),
                        ),
                      ],
                    ),
                    // Post
                    Column(
                      children: [
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
                                            reference['statement'],
                                            TextOverflow.ellipsis)),
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
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
                                child: Column(
                                  children: [
                                    Container(
                                      child:
                                          // Checks if Post has media
                                          reference['hasMedia'] == true
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ViewContent(
                                                              snap: reference);
                                                        });
                                                  },
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .35,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                reference[
                                                                    'media_url']),
                                                            fit: BoxFit.fill),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    6))),
                                                  ),
                                                )
                                              : Container(),
                                    ),
                                    buildInteractiveIconSection(
                                        context, reference)
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
