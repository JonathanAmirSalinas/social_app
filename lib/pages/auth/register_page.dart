import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/constants.dart';
import 'package:social_app/services/auth_services.dart';

@RoutePage(name: 'register')
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _index = 0;
  final _formOneKey = GlobalKey<FormState>();
  final _formTwoKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final accountSetUpFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String name = '';
  final usernameController = TextEditingController();
  String username = '';
  File? imageGal; // Mobile
  Uint8List? imageBytes; // Web

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

      setState(() => imageGal = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Might not implement since Web Image/File is in bytes and has no path
  /*Future<File> _cropWebImage({required File image}) async {
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
  }*/

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
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _index == 0
            ? null
            : AppBar(
                centerTitle: true,
                leading: Builder(builder: (context) {
                  return IconButton(
                      onPressed: () {
                        setState(() {
                          _index = 0;
                          emailController.clear();
                          passwordController.clear();
                          nameController.clear();
                          usernameController.clear();
                          if (imageGal != null) {
                            imageGal!.delete();
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_back_rounded));
                }),
                title: Text(MediaQuery.of(context).size.width.toString()),
              ),
        body: registerForm(),
      ),
    );
  }

////////////////////////////////////////////// Manages Form State
  Widget registerForm() {
    return Builder(builder: (context) {
      switch (_index) {
        case 0:
          return registerFormOne();
        case 1:
          return registerFormTwo();

        default:
          return registerFormOne();
      }
    });
  }

// First register Step (Email, Password)
  Widget registerFormOne() {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > 830
          ? buildWebRegisterFormOne()
          : buildMobileRegisterFormOne();
    });
  }

  // Web Register Form One (Email, Password)
  buildWebRegisterFormOne() {
    return Form(
      key: _formOneKey,
      child: Row(
        children: [
          Container(
            width: mobileScreenSize as double,
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: navServerBar),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Social App',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge!.fontSize),
                ),
                const SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((password) => password != null &&
                                    password.length < 6
                                ? 'Password must be at least be 6 characters'
                                : null),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  icon: const Icon(Icons.align_horizontal_right_sharp),
                  label: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (_formOneKey.currentState!.validate()) {
                      setState(() {
                        _index = 1;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4))),
                          backgroundColor: Colors.red,
                          content: Text(
                            'Input Error... Please check the Email and Password provided',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => context.router.navigateNamed('/'),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Right Side of LoginPage
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      width: 450,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .fontSize,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'and View, Chat, and Explore with friends',
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
              Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'version: 1',
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize:
                              Theme.of(context).textTheme.labelLarge!.fontSize,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  // Mobile Register Form One (Email, Password)
  buildMobileRegisterFormOne() {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formOneKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Social App',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge!.fontSize),
                ),
                const SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((password) => password != null &&
                                    password.length < 6
                                ? 'Password must be at least be 6 characters'
                                : null),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.align_horizontal_right_sharp),
                  label: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (_formOneKey.currentState!.validate()) {
                      setState(() {
                        _index = 1;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4))),
                          backgroundColor: Colors.red,
                          content: Text(
                            'Input Error... Please check the Email and Password provided',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => context.router.pushNamed('/login'),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerFormTwo() {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > 830
          ? buildWebRegisterFormTwo()
          : buildMobileRegisterFormTwo();
    });
  }

  /// Second register Step(Profile Image, Profile Name, Profile Username)
  Widget buildWebRegisterFormTwo() {
    return Form(
      key: _formOneKey,
      child: Row(
        children: [
          Container(
            width: mobileScreenSize as double,
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                color: navServerBar),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: imageBytes != null
                        ? DecorationImage(
                            image: MemoryImage(imageBytes!), fit: BoxFit.cover)
                        : const DecorationImage(
                            image: AssetImage('lib/assets/default.png'),
                            fit: BoxFit.cover),
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: TextButton(
                        child: const Text("Change profile picture"),
                        onPressed: () {
                          pickWebImage();
                        },
                      ),
                    )
                  ],
                ),
                // Web Name TextField
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((name) => name != null &&
                                    name.length < 3 &&
                                    name.length > 25
                                ? 'Name must be between 3 and 25 characters'
                                : null),
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                        ),
                      ]),
                ),
                // Web Username TextField
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: '@Username',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                          ),
                        ),
                      ]),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                      child: Text(
                          "Usernames are used to uniquly identify other users"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                /// Finish Account Setup ///////////////////////////////////////
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  icon: const Icon(Icons.align_horizontal_right_sharp),
                  label: const Text(
                    "Finish Account Setup",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    completeAccountSetup();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("User account was created")));
                    // Return AuthScreen (Login)
                    context.router.root.pushNamed('/');
                  },
                ),
              ],
            ),
          ),
          // Web Register Right Side Account Preview ///////////////////////////////
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Preview',
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 250,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                image: imageBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(imageBytes!),
                                        fit: BoxFit.cover)
                                    : const DecorationImage(
                                        image: AssetImage(
                                            'lib/assets/default.png'),
                                        fit: BoxFit.contain),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              nameController.text.isEmpty ? 'Name' : name,
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .fontSize),
                            ),
                            Text(
                              usernameController.text.isEmpty
                                  ? '@username'
                                  : '@$username',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize),
                            ),
                            Text(
                              emailController.text,
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize),
                            ),
                            Text(
                              'Bio: ',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'version: 1',
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .fontSize,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Register Form Two
  buildMobileRegisterFormTwo() {
    return SingleChildScrollView(
      child: Form(
          key: _formTwoKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(emailController.text),
              Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: imageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(imageBytes!), fit: BoxFit.cover)
                      : imageGal != null
                          ? DecorationImage(
                              image: FileImage(imageGal!), fit: BoxFit.cover)
                          : const DecorationImage(
                              image: AssetImage('lib/assets/default.png'),
                              fit: BoxFit.contain),
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: TextButton(
                      child: const Text("Change profile picture"),
                      onPressed: () async {
                        pickMobileImage();
                      },
                    ),
                  )
                ],
              ),
              // Mobile Name TextField
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ((name) => name != null &&
                                  name.length < 3 &&
                                  name.length > 25
                              ? 'Name must be between 3 and 25 characters'
                              : null),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              nameController.text = value;
                            });
                          },
                        ),
                      ),
                    ]),
              ),
              // Mobile Username TextField
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: '@Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                    child: Text(
                        "Usernames are used to uniquly identify other users"),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.align_horizontal_right_sharp),
                label: const Text(
                  "Finish Account Setup",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  completeAccountSetup();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User is Signed In")));
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          )),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Completes the Account Setup Process //////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  Future<void> completeAccountSetup() async {
    // Validate that data isNotEmpty and that the username is not taken
    //final isValid = accountSetUpFormKey.currentState!.validate();
    //if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await AuthServices().registerUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          username: usernameController.text,
          imageFile: imageGal,
          imageBytes: imageBytes);
      // Logout after account has been created
      await FirebaseAuth.instance.signOut();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
