import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/server_services.dart';

class ServerTextBar extends StatefulWidget {
  final String sid;
  final String channel;
  const ServerTextBar({super.key, required this.sid, required this.channel});

  @override
  State<ServerTextBar> createState() => _ServerTextBarState();
}

class _ServerTextBarState extends State<ServerTextBar> {
  TextEditingController chatController = TextEditingController();
  List<String> mentions = [];
  // Server Images
  File? chatImage;
  Uint8List? chatImageBytes;
  final FocusNode _focus = FocusNode();

  //////////////////////////////////////////////////////////////////// Functions
  ///
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
        chatImageBytes = bytes;
        setState(() {
          chatImageBytes = bytes;
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
      imageTemp = await cropImage(image: imageTemp);

      setState(() => chatImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Might not implement since Web Image/File is in bytes and has no path
  Future<File> cropWebImage({required File image}) async {
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
  Future<File> cropImage({required File image}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        uiSettings: [WebUiSettings(context: context, showZoomer: true)]);
    if (croppedImage == null) return image;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Media Container
          chatImage == null && chatImageBytes == null
              ? Container()
              : Container(
                  width: double.infinity,
                  color: mainNavRailBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          // Chat Media
                          Card(
                            color: mainNavRailBackgroundColor,
                            shape: const ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Container(
                              height: kIsWeb ? 150 : 130,
                              width: kIsWeb ? 200 : 180,
                              decoration: BoxDecoration(
                                  image: chatImageBytes != null
                                      ? DecorationImage(
                                          image: MemoryImage(chatImageBytes!),
                                          fit: BoxFit.cover)
                                      : chatImage != null
                                          ? DecorationImage(
                                              image: FileImage(chatImage!),
                                              fit: BoxFit.cover)
                                          : null,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                            ),
                          ),
                          // Media Delete IconButton
                          Container(
                            height: kIsWeb ? 120 : 100,
                            width: kIsWeb ? 200 : 180,
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(4),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24))),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          chatImage = null;
                                          chatImageBytes = null;
                                        });
                                      },
                                      iconSize: 18,
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.close)),
                                )),
                          )
                        ],
                      ),
                    ],
                  )),
          // Chat Text Bar
          Container(
            padding: const EdgeInsets.all(4),
            color: mainServerRailBackgroundColor,
            child: Row(
              children: [
                // Add Media IconButton
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
                      size: 20,
                    )),
                // Add GIF Icon Button
                IconButton(
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.gif_box_outlined,
                      color: mainSecondaryColor,
                      size: 20,
                    )),
                // Chat TextField
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                        color: mainNavRailBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      focusNode: _focus,
                      controller: chatController,
                      decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          border: const OutlineInputBorder(),
                          // Send Button
                          suffixIcon: IconButton(
                              onPressed: () async {
                                // If Channel is EMPTY Create Messages Collection in servers -> server -> channels -> channel -> messages -> message
                                /* if (false) {
                                  // No Media Chat Message
                                  if (chatImage == null &&
                                      chatImageBytes == null) {
                                    await ServerServices().createChannelMessage(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.sid,
                                        widget.channel,
                                        chatController.text.trim(),
                                        mentions);
                                  } else {
                                    // Medai Message
                                    await ServerServices()
                                        .createChannelMediaMessage(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.sid,
                                            widget.channel,
                                            chatController.text.trim(),
                                            chatImage,
                                            chatImageBytes,
                                            mentions);
                                  }
                                  // Clears Chat Message Values
                                  setState(() {
                                    chatController.clear();
                                    chatImage = null;
                                    chatImageBytes = null;
                                    mentions.clear();
                                  });
                                }*/
                                // Post Message into Messages Collection
                                //else {
                                // If no media is attched to message
                                if (chatImage == null &&
                                    chatImageBytes == null) {
                                  await ServerServices().sendChannelMessage(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      widget.sid,
                                      widget.channel,
                                      chatController.text.trim(),
                                      mentions);
                                } else {
                                  await ServerServices()
                                      .sendChannelMediaMessage(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.sid,
                                          widget.channel,
                                          chatController.text.trim(),
                                          chatImage,
                                          chatImageBytes,
                                          mentions);
                                }
                                // Clears Chat Message Values
                                setState(() {
                                  chatController.clear();
                                  chatImage = null;
                                  chatImageBytes = null;
                                  mentions.clear();
                                });
                                //}
                              },
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white70,
                              ))),
                      onSubmitted: (value) async {
                        if (chatImage == null && chatImageBytes == null) {
                          await ServerServices().sendChannelMessage(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.sid,
                              widget.channel,
                              chatController.text.trim(),
                              mentions);
                        } else {
                          await ServerServices().sendChannelMediaMessage(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.sid,
                              widget.channel,
                              chatController.text.trim(),
                              chatImage,
                              chatImageBytes,
                              mentions);
                        }
                        // Clears Chat Message Values
                        setState(() {
                          chatController.clear();
                          chatImage = null;
                          chatImageBytes = null;
                          mentions.clear();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
