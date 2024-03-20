import 'dart:io';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/services/auth_services.dart';
import 'package:social_app/services/server_services.dart';

class CreateServer extends StatefulWidget {
  const CreateServer({super.key});

  @override
  State<CreateServer> createState() => _CreateServerState();
}

class _CreateServerState extends State<CreateServer> {
  int section = 1;
  List<String> tags = [];
  bool loadingPost = false;
  bool isUniqueServerID = false;
  final List<bool> privacyToggle = <bool>[false, true];
  String privacy = 'private';

  // Server Name Controller
  TextEditingController serverNameController = TextEditingController();
  // Server ID Controller
  TextEditingController serverIDController = TextEditingController();
  // Server DEscription Controller
  TextEditingController serverDescriptionController = TextEditingController();
  // Server Tags Controller
  TextEditingController serverTagsController = TextEditingController();
  // Server Images
  File? serverImageFile;
  Uint8List? serverImageBytes;
  // Server Banner
  File? serverBannerFile;
  Uint8List? serverBannerBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    serverNameController.dispose();
    serverIDController.dispose();
    super.dispose();
  }

  completed() {
    Navigator.of(context).pop();
    context.router.pushNamed('/main/servers');
  }

  validateServerID() {
    if (!isUniqueServerID) {
      return 'This Server ID is already taken';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (section) {
        case 1:
          return buildServerCreationSectionOne();
        case 2:
          return buildServerCreationSectionTwo();

        default:
          return buildServerCreationSectionOne();
      }
    });
  }

  // Build Header
  buildHeader() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return section == 1
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  Text(
                    "Create Server",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                ],
              ),
              // Navigates to Section/Step Two
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
                      onPressed: () {
                        if (serverNameController.text.trim().isNotEmpty &&
                                serverIDController.text.trim().isNotEmpty &&
                                serverBannerBytes != null ||
                            serverBannerFile != null &&
                                serverImageBytes != null ||
                            serverImageFile != null) {
                          setState(() {
                            section = 2;
                          });
                        }
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide()))),
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: serverNameController.text
                                            .trim()
                                            .isNotEmpty &&
                                        serverIDController.text
                                            .trim()
                                            .isNotEmpty &&
                                        serverBannerBytes != null ||
                                    serverBannerFile != null &&
                                        serverImageBytes != null ||
                                    serverImageFile != null
                                ? mainSecondaryColor
                                : mainServerRailBackgroundColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      )),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navigates back to Step One

              IconButton(
                  onPressed: () {
                    // Disables Button when Server is Being Created
                    if (!loadingPost) {
                      setState(() {
                        section = 1;
                      });
                    }
                  },
                  constraints: const BoxConstraints(),
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_back_ios_new)),

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
                  // Create Server Button
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          loadingPost = true;
                        });
                        await ServerServices().createServer(
                            FirebaseAuth.instance.currentUser!.uid,
                            serverNameController.text.trim(),
                            '/${serverIDController.text.trim()}',
                            serverImageFile,
                            serverImageBytes,
                            serverBannerFile,
                            serverBannerBytes,
                            privacy,
                            serverDescriptionController.text,
                            tags);
                        // Refresh User Data
                        userProvider.refreshUser;
                        setState(() {
                          loadingPost = false;
                        });

                        completed();
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide()))),
                      child: Text(
                        'Create',
                        style: TextStyle(
                            color: mainSecondaryColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      )),
                ],
              ),
            ],
          );
  }

  // Sections Divider
  buildSectionDivider(String section, IconData icon, String imageSection,
      bool activeImage, bool optional) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 3,
                width: 55,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                color: Colors.white54,
              ),
              Icon(
                icon,
                size: 18,
                color: Colors.white54,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(section),
              ),
              optional
                  ? Text(
                      ' (optional)',
                      style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize),
                    )
                  : Container()
            ],
          ),
          // Add Image Icon (boolean)
          activeImage
              // Add Image (true = Server Image | false = Server Banner)
              ? imageSection == "Image"
                  ? IconButton(
                      onPressed: () {
                        if (kIsWeb) {
                          pickWebImage(true);
                        } else {
                          pickMobileImage(true);
                        }
                      },
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: mainSecondaryColor,
                        size: 18,
                      ))
                  : IconButton(
                      onPressed: () {
                        if (kIsWeb) {
                          pickWebImage(false);
                        } else {
                          pickMobileImage(false);
                        }
                      },
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: mainSecondaryColor,
                        size: 18,
                      ))
              : Container()
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Section One
  ///////////////////////////////////////////////////////////////////////////////////////////////

  // Builds The First Section/Step to Creating a Server
  buildServerCreationSectionOne() {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                // Header ///////////////////////////////////////////////////////////////
                Flexible(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8), child: buildHeader()),
                    loadingPost
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: LinearProgressIndicator(),
                          )
                        : const Divider(
                            thickness: 4,
                            color: mainNavRailBackgroundColor,
                          ),
                    // Main Body ///////////////////////////////////////////////////////
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildSectionDivider(
                                  'Server Banner',
                                  Icons.rectangle_rounded,
                                  'Banner',
                                  true,
                                  false),
                              buildBannerImageSectionOne(),
                              buildSectionDivider(
                                  'Server Image',
                                  Icons.rectangle_rounded,
                                  'Image',
                                  true,
                                  false),
                              buildServerImageSectionOne(),
                              buildSectionDivider('Server Name',
                                  Icons.text_snippet, '', false, false),
                              buildServerNameSectionOne(),
                              buildSectionDivider('Server ID',
                                  Icons.text_snippet, '', false, false),
                              buildServerIDSectionOne()
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

  // Builds Server's Banner Placeholder
  buildBannerImageSectionOne() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          color: mainNavRailBackgroundColor,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                image: serverBannerBytes != null
                    ? DecorationImage(
                        image: MemoryImage(serverBannerBytes!),
                        fit: BoxFit.cover)
                    : serverBannerFile != null
                        ? DecorationImage(
                            image: FileImage(serverBannerFile!),
                            fit: BoxFit.cover)
                        : null,
                borderRadius: const BorderRadius.all(Radius.circular(6))),
          ),
        ));
  }

  // Builds Server's Image Placeholder
  buildServerImageSectionOne() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          color: mainNavRailBackgroundColor,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Container(
            height: kIsWeb ? 150 : 130,
            width: kIsWeb ? 200 : 180,
            decoration: BoxDecoration(
                image: serverImageBytes != null
                    ? DecorationImage(
                        image: MemoryImage(serverImageBytes!),
                        fit: BoxFit.cover)
                    : serverImageFile != null
                        ? DecorationImage(
                            image: FileImage(serverImageFile!),
                            fit: BoxFit.cover)
                        : null,
                borderRadius: const BorderRadius.all(Radius.circular(6))),
          ),
        ));
  }

  // Builds Server Name TextField
  buildServerNameSectionOne() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          color: mainNavRailBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: TextField(
        controller: serverNameController,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.left,
        maxLength: 24,
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "Server Name", counterText: ""),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  // Build Server ID TextField
  buildServerIDSectionOne() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          color: mainNavRailBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: [
          TextFormField(
            controller: serverIDController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.left,
            maxLength: 24,
            maxLines: 1,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-z]")),
            ],
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Server ID",
                counterText: ""),
            validator: ((value) {
              if (isUniqueServerID) {
                return isUniqueServerID.toString();
              } else {
                return ' Please';
              }
            }),
            onChanged: (value) async {
              isUniqueServerID =
                  await AuthServices().checkUniqueServerID(value.trim());
              setState(() {});
            },
          ),
          //Text(isUniqueServerID.toString())
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Section Two
  ///////////////////////////////////////////////////////////////////////////////////////////////

  // Build Section/Step Two of Creating a Server
  buildServerCreationSectionTwo() {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                // Header ///////////////////////////////////////////////////////////////
                Flexible(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8), child: buildHeader()),
                    loadingPost
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: LinearProgressIndicator(
                              color: mainSecondaryColor,
                            ),
                          )
                        : const Divider(
                            thickness: 4,
                            color: mainNavRailBackgroundColor,
                          ),
                    // Main Body ///////////////////////////////////////////////////////
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSectionDivider('Icon Preview',
                                  Icons.video_label, '', false, false),
                              buildServerIconPreviewSectionTwo(),
                              buildSectionDivider('Preview', Icons.video_label,
                                  '', false, false),
                              buildServerPreviewSectionTwo(),
                              buildSectionDivider('Privacy',
                                  Icons.lock_open_rounded, '', false, false),
                              buildServerPrivacySectionTwo(),
                              buildSectionDivider('Decription',
                                  Icons.text_snippet_rounded, '', false, true),
                              buildServerDescriptionSectionTwo(),
                              buildSectionDivider('Tags',
                                  Icons.view_stream_rounded, '', false, true),
                              buildServerTagsSectionTwo(),
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

// Builds Server Icon
  buildServerIconPreviewSectionTwo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
              image: serverImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(serverImageBytes!), fit: BoxFit.cover)
                  : serverImageFile != null
                      ? DecorationImage(
                          image: FileImage(serverImageFile!), fit: BoxFit.cover)
                      : null,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
        ),
        Container(
          height: 75,
          width: 75,
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
              image: serverImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(serverImageBytes!), fit: BoxFit.cover)
                  : serverImageFile != null
                      ? DecorationImage(
                          image: FileImage(serverImageFile!), fit: BoxFit.cover)
                      : null,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
        ),
        Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
              image: serverImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(serverImageBytes!), fit: BoxFit.cover)
                  : serverImageFile != null
                      ? DecorationImage(
                          image: FileImage(serverImageFile!), fit: BoxFit.cover)
                      : null,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
        ),
      ],
    );
  }

  // Builds Server Preview
  buildServerPreviewSectionTwo() {
    return Card(
      color: mainNavRailBackgroundColor,
      child: AspectRatio(
          aspectRatio: 1.9,
          child: Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    // Banner
                    Column(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: serverBannerBytes != null
                                  ? DecorationImage(
                                      image: MemoryImage(serverBannerBytes!),
                                      fit: BoxFit.cover)
                                  : serverBannerFile != null
                                      ? DecorationImage(
                                          image: FileImage(serverBannerFile!),
                                          fit: BoxFit.cover)
                                      : null,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: kIsWeb ? 150 : 130,
                                width: kIsWeb ? 200 : 180,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    image: serverImageBytes != null
                                        ? DecorationImage(
                                            image:
                                                MemoryImage(serverImageBytes!),
                                            fit: BoxFit.cover)
                                        : serverImageFile != null
                                            ? DecorationImage(
                                                image:
                                                    FileImage(serverImageFile!),
                                                fit: BoxFit.cover)
                                            : null,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serverNameController.text.trim(),
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .fontSize),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '/${serverIDController.text.trim()}',
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // Build Server Privacy Section
  buildServerPrivacySectionTwo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ToggleButtons(
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < privacyToggle.length; i++) {
                    privacyToggle[i] = i == index;
                  }
                  if (privacyToggle[0] == false) {
                    privacy = 'private';
                  } else {
                    privacy = 'public';
                  }
                });
              },
              isSelected: privacyToggle,
              selectedColor: mainSecondaryColor,
              disabledColor: mainServerRailBackgroundColor,
              fillColor: mainNavRailBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              direction: Axis.horizontal,
              //selectedColor: Colors.white,
              //fillColor: Colors.pink[200],

              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    'Public',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    'Private',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize),
                  ),
                )
              ])
        ],
      ),
    );
  }

  // Builds Server Description TextField
  buildServerDescriptionSectionTwo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          color: mainNavRailBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: DetectableTextField(
        controller: serverDescriptionController,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.left,
        maxLength: 256,
        maxLines: null,
        basicStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
          fontWeight: FontWeight.w400,
        ),
        decoratedStyle: TextStyle(
          color: taggedColor,
          fontWeight: FontWeight.w500,
          fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
        ),
        detectionRegExp: RegExp(
          "(?!\\n)(?:^|)([#@/]([$detectionContentLetters]+))|$urlRegexContent",
          multiLine: true,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Server Description",
            counterText: ""),
      ),
    );
  }

  // Builds Server Tags Section
  buildServerTagsSectionTwo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
              color: mainNavRailBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: TextField(
            controller: serverTagsController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.left,
            maxLength: 24,
            maxLines: null,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
            ],
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Server Tags (e.g., chill, gaming, news)",
                counterText: ""),
            onSubmitted: (value) {
              if (tags.contains('#${value.toLowerCase().trim()}')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4))),
                    backgroundColor: errorColor,
                    content: Text(
                      'Tag has already been Added',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize),
                    )));
              } else {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4))),
                      backgroundColor: errorColor,
                      content: Text(
                        'Input Error...Tag is Empty',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .fontSize),
                      )));
                } else {
                  setState(() {
                    serverTagsController.clear();
                    tags.add('#${value.toLowerCase().trim()}');
                  });
                }
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 12),
          alignment: Alignment.centerRight,
          child: Text(
            'Click on tags to remove them from the list',
            style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
          ),
        ),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
                tags.length,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          tags.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        child: Text(tags[index]),
                      ),
                    )),
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////////// Function
  ///
  // Web Image/File Picker using Uint8List bytes
  Future pickWebImage(bool isServerImage) async {
    if (isServerImage) {
      // Server Image
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'webm'],
            allowMultiple: false);

        Uint8List bytes;

        if (result != null) {
          bytes = result.files.first.bytes!;
          serverImageBytes = bytes;
          setState(() {
            serverImageBytes = bytes;
          });

          //imagee = await _cropWebImage(image: file);
        } else {
          // User canceled the picker
          return;
        }
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    } else {
      // Server Banner
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'webm'],
            allowMultiple: false);

        Uint8List bytes;

        if (result != null) {
          bytes = result.files.first.bytes!;
          serverBannerBytes = bytes;
          setState(() {
            serverBannerBytes = bytes;
          });

          //imagee = await _cropWebImage(image: file);
        } else {
          // User canceled the picker
          return;
        }
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    }
  }

  // Mobile Image/File Picker using File
  Future pickMobileImage(bool isServerImage) async {
    if (isServerImage) {
      try {
        var image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        File imageTemp = File(image.path);
        imageTemp = await _cropImage(image: imageTemp);

        setState(() => serverImageFile = imageTemp);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    } else {
      try {
        var image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        File imageTemp = File(image.path);
        imageTemp = await _cropImage(image: imageTemp);

        setState(() => serverBannerFile = imageTemp);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    }
  }

  // Might not implement since Web Image/File is in bytes and has no path
  Future<File> _cropWebImage({required File image}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        uiSettings: [
          WebUiSettings(
            context: context,
          )
        ]);
    if (croppedImage == null) return image;
    return File(croppedImage.path);
  }

  // Mobile Image Cropper
  Future<File> _cropImage({required File image}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        uiSettings: [WebUiSettings(context: context, showZoomer: true)]);
    if (croppedImage == null) return image;
    return File(croppedImage.path);
  }
}
