import 'package:flutter/material.dart';
import 'package:http_req/homePage.dart';
import 'sidebar/sidebar_layout.dart';
import 'TaskModel.dart';

String _initialroute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserDb userDb1 = UserDb();

  int count;
  // await Future.delayed(const Duration(milliseconds: 450));
  count = await userDb1.count();

  if (count > 0) {
    _initialroute = '/second';
  } else {
    _initialroute = '/first';
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),

      initialRoute: _initialroute,
      routes: <String, WidgetBuilder>{
        '/first': (context) => HomePage(),
        '/second': (context) => SideBarLayout(),
        // '/': (context) => InitialRoute(),
      },
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   UserDb userDb1 = UserDb();
//   await new Future.delayed(const Duration(seconds: 1));
//   int count = await userDb1.count();

//   String _initialroute = '/';
//   if (count > 0) {
//     _initialroute = 'second';
//   }

//   runApp(new MaterialApp(
//     debugShowCheckedModeBanner: false,
//     initialRoute: _initialroute,
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     routes: <String, WidgetBuilder>{
//       '/first': (context) => new HomePage(),
//       '/second': (context) => new SideBarLayout(),
//       '/': (context) => new InitialRoute(),
//     },
//   ));
// }

// UserDb user = UserDb();

// void main() async {
//   // Set default home.
//   Widget _defaultHome = HomePage();

//   // Get result of the login function.
//   int _result = await user.count();
//   if (_result > 0) {
//     _defaultHome = SideBarLayout();
//   }

//   // Run app!
//   runApp(MaterialApp(
//     title: 'App',
//     home: _defaultHome,
//     routes: <String, WidgetBuilder>{
//       // Set routes for using the Navigator.
//       '/home': (BuildContext context) => HomePage(),
//       '/second': (BuildContext context) => SideBarLayout()
//     },
//   ));
// }
