import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Page"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
                height: 20,
                width: 250,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: const TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: 'Explore and discover...',
                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: EdgeInsets.only(bottom: 8)),
                )),
          )
        ],
      ),
      body: const Center(
        child: Text("Explore"),
      ),
    );
  }
}
