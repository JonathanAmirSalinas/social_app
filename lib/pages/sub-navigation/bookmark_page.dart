
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            context.go("/home");
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
