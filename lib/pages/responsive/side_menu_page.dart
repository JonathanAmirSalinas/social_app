import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

class SideMenuPage extends StatefulWidget {
  const SideMenuPage({super.key});

  @override
  State<SideMenuPage> createState() => _SideMenuPageState();
}

class _SideMenuPageState extends State<SideMenuPage> {
  List<int> side = []; // Provider
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: navBarColor,
          title: const Text('Side Menu'),
          centerTitle: true,
        ),
        backgroundColor: primaryColor,
        body: Center(
            child: DragTarget(onAccept: (int data) {
          setState(() {
            side.add(data);
          });
        }, builder: ((context, candidateData, rejectedData) {
          return side.isNotEmpty
              ? ListView.builder(
                  itemCount: side.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Text(side[index].toString()),
                    );
                  })
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: navBarColor,
                      child: Container(
                        height: 40,
                        width: 150,
                        alignment: Alignment.center,
                        child: Text(
                          "Side-Menu is Empty",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        ),
                      ),
                    )
                  ],
                );
        }))),
      ),
    );
  }
}
