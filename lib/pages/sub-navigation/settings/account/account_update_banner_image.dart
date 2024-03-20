import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/auth_services.dart';

class UpdateBannerImage extends StatefulWidget {
  final String banner;
  const UpdateBannerImage({super.key, required this.banner});

  @override
  State<UpdateBannerImage> createState() => _UpdateBannerImageState();
}

class _UpdateBannerImageState extends State<UpdateBannerImage> {
  bool loading = false;
  File? bannerFile;
  Uint8List? bannerBytes;

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
        bannerBytes = bytes;
        setState(() {
          bannerBytes = bytes;
        });
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

      setState(() => bannerFile = imageTemp);
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

  Future<bool> updateBanner() async {
    try {
      setState(() {
        loading = true;
      });
      await AuthServices().updateUserProfileBanner(bannerFile, bannerBytes);
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
                              buildCurrentBanner(),
                              buildReferenceDivider(),
                              buildNewBanner(),
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
            TextButton(
                onPressed: () async {
                  if (bannerFile != null || bannerBytes != null) {
                    bool status = await updateBanner();
                    if (status) {
                      completed();
                    }
                  } else {
                    emptyBannerMessage();
                  }
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
  buildCurrentBanner() {
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
            Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
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
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  widget.banner),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
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
            Icons.width_full_rounded,
            size: 18,
            color: Colors.white54,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Banner'),
          ),
        ],
      ),
    );
  }

  // New Banner
  buildNewBanner() {
    return Card(
      color: mainNavRailBackgroundColor,
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
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
                                  child: bannerBytes != null ||
                                          bannerFile != null
                                      ? Container(
                                          height: 300,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      MemoryImage(bannerBytes!),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                        )
                                      // Not Image
                                      : Container(),
                                ),
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

  emptyBannerMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.error_outline_rounded),
          ),
          Text('Banner is be empty'),
        ],
      ),
      backgroundColor: errorColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsetsDirectional.all(20),
      elevation: 30,
    ));
  }
}
