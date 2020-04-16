import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

Database db;
String tableUser = "user",
    tableProfile = "profile",
    tableAttendance = "attendance";

// final String tableName = "todom";
// final String Column_id = "id";
// final String Column_name = "name";

Future<void> _createDb(Database db, int newVersion) async {
  Batch batch = db.batch();
  batch.execute(
      "CREATE TABLE $tableUser(username TEXT PRIMARY KEY, password TEXT)");
  batch.execute(
      "CREATE TABLE $tableProfile(name TEXT PRIMARY KEY, address TEXT, address_1 TEXT, caste TEXT, course TEXT, dob TEXT, institute TEXT, passOutYear TEXT, phone TEXT, gender TEXT, previousQualification TEXT, religion TEXT, url TEXT)");
  batch.execute(
      "CREATE TABLE $tableAttendance(subject TEXT PRIMARY KEY, total TEXT, attended TEXT, percentage TEXT)");
  List<dynamic> res = await batch.commit();

//Insert your controls
}

class User {
  String username, password;

  User(this.username, this.password);

  User.fromDb(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toMap() {
    return {"username": this.username, "password": this.password};
  }
}

class UserDb {
  UserDb() {
    initDatabase();
  }

  Future<int> count() async {
    await initDatabase();
    print("inside userdb count");
    final List<Map<String, dynamic>> _count = await db.query(tableUser);
    print(_count);
    print(_count.length);
    return _count.length;
  }

  Future<void> delete() async {
    print("inside delte task");
    await db.execute("DELETE FROM $tableUser");
    // await db.execute("DELETE FROM sqlite_sequence WHERE name = '$tableUser'");
    await db.execute("DELETE FROM $tableProfile");
    // await db
    //     .execute("DELETE FROM sqlite_sequence WHERE name = '$tableProfile'");
    await db.execute("DELETE FROM $tableAttendance");
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (db, version) async {
      await _createDb(db, version);
    }, version: 1);
  }

  Future<void> insert(User task) async {
    print("inside inserttask of user---------------------");
    try {
      db.insert(tableUser, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("insertion of user successful------------------");
    } catch (_) {
      print(_);
    }
  }

  Future<User> getAll() async {
    print("inside getalltask of user");
    final List<Map<String, dynamic>> tasks = await db.query(tableUser);
    print("userDb----------------------");
    print(tasks);
    return User.fromDb(tasks[0]);
  }
}

class Parent {
  String mobile, name, occupation;

  Parent.fromJson(Map<String, dynamic> _json) {
    name = _json['name'];
    mobile = _json['mobile'];
    occupation = _json['occupation'];
  }
}

class Profile {
  String name,
      address,
      address_1,
      caste,
      course,
      dob,
      institute,
      passOutYear,
      phone,
      previousQualification,
      religion,
      gender,
      url;

  Parent father, mother;
  Profile(this.name);
  Profile.fromJson(Map<String, dynamic> json) {
    name = json['Name '];
    address = json['Address'];
    address_1 = json['Address 1'];
    caste = json['Caste'];
    course = json['Course'];
    dob = json['Date Of Birth'];
    institute = json['Institute'];
    passOutYear = json['Pass Out year'];
    phone = json['Phone'];
    gender = json['gender'];
    previousQualification = json['Previous Qualification'];
    religion = json['Religion'];
    url = json['url'];
    father = Parent.fromJson(json['father']);
    mother = Parent.fromJson(json['mother']);
  }

  Profile.fromDb(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    address_1 = json['address_1'];
    caste = json['caste'];
    course = json['course'];
    dob = json['dob'];
    institute = json['institute'];
    passOutYear = json['passOutYear'];
    phone = json['phone'];
    gender = json['gender'];
    previousQualification = json['previousQualification'];
    religion = json['religion'];
    url = json['url'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "address": this.address,
      "address_1": this.address_1,
      "caste": this.caste,
      "course": this.course,
      "dob": this.dob,
      "institute": this.institute,
      "passOutYear": this.passOutYear,
      "phone": this.phone,
      "gender": this.gender,
      "previousQualification": this.previousQualification,
      "religion": this.religion,
      "url": this.url
    };
  }
}

class ProfileDb {
  ProfileDb() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (db, version) async {
      await _createDb(db, version);
    }, version: 1);
  }

  Future<void> insert(Profile task) async {
    print("inserting profile to db------------------------");
    try {
      db.insert(tableProfile, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("profile successflly inserted to db-------------");
    } catch (_) {
      print(_);
    }
  }

  Future<Profile> getAll() async {
    print("\n\ninside getalltask");
    final List<Map<String, dynamic>> tasks = await db.query(tableProfile);
    print("profileDb--------------------------");
    print(tasks);
    return Profile.fromDb(tasks[0]);
  }
}

class Attendance {
  String subject, total, attended, percentage;

  Attendance(this.subject, this.total, this.attended, this.percentage);

  Attendance.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    total = json['total'];
    attended = json['attended'];
    percentage = json['percentage'];
  }

  Attendance.fromDb(Map<String, dynamic> json) {
    subject = json['subject'];
    total = json['total'];
    attended = json['attended'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toMap() {
    return {
      "subject": this.subject,
      "total": this.total,
      "attended": this.attended,
      "percentage": this.percentage
    };
  }
}

class AttendanceDb {
  AttendanceDb() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (db, version) async {
      await _createDb(db, version);
    }, version: 1);
  }

  Future<void> insert(Attendance task) async {
    print("inserting attendance to db------------------------");
    try {
      db.insert(tableAttendance, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("attendance successflly inserted to db-------------");
    } catch (_) {
      print(_);
    }
  }

  Future<List<Attendance>> getAll() async {
    print("\n\ninside getalltask");
    final List<Map<String, dynamic>> tasks = await db.query(tableAttendance);
    print("AttendanceDb--------------------------");
    print(tasks);
    int count = tasks.length;
    List<Attendance> attendanceList = List<Attendance>();
    for (int i = 0; i < count; i++) {
      attendanceList.add(Attendance.fromDb(tasks[i]));
    }
    print("List of Attendance");
    print(attendanceList);
    return attendanceList;
  }
}

// class TaskModel {
//   final String name;
//   int id;

//   TaskModel({this.name, this.id});

//   Map<String, dynamic> toMap() {
//     return {Column_name: this.name};
//   }
// }

// class TodoHelper {
//   TodoHelper() {
//     initDatabase();
//   }

//   Future<void> initDatabase() async {
//     db = await openDatabase(join(await getDatabasesPath(), "database.db"),
//         onCreate: (db, version) {
//       return db.execute(
//           "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_name TEXT)");
//     }, version: 1);
//   }

//   Future<void> insertTask(TaskModel task) async {
//     try {
//       db.insert(tableName, task.toMap(),
//           conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (_) {
//       print(_);
//     }
//   }

//   Future<List<TaskModel>> getAllTask() async {
//     final List<Map<String, dynamic>> tasks = await db.query(tableName);

//     return List.generate(tasks.length, (i) {
//       return TaskModel(name: tasks[i][Column_name], id: tasks[i][Column_id]);
//     });
//   }

//   Future<void> deleteTask() async {
//     await db.execute("DELETE FROM $tableName");
//     await db.execute("DELETE FROM sqlite_sequence WHERE name = '$tableName'");
//   }
// }
