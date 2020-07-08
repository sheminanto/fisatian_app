import 'package:flutter/material.dart';
import 'package:http_req/animations/fadeAnimation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TaskModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Profile> lala;
  UserDb userDb = UserDb();
  ProfileDb profileDb = ProfileDb();
  bool flag;

  Future<Profile> fetchNotes(String username, String password) async {
    username = username.trim();
    password = password.trim();
    flag = true;

    String url = "https://fisatian1.herokuapp.com/profile";
    var headers = {"Accept": "application/json"};
    var body = {'username': username, 'password': password};

    final http.Response response =
        await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("staus code 200");
      if (response.body != "false") {
        var _json = json.decode(response.body);

        await profileDb.insert(Profile.fromJson(_json));
        await userDb.insert(User(username, password));

        print("inserted to db");
        return Profile.fromJson(_json);
      } else {
        print("respone body is false");
        return Profile("error");
      }
    } else {
      throw Exception("error occure while fetching profile from server");
    }
  }

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  final GlobalKey<ScaffoldState> _scafkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scafkey,
        body: (lala == null)
            ? mainContainer()
            : FutureBuilder(
                future: lala,
                builder: (context, snapshot) {
                  Profile test1;

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      test1 = snapshot.data;
                      if (test1.name == "error") {
                        if (flag == true) {
                          final snackBar = SnackBar(
                              content: Text("Incorrect username and password"));

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Scaffold.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          });
                          flag = false;
                        }

                        return mainContainer();
                      } else {
                        userDb.getAll();
                        profileDb.getAll();
                        print("length of user db");
                        userDb.count();

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, '/second');
                        });
                      }
                    } else if (snapshot.hasError) {
                      print("shemin ---------- error snapshot");

                      if (flag == true) {
                        final snackBar =
                            SnackBar(content: Text("Network error !"));

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        });
                        flag = false;
                      }

                      print("${snapshot.error}");
                      return mainContainer();
                    }
                  } else {
                    return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  }
                  return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                },
              ));
  }

  mainContainer() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFFF206ffd),
          Color(0xFFF3280fb),
          Color(0xFFF28c3eb)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 90),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.2,
                      Text("FISATIAN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFf4f7fc),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        FadeAnimation(
                            1.6,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: controller1,
                                  decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            )),
                        SizedBox(height: 10),
                        FadeAnimation(
                            1.9,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: controller2,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            )),
                        SizedBox(height: 30),
                        FadeAnimation(
                            2,
                            Text("Forget your password?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFF3a6eff),
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 40),
                        FadeAnimation(
                            2.2,
                            GestureDetector(
                                onTap: () {
                                  if (controller1.text.isEmpty ||
                                      controller2.text.isEmpty) {
                                    _scafkey.currentState.showSnackBar(SnackBar(
                                      content: Text('Not possible !'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else {
                                    setState(() {
                                      lala = fetchNotes(
                                          controller1.text, controller2.text);
                                      controller1.clear();
                                      controller2.clear();
                                    });
                                  }
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFF206ffd),
                                            Color(0xFFF3280fb)
                                          ])),
                                  child: Center(
                                    child: Text("Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
