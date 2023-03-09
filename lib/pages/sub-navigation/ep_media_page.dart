import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
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
            child: Container(
                alignment: Alignment.center, child: Text(index.toString()))));
  }
}
