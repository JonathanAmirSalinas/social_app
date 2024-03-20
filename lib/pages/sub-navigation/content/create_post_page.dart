import 'dart:io';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/content_services.dart';
import 'package:social_app/widgets/constant_widgets.dart';

// TO-DO ////////////////////////////////////////////////////////////// TO-DO //
// 1: Make sure user cant spam post button while post is loading
// 2: Make sure user cant post with empty values, message or image needed
// 3: Make sure Mobile UI is similar to Web UI
// 4: Make sure all input widgets are disabled while Post is loading
// 5: Make sure when feed is refreshed current user post is on top (Important)
// 6: Add Filter/PageView option to scroll between create (post/story/server)

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // Create Post Variables
  bool loadingPost = false;
  TextEditingController createPostCaptionController = TextEditingController();
  File? imageFile;
  Uint8List? imageBytes;
  List<String> hashtags = [];
  List<String> mentions = [];

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
        uiSettings: [
          WebUiSettings(
            context: context,
          )
        ]);
    if (croppedImage == null) {
      print('image null');
      return image;
    }
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
          width: mobileScreenSize,
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: mainBackgroundColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pops Dialog box and clears TextEditing Contollers and Images
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: buildPostBar(),
                      ),
                      loadingPost
                          ? const Padding(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                              child: LinearProgressIndicator(),
                            )
                          : const Divider(
                              thickness: 4,
                              color: mainNavRailBackgroundColor,
                            ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            // BODY
                            buildPostBody(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPostBar() {
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
          children: [
            IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.poll_outlined,
                  color: mainSecondaryColor,
                  size: 18,
                )),
            IconButton(
                onPressed: () {},
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.layers_outlined,
                  color: mainSecondaryColor,
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
                  color: mainSecondaryColor,
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
            // Post
            TextButton(
                onPressed: () async {
                  hashtags = extractDetections(
                      createPostCaptionController.text, hashTagRegExp);
                  mentions = extractDetections(
                      createPostCaptionController.text, atSignRegExp);
                  if (imageFile != null ||
                      imageBytes != null ||
                      createPostCaptionController.text.isNotEmpty) {
                    // Todo 1: Get values need for Function
                    if (imageFile == null && imageBytes == null) {
                      // Starts Loading State
                      setState(() {
                        loadingPost = true;
                      });

                      await ContentServices().uploadMessagePost(
                          createPostCaptionController.text,
                          'post',
                          '',
                          hashtags,
                          mentions);

                      ///await feedProvider.getUserFeed();
                      // Refreshes User's Feed with this new post
                      // await feedProvider.refreshTopFeed(true);
                      // Ends Loading State
                      setState(() {
                        loadingPost = false;
                      });
                    } else {
                      // Starts Loading State
                      setState(() {
                        loadingPost = true;
                      });
                      await ContentServices().uploadMediaPost(
                          createPostCaptionController.text,
                          imageFile,
                          imageBytes!,
                          'post',
                          '',
                          hashtags,
                          mentions);
                      //await feedProvider.getUserFeed();
                      // Refreshes User's Feed with this new post
                      //await feedProvider.refreshTopFeed(true);

                      // Ends Loading State
                      setState(() {
                        loadingPost = false;
                      });
                    }
                    // Pops CreatePostWidget
                    completed(true);
                  } else {
                    // Validator Messages
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
                  'Post',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize),
                )),
          ],
        ),
      ],
    );
  }

  buildPostBody() {
    return Card(
      color: mainNavRailBackgroundColor,
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            buildProfileImage(context),
            Expanded(
              child: Column(
                children: [
                  // User Identification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUserTile(context),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert_sharp)),
                    ],
                  ),
                  ////////////////////////////////////// Statement
                  DetectableTextField(
                    controller: createPostCaptionController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    maxLength: 256,
                    maxLines: null,
                    basicStyle: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                    decoratedStyle: TextStyle(
                      color: taggedColor,
                      fontWeight: FontWeight.w500,
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                    ),
                    detectionRegExp: RegExp(
                      "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
                      multiLine: true,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Message...",
                        counterText: ""),
                  ),

                  ///////////////////////////////// Image or Media
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: imageBytes != null
                                  ? Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(imageBytes!),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                    )
                                  // Not Image
                                  : imageFile != null
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: FileImage(imageFile!),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                        )
                                      : Container(),
                              // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                              onDoubleTap: () {},
                            ),
                            // Icons
                            buildBlankIconSection(context)
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
      ),
    );
  }
}
