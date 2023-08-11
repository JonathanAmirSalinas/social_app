import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/auth_services.dart';

@RoutePage(name: 'profile')
class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, @PathParam('uid') required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool loading;
  late UserModel user;

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  // Gets User Profile via UID
  getUserProfile() async {
    setState(() {
      loading = true;
    });
    try {
      String uid = widget.uid;
      UserModel userProfile = await AuthServices().getUserProfile(uid);
      setState(() {
        user = userProfile;
      });
    } on Exception catch (e) {
      // TODO
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth <= webScreenSize) {
        return buildMobileProfilePage(constraints.maxWidth);
      } else {
        return buildWebProfilePage(constraints.maxWidth);
      }
    }));
  }

  buildMobileProfilePage(double constraints) {
    return Scaffold(
      backgroundColor: navBarColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Mobile Profile Page"),
        centerTitle: true,
      ),
      body: loading
          ? Container(
              color: primaryColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [Text(user.name)],
            ),
    );
  }

  buildWebProfilePage(double constraints) {
    return Scaffold(
      backgroundColor: navBarColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: loading
          ? Container(
              color: primaryColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 150,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(user.profileUrl),
                                fit: BoxFit.cover)),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .fontSize),
                                  ),
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  ),
                                  Text(
                                    user.bio,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.settings),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.accessibility_new_rounded),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Followers",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                user.followers.length.toString(),
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Following",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                user.following.length.toString(),
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 3,
                    color: primaryColor,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: buildPinnedSection(),
                            )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: const BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: buildBookmarkedSection(),
                                )),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: buildPostsSection(),
                      )),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: buildRecentSection(),
                            )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: const BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: buildServersSection(),
                                )),
                          ],
                        ),
                      )),
                    ],
                  ))
                ],
              ),
            ),
    );
  }

  // Pinned Section
  buildPinnedSection() {
    return Column(
      children: [
        buildSectionDivider('Pinned'),
      ],
    );
  }

  // Bookmarked Section
  buildBookmarkedSection() {
    return Column(
      children: [
        buildSectionDivider('Bookmarked'),
      ],
    );
  }

  // Posts Section
  buildPostsSection() {
    return Column(
      children: [
        buildSectionDivider('Posts'),
      ],
    );
  }

  // Recent Section
  buildRecentSection() {
    return Column(
      children: [
        buildSectionDivider('Recent'),
      ],
    );
  }

  // Server Section
  buildServersSection() {
    return Column(
      children: [
        buildSectionDivider('Servers'),
      ],
    );
  }

  // Section Title Divider
  buildSectionDivider(String section) {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: primaryColor,
        )),
        Text(
          section,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
        ),
        Expanded(
            flex: 8,
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: primaryColor,
            )),
      ],
    );
  }
}
