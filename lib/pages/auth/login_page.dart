import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/constants/constants.dart';

@RoutePage(name: 'login')
class LoginPage extends StatefulWidget {
  final Function(bool?) onResult;
  const LoginPage({super.key, required this.onResult});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login Function
  Future logIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // Save Auth State in pref
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('authenticated', true);
      // Nav
      widget.onResult.call(true);
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > mobileScreenSize
          ? buildWebLoginPage()
          : buildMobileLoginPage();
    });
  }

  // Web LoginPage
  buildWebLoginPage() {
    return Scaffold(
        body: Row(
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
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  icon: const Icon(Icons.align_horizontal_right_sharp),
                  label: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    logIn();
                    context.router.pushNamed('/main');
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Account?"),
                  TextButton(
                    onPressed: () {
                      context.router.pushNamed('/register');
                    },
                    child: const Text(
                      "Signup",
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
                          'Social Media App',
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
                            'View, Chat, and Explore',
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
    ));
  }

  // Mobile LoginPage
  buildMobileLoginPage() {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    icon: const Icon(Icons.align_horizontal_right_sharp),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      logIn();
                      context.router.pushNamed('/main');
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No Account?"),
                    TextButton(
                      onPressed: () {
                        context.router.pushNamed('/register');
                      },
                      child: const Text(
                        "Signup",
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
}
