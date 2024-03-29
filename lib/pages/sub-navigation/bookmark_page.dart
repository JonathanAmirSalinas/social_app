import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'bookmark')
class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Bookmark Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Bookmark"),
      ),
    );
  }
}
