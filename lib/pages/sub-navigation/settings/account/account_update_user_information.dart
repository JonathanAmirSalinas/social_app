import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/auth_services.dart';

class UpdateUserInformation extends StatefulWidget {
  final String name;
  final String username;
  final String bio;
  const UpdateUserInformation(
      {super.key,
      required this.name,
      required this.username,
      required this.bio});

  @override
  State<UpdateUserInformation> createState() => _UpdateUserInformationState();
}

class _UpdateUserInformationState extends State<UpdateUserInformation> {
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Future<bool> updateUserInformation(
      String name, String username, String bio) async {
    try {
      setState(() {
        loading = true;
      });
      if (name.isNotEmpty) {
        await AuthServices().updateUserName(name);
      }
      if (username.isNotEmpty) {
        await AuthServices().updateUserUsername(username);
      }
      if (bio.isNotEmpty) {
        await AuthServices().updateUserDescription(bio);
      }
      setState(() {
        loading = false;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Finished Updating Banner
  completed() {
    context.router.pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Center(
        child: SizedBox(
          width: mobileScreenSize,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: mainBackgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: buildFunctionBar()),
                    loading
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: LinearProgressIndicator(),
                          )
                        : const Divider(
                            thickness: 4,
                            color: mainNavRailBackgroundColor,
                          ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildReferenceDivider(),
                              buildCurrentUserInfo(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildFunctionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              // Disable Clickable Items while loading
              if (!loading) {
                Navigator.of(context).pop();
              }
            },
            constraints: const BoxConstraints(),
            iconSize: 20,
            icon: const Icon(Icons.arrow_back_ios_new)),
        // Create Post Function
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 30,
                width: 2,
                color: fillColor,
              ),
            ),
            TextButton(
                onPressed: () async {
                  await updateUserInformation(nameController.text,
                      usernameController.text, bioController.text);
                  completed();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide()))),
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize),
                )),
          ],
        ),
      ],
    );
  }

  // Builds Reference Content
  buildCurrentUserInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: mainNavRailBackgroundColor,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    // Checks if Post has media
                    buildNameTextField(nameController, widget.name, 'Name',
                        Icons.account_circle_rounded),
                    buildUsernameTextField(usernameController, widget.username,
                        'Username', Icons.alternate_email_rounded),
                    buildBioTextField(
                        bioController, widget.bio, 'Bio', Icons.article),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Content Divider
  buildReferenceDivider() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Container(
            height: 3,
            width: 55,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            color: Colors.white54,
          ),
          const Icon(
            Icons.article_rounded,
            size: 18,
            color: Colors.white54,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('User Information'),
          ),
        ],
      ),
    );
  }

  // Username TextFormField
  buildNameTextField(TextEditingController controller, String info,
      String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).canvasColor,
          ),
          child: TextFormField(
            controller: controller,
            //focusNode: _nameFocus,
            decoration: InputDecoration(
              label: Text(label),
              hintText: info,
              contentPadding: const EdgeInsets.all(8),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon),
              counterText: "",
            ),
            validator: (value) {
              return value;
            },

            maxLength: 16,
          ),
        ),
      ],
    );
  }

  buildUsernameTextField(TextEditingController controller, String info,
      String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).canvasColor,
          ),
          child: TextField(
            controller: controller,
            //focusNode: _nameFocus,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z_]"))
            ],
            decoration: InputDecoration(
              label: Text(label),
              hintText: info,
              contentPadding: const EdgeInsets.all(8),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon),
              counterText: "",
            ),
            maxLength: 16,
          ),
        ),
      ],
    );
  }

  buildBioTextField(TextEditingController controller, String info, String label,
      IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).canvasColor,
          ),
          child: TextField(
            controller: controller,
            //focusNode: _nameFocus,
            decoration: InputDecoration(
                label: Text(label),
                hintText: info,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(icon),
                counterText: ""),
            maxLines: label == 'Bio' ? null : 1,
            maxLength: 256,
          ),
        ),
      ],
    );
  }
}
