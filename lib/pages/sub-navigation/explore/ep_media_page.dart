import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'hub_media_tab')
class MediaTabPage extends StatefulWidget {
  const MediaTabPage({super.key});

  @override
  State<MediaTabPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaTabPage>
    with AutomaticKeepAliveClientMixin<MediaTabPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child:
          Padding(padding: const EdgeInsets.all(8.0), child: buildMediaGrid()),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Builds Media Grids with similar topic (eg. media with #sports)
  //////////////////////////////////////////////////////////////////////////////
  buildMediaGrid() {
    return GridView.custom(
      padding: EdgeInsets.zero,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: kIsWeb ? 4 : 3,
        mainAxisSpacing: kIsWeb ? 2 : 0,
        crossAxisSpacing: kIsWeb ? 2 : 0,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: kIsWeb
            ? [
                const QuiltedGridTile(2, 2),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 2),
              ]
            : [
                const QuiltedGridTile(2, 2),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
              ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: 15,
        (context, index) => const MediaTile(),
      ),
    );
  }
}

class MediaTile extends StatefulWidget {
  const MediaTile({super.key});

  @override
  State<MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        color: fillColor,
        child: Container(
          alignment: Alignment.center,
          child: MouseRegion(
            onHover: (event) {
              setState(() {
                hover = true;
              });
            },
            onExit: (event) {
              setState(() {
                hover = false;
              });
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: hover
                    ? AnimatedContainer(
                        duration: Durations.long2,
                        child: Column(
                          children: [
                            Expanded(
                              child: MediaQuery.of(context).size.width >
                                      webScreenSize
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 18,
                                              icon: const Icon(Icons
                                                  .favorite_border_rounded)),
                                          IconButton(
                                              onPressed: () {},
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 18,
                                              icon: const Icon(Icons
                                                  .bookmark_border_rounded)),
                                          IconButton(
                                              onPressed: () {},
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 18,
                                              icon: const Icon(Icons.share)),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Title',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '#Tags #Cagatory #Topic',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .fontSize,
                                          fontStyle: FontStyle.italic),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container()),
          ),
        ),
      ),
    );
  }
}
