import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDF4lga6yGbYdLXR_VlQKHEdnTSOPp4jJ8",
      appId: "1:65377742477:web:bb2d53af2efc9fec3d3cc4",
      //authDomain: "social-media-app-f7e66.firebaseapp.com",
      messagingSenderId: "65377742477",
      projectId: "social-media-app-f7e66",
      storageBucket: "social-media-app-f7e66.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Autorouter
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        //canvasColor: const Color.fromARGB(208, 113, 70, 55),
        //cardColor: const Color.fromARGB(208, 113, 70, 55),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 32, 32, 32),
        ),
      ),
      routerConfig: appRouter.config(),
    );
  }
}

// Intial App Controller (IF use is Signed In or not & IF user is has Internet Connection)
@RoutePage(name: 'auth')
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                context.router.root.pushNamed('/');
              } else {
                context.router.root.pushNamed('/main');
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text("System Error"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            }
            return MyApp();
          },
        ),
      ),
    );
  }
}
