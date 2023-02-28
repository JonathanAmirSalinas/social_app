import 'package:flutter/material.dart';

class BuildPostCard extends StatefulWidget {
  const BuildPostCard({super.key});

  @override
  State<BuildPostCard> createState() => _BuildPostCardState();
}

class _BuildPostCardState extends State<BuildPostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(8),
        // BODY
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            buildProfileImage(context),
            Expanded(
              child: Column(
                children: [
                  // User Identification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUserTile(context),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => Dialog(
                                    child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: ["Delete", "Report"]
                                            .map((e) => InkWell(
                                                  onTap: () {},
                                                  child: Center(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                        horizontal: 16,
                                                      ),
                                                      child: Text(e),
                                                    ),
                                                  ),
                                                ))
                                            .toList()))));
                          },
                          icon: const Icon(Icons.drag_handle_rounded)),
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Caption goes here so that you can see the response it makes while adjusting the screen resolution ',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
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

                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: MediaQuery.of(context).size.width * .4,
                            width: MediaQuery.of(context).size.width * .8,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                          onDoubleTap: () {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 16,
                                    color: Colors.white54,
                                  ),
                                  splashRadius: 16,
                                ),
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .02,
                                ),
                                IconButton(
                                  onPressed: () {},
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
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .02,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 1),
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
                            IconButton(
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.bookmark_border_outlined,
                                size: 16,
                                color: Colors.white54,
                              ),
                              splashRadius: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Icons

                  //////////////////// Comments //////////////////////////////////
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    child: Row(
                      children: const [
                        Text(
                          "Comments \u2022 ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("0"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildProfileImage(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(right: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  buildUserTile(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'name',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  ' \u2022 Date',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                )
              ],
            ),
            Text(
              ' @username',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
