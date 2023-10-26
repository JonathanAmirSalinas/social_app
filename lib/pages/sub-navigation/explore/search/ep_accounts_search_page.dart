import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'search_account_tab')
class AccountSearchPage extends StatefulWidget {
  final String keyword;
  const AccountSearchPage({super.key, required this.keyword});

  @override
  State<AccountSearchPage> createState() => _AccountSearchPageState();
}

class _AccountSearchPageState extends State<AccountSearchPage>
    with AutomaticKeepAliveClientMixin<AccountSearchPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: backgroundColorSolid,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Empty Search bar
                        if (widget.keyword.isEmpty) {
                          return Text(widget.keyword);
                        }
                        //
                        else if (snapshot.data!.docs[index]
                            .data()['name']
                            .toString()
                            .toLowerCase()
                            .startsWith(widget.keyword.toLowerCase())) {
                          return buildSearchAccountCard(
                              context, snapshot.data!.docs[index].data());
                        } else {
                          return Container();
                        }
                      });
                case ConnectionState.done:
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildSearchAccountCard(
                            context, snapshot.data!.docs[index].data());
                      });
              }
            }));
  }

  // Builds User Card
  buildSearchAccountCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/profile/${data['uid']}');
      },
      child: Card(
        color: navBarColor,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Container(
          margin: const EdgeInsets.all(2),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                data['profile_image']),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .fontSize),
                          ),
                          Text(data['username']),
                          Container(
                            child: Text(
                              data['bio'],
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Follow',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
