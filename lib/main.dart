import 'package:flutter/material.dart';
import 'package:social_app/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
          indicatorColor: const Color.fromARGB(255, 217, 25, 55),
          drawerTheme: const DrawerThemeData(
              backgroundColor: Color.fromARGB(255, 32, 32, 32)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 32, 32, 32),
              selectedItemColor: Color.fromARGB(255, 217, 25, 55)),
          primarySwatch: const MaterialColor(0xFFF71A3A, {
            50: Color.fromRGBO(217, 25, 55, .1),
            100: Color.fromRGBO(217, 25, 55, .2),
            200: Color.fromRGBO(217, 25, 55, .3),
            300: Color.fromRGBO(217, 25, 55, .4),
            400: Color.fromRGBO(217, 25, 55, .5),
            500: Color.fromRGBO(217, 25, 55, .6),
            600: Color.fromRGBO(217, 25, 55, .7),
            700: Color.fromRGBO(217, 25, 55, .8),
            800: Color.fromRGBO(217, 25, 55, .9),
            900: Color.fromRGBO(217, 25, 55, 1),
          })),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyHomePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
