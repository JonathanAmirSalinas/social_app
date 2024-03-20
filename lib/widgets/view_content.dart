import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/content_services.dart';

// TO-DO ///////////////////////////////////////////////////////////////////////
// 1: Make sure bottom icons format is fixed (spacing)

class ViewContent extends StatefulWidget {
  final Map<String, dynamic> snap;
  const ViewContent({super.key, required this.snap});

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  late bool focus;
  @override
  void initState() {
    focus = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          setState(() {
            focus = !focus;
          });
        },
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: mainBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: focus
                          ? Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.close_rounded))
                              ],
                            )
                          : Container(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.snap['media_url']),
                            fit: BoxFit.cover,
                          )),
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: focus
                ? SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ////////////// LIKE BUTTON /////////////
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await ContentServices().likePost(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.snap['id_content_owner'],
                                    widget.snap['id_content'],
                                    widget.snap['type']);
                              },
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              constraints: const BoxConstraints(),
                              splashRadius: 16,
                              icon: widget.snap['likes'].toString().contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 16,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline_rounded,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
                            ),
                            Text(
                              widget.snap['likes'].length.toString(),
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),
                        /////////////////// COMMENT BUTTON /////////////////
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    '/commentpost',
                                    arguments: widget.snap);
                              },
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.insert_comment_outlined,
                                size: 16,
                                color: Colors.white54,
                              ),
                              splashRadius: 16,
                            ),
                            Text(
                              widget.snap['comments'].length.toString(),
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),
                        IconButton(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.reply_rounded,
                            color: Colors.white54,
                          ),
                          splashRadius: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),

                        IconButton(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.share,
                            size: 16,
                            color: Colors.white54,
                          ),
                          splashRadius: 16,
                        ),
                      ],
                    ),
                  )
                : null,
          );
        }),
      ),
    );
  }
}
