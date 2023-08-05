import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'media_tab')
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
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: 15,
        (context, index) => mediaTile(index: index),
      ),
    );
  }

  mediaTile({required int index}) {
    return GridTile(
        child: Card(
            color: fillColor,
            child: Container(
                alignment: Alignment.center, child: Text(index.toString()))));
  }
}
