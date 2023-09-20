import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/widgets/constant_widgets.dart';
import 'package:social_app/widgets/view_content.dart';

// TO-DO ////////////////////////////////////////////////////////////// TO-DO //
// 1: Make sure user cant spam post button while post is loading
// 2: Make sure user cant post with empty values, message or image needed
// 3: Make sure Mobile UI is similar to Web UI
// 4: Make sure all input widgets are disabled while Post is loading
// 5: Make sure when feed is refreshed current user post is on top (Important)
// 6: Add Filter/PageView option to scroll between create (post/story/server)

class CreateRePostPage extends StatefulWidget {
  final Map<String, dynamic> content;
  const CreateRePostPage({super.key, required this.content});

  @override
  State<CreateRePostPage> createState() => _CreateRePostPageState();
}

class _CreateRePostPageState extends State<CreateRePostPage> {
  // Create Post Variables
  bool loadingPost = false;
  TextEditingController createPostCaptionController = TextEditingController();
  File? imageFile;
  Uint8List? imageBytes;

  // Web Image/File Picker using Uint8List bytes
  Future pickWebImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'webm'],
          allowMultiple: false);

      Uint8List bytes;

      if (result != null) {
        bytes = result.files.first.bytes!;
        imageBytes = bytes;
        setState(() {
          //imageGal = imagee;
          imageBytes = bytes;
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

  // Mobile Image/File Picker using File
  Future pickMobileImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      File imageTemp = File(image.path);
      imageTemp = await _cropImage(image: imageTemp);

      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
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

  @override
  void dispose() {
    createPostCaptionController.dispose();
    super.dispose();
  }

  completed(bool done) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          width: mobileScreenSize,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: backgroundColorSolid),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: buildRePostBar(),
                    ),
                    // Loading Indicator
                    loadingPost
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: LinearProgressIndicator(),
                          )
                        : const Divider(
                            thickness: 4,
                            color: navBarColor,
                          ),
                    // Body
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildRepostBody(),
                              buildReferenceDivider(),
                              buildReferenceContent(),
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

  // Repost Dialog Bar
  buildRePostBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              // Disable Clickable Items while Post is
              if (!loadingPost) {
                Navigator.of(context).pop();
              }
            },
            constraints: const BoxConstraints(),
            iconSize: 20,
            icon: const Icon(Icons.arrow_back_ios_new)),
        // Create Post Function
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.poll_outlined,
                  color: secondaryColor,
                  size: 18,
                )),
            IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.layers_outlined,
                  color: secondaryColor,
                  size: 18,
                )),
            // Add Image
            IconButton(
                onPressed: () {
                  if (kIsWeb) {
                    pickWebImage();
                  } else {
                    pickMobileImage();
                  }
                },
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: secondaryColor,
                  size: 18,
                )),
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
                  if (imageFile != null ||
                      imageBytes != null ||
                      createPostCaptionController.text.isNotEmpty) {
                    //
                    if (imageFile == null && imageBytes == null) {
                      setState(() {
                        loadingPost = true;
                      });
                      await ContentServices().uploadMessagePost(
                          createPostCaptionController.text,
                          're_post',
                          widget.content['id_content']);
                      //await feedProvider.getUserFeed();
                      //await feedProvider.refreshTopFeed(true);
                      setState(() {
                        loadingPost = false;
                      });
                      // Pops CreatePostWidget
                    } else {
                      // Starts Loading State
                      setState(() {
                        loadingPost = true;
                      });
                      await ContentServices().uploadMediaPost(
                        createPostCaptionController.text,
                        imageFile,
                        imageBytes!,
                        're_post',
                        widget.content['id_content'],
                      );
                      // Ends Loading State
                      setState(() {
                        loadingPost = false;
                      });
                      // Refreshes User's Feed with this new post
                      //await feedProvider.refreshTopFeed(true);
                    }
                    // Pops CreatePostWidget
                    completed(true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.error_outline_rounded),
                          ),
                          Text('Post is be empty'),
                        ],
                      ),
                      backgroundColor: errorColor,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsetsDirectional.all(20),
                      elevation: 30,
                    ));
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide()))),
                child: Text(
                  'Repost',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize),
                )),
          ],
        ),
      ],
    );
  }

  // Main Body (Input)
  buildRepostBody() {
    return Card(
      color: cardColor,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                buildProfileImage(context),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Identification
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildUserTile(context),
                        ],
                      ),
                      ////////////////////////////////////// Statement
                      TextField(
                        controller: createPostCaptionController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.left,
                        maxLength: 256,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add Message...",
                            counterText: ""),
                      ),

                      ///////////////////////////////// Image or Media
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (kIsWeb) {
                                      pickWebImage();
                                    } else {
                                      pickMobileImage();
                                    }
                                  },
                                  // Has Image
                                  child: imageBytes != null || imageFile != null
                                      ? Container(
                                          clipBehavior: Clip.antiAlias,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      MemoryImage(imageBytes!),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                        )
                                      // Not Image
                                      : Container(),

                                  // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                  onDoubleTap: () {},
                                ),
                                // Icons
                                //buildBlankIconSection(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Divider Indicator
  buildReferenceDivider() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          Container(
            height: 3,
            width: 55,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white54,
          ),
          const Icon(
            Icons.question_answer_rounded,
            size: 18,
            color: Colors.white54,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text("Referencing Post")),
        ],
      ),
    );
  }

  // Reference Post Content
  buildReferenceContent() {
    return Container(
      child: Card(
        color: cardColor,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  buildReferenceProfileImage(context, widget.content),
                  Expanded(
                    child: Column(
                      children: [
                        // User Identification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildReferenceUserInfo(
                                  context, widget.content),
                            )
                          ],
                        ),
                        // Post
                        Row(
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.content['statement'],
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .fontSize),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Image or Media
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    // Checks if Post has media
                                    widget.content['hasMedia'] == true
                                        ? GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ViewContent(
                                                        snap: widget.content);
                                                  });
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .25,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              widget.content[
                                                                  'media_url']),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6))),
                                            ),
                                            // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                            onDoubleTap: () {},
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        buildNonInteractiveIconSection(context, widget.content)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
