import 'package:flutter/material.dart';
import 'dart:async';
import 'TaskModel.dart';

class InitialRoute extends StatefulWidget {
  @override
  _InitialRouteState createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  Future<int> count;
  UserDb userDb = UserDb();

  @override
  void initState() {
    setState(() {
      count = userDb.count();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          // (count == null)
          //     ? Container(
          //         alignment: Alignment.center, child: CircularProgressIndicator())
          //     :

          FutureBuilder(
              future: count,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    int _count = snapshot.data;
                    if (_count > 0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/second');
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/first');
                      });
                    }
                  } else if (snapshot.hasError) {
                    print("snapshot has error in initialroute");
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, '/first');
                    });
                  }
                }
                return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }),
    );
  }
}
