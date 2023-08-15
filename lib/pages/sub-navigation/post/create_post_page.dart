import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/providers/feed_provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/services/content_services.dart';

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
    UserModel userProvider = Provider.of<UserProvider>(context).getUser;
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.height * .8,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.black),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pops Dialog box and clears TextEditing Contollers and Images
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
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
                          TextButton(
                              onPressed: () async {
                                // Todo 1: Get values need for Function
                                if (imageFile == null && imageBytes == null) {
                                  await ContentServices().uploadMessagePost(
                                    createPostCaptionController.text,
                                  );
                                  feedProvider.refreshTopFeed(true);
                                } else {
                                  // Starts Loading State
                                  setState(() {
                                    loadingPost = true;
                                  });
                                  await ContentServices().uploadMediaPost(
                                    createPostCaptionController.text,
                                    imageFile,
                                    imageBytes!,
                                  );
                                  // Ends Loading State
                                  setState(() {
                                    loadingPost = false;
                                  });
                                  // Refreshes User's Feed with this new post
                                  feedProvider.refreshTopFeed(true);
                                }
                                // Pops CreatePostWidget
                                completed(true);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide()))),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize),
                              )),
                        ],
                      ),
                    ),
                    loadingPost
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                            child: LinearProgressIndicator(),
                          )
                        : const Divider(
                            thickness: 4,
                            color: navBarColor,
                          ),
                    // Create Post Body
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            // BODY
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile Image
                                buildProfileImage(
                                    context, userProvider.profileUrl),
                                Expanded(
                                  child: Column(
                                    children: [
                                      // User Identification
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildUserTile(
                                              context,
                                              userProvider.name,
                                              userProvider.username,
                                              0),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.menu)),
                                        ],
                                      ),
                                      ////////////////////////////////////// Statement
                                      TextField(
                                        controller: createPostCaptionController,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Column(
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
                                                    child:
                                                        imageBytes != null ||
                                                                imageFile !=
                                                                    null
                                                            ? Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .4,
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: MemoryImage(
                                                                            imageBytes!),
                                                                        fit: BoxFit
                                                                            .cover),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(16))),
                                                              )
                                                            // Not Image
                                                            : Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .4,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .38,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        fillColor,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(16)),
                                                                    image: DecorationImage(
                                                                        opacity:
                                                                            .2,
                                                                        image: AssetImage(
                                                                            'lib/assets/default_gallery.png'),
                                                                        fit: BoxFit
                                                                            .contain),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Click here to add a photo',
                                                                      style: TextStyle(
                                                                          fontSize: Theme.of(context)
                                                                              .textTheme
                                                                              .headlineSmall!
                                                                              .fontSize),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                    // ON DOUBLE TAP IT SHOULD LIKE THE POST IMAGE
                                                    onDoubleTap: () {},
                                                  ),
                                                  // Icons
                                                  buildIconSection(context),
                                                ],
                                              ),
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
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
