import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../TaskModel.dart';

class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<MyAccountsPage> {
  ProfileDb profileDb = ProfileDb();
  Future<Profile> user;

  @override
  void initState() {
    setState(() {
      user = profileDb.getAll();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return mainContainer(snapshot.data);
                } else if (snapshot.hasError) {
                  return Center(child: Text("error in snapshot"));
                }
              }
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }));
  }

  mainContainer(Profile userData) {
    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: GetClipper(),
        ),
        Positioned(
            width: 400.0,
            top: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(userData.url),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 30.0),
                Text(
                  userData.name,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 5.0),
                Text(
                  userData.course,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: new EdgeInsets.only(
                      left: 50, bottom: 30.0, right: 35.0, top: 10),
                  decoration: new BoxDecoration(color: Colors.white54),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new Card(
                        child: new Column(
                          children: <Widget>[
                            new Padding(
                              padding: new EdgeInsets.all(10.0),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "DOB  :  ${userData.dob}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Religion : ${userData.religion}  (${userData.caste})",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Gender  :  ${userData.gender}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Previous Qualification  :  ${userData.previousQualification}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Pass out year  :  ${userData.passOutYear}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Phone  :  ${userData.phone}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(05.0),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Address  :  ${userData.address_1}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Montserrat'),
                              ),
                            ),
                            SizedBox(height: 25),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3.0);
    path.lineTo(size.width + 500, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
