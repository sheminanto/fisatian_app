import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../TaskModel.dart';

class HomePage extends StatefulWidget with NavigationStates {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<HomePage> {
  UserDb userDb = UserDb();
  User user;
  bool flag;
  bool flagSlider = false;
  double _progress = 95;

  Future<List<Attendance>> lala;
  List<Attendance> mylist;
  AttendanceDb attendanceDb = AttendanceDb();

  Future<List<Attendance>> fetchNotes() async {
    user = await userDb.getAll();
    mylist = await attendanceDb.getAll();
    flag = true;

    String url = "http://fisatian1.herokuapp.com/user";
    var headers = {"Accept": "application/json"};
    var body = {'username': user.username, 'password': user.password};

    final http.Response response =
        await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("staus code 200");

      var _json = json.decode(response.body);

      print(_json);
      for (var item in _json) {
        Attendance user = Attendance.fromJson(item);
        await attendanceDb.insert(user);
      }
      return attendanceDb.getAll();
    } else {
      throw Exception("error occure while fetching profile from server");
    }
  }

  @override
  void initState() {
    setState(() {
      lala = fetchNotes();
    });

    super.initState();
  }

  mainContainer(List<Attendance> _myList, int index) {
    if (index == 0) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 10.0, left: 15.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Select Percentage",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              _slider(),
            ],
          ),
        ),
      );
    } else if (index > 0) {
      index -= 1;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _myList[index].subject,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Total Hours    : " + _myList[index].total,
              ),
              SizedBox(height: 5),
              Text(
                "Attended        : " + _myList[index].attended,
              ),
              SizedBox(height: 5),
              Text(
                "Percentage    : " + _myList[index].percentage,
              ),
              SizedBox(height: 5),
              _calculator(
                  _myList[index].total, _myList[index].attended, _progress),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Center(
          child: Text('Attendance',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: lala,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      mylist = snapshot.data;

                      if (flag == true) {
                        final snackBar =
                            SnackBar(content: Text("Updation Successfull !"));

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        });
                        flag = false;
                      }

                      return ListView.builder(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 15.0, right: 5.0),
                          itemCount: mylist.length + 1,
                          itemBuilder: (context, index) {
                            return mainContainer(mylist, index);
                          });
                    } else if (snapshot.hasError) {
                      if (flag == true) {
                        print("Error snapshot");
                        final snackBar =
                            SnackBar(content: Text("Updation Failed !"));

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        });
                        flag = false;
                      }

                      return ListView.builder(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 15.0, right: 5.0),
                          itemCount: mylist.length + 1,
                          itemBuilder: (context, index) {
                            return mainContainer(mylist, index);
                          });
                    }
                  }
                  return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lala = fetchNotes();
          });
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  _slider() {
    return Slider(
      value: _progress,
      divisions: 20,
      min: 75,
      max: 95,
      onChanged: (value) {
        setState(() {
          _progress = value.roundToDouble();
        });
      },
      label: '$_progress%',
    );
  }

  _calculator(var total, var attended, var _expectedPercent) {
    int b = int.parse(total);
    int a = int.parse(attended);
    double c = _expectedPercent;
    double percentage;
    double x = 0;

    if (b == 0) {
      return Text("--");
    } else {
      percentage = a * 100 / b;

      if (percentage < c) {
        x = (c * b - 100 * a) / (100 - c);
        x += 0.999999999;
        return Text("Hours Required To Get $c%  :  ${x.toInt()}");
      } else if (percentage > c) {
        x = ((100 * a) - (c * b)) / c;
        return Text("Hours You Can Bunk  :  ${x.toInt()}");
      } else {
        return Text("Hours Required To Get $c%  :  $x");
      }
    }
  }
}
