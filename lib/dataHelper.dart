import 'dart:async';
import 'dart:io';

import 'package:ffitnessconceptsmember/model/userProfileModel.dart';
import 'package:ffitnessconceptsmember/model/weightModel.dart';
import 'package:ffitnessconceptsmember/model/monthlyWeightModel.dart';
import 'package:ffitnessconceptsmember/model/weightYearModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'globals.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "gym.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application


      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "gym.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }


    final theDb = openDatabase(path, version: 1, readOnly: false);
    return theDb;
  }

  Future<List<WeightYearModel>> getAllWeightYear() async {
    // Get a reference to the database
    final Database db = await database;

    // Query the table for All The Progress Months.
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("select MeasureYear from BodyWeight group by MeasureYear");

    // Convert the List<Map<String, dynamic> into a List<WeightYearModel>.
    return List.generate(maps.length, (i) {
      return WeightYearModel(
        measureYear: maps[i]['MeasureYear'],
      );
    });
  }

  Future<int> checkWeightExist({@required String measureDateTime}) async {
    // Get a reference to the database
    final Database db = await database;

    int countWeightRows = Sqflite.firstIntValue(await db.rawQuery(
        "select count(*) from BodyWeight where MeasureDateTime='$measureDateTime'"));

    return countWeightRows;
  }

  Future<void> insertWeightDate({@required WeightModel weightModel}) async {
    // Get a reference to the database
    final Database db = await database;
    await db.insert(
      weightTblSqlite,
      weightModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getNInsertUserProfile(UserProfileModel userProfileModel) async {
    final Database db = await database;
    return await db.insert(
      userProfileTblSqlite,
      userProfileModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateUserProfile(
      {@required UserProfileModel userProfileModel}) async {
    final Database db = await database;
    return await db.rawUpdate(
        'update UserProfile set MemberLoginID=?, MemberID=?, MemberName=?,MemberRegisterDate=?,MemberExpireDate=?,MemberTypeNo=?,MemberLevelNo=?,MemberLevelName=?,MemberPoint=?,Photo=? where MemberNo =? ;',
        [
          userProfileModel.memberLoginID,
          userProfileModel.memberID,
          userProfileModel.memberName,
          userProfileModel.memberRegisterDate,
          userProfileModel.memberExpireDate,
          userProfileModel.memberTypeNo,
          userProfileModel.memberLevelNo,
          userProfileModel.memberLevelName,
          userProfileModel.memberPoint,
          userProfileModel.photo,
          userProfileModel.memberNo
        ]);
  }

  Future<int> updateProfileImage(
      {@required String image, @required int memberNo}) async {
    final Database db = await database;
    return await db.rawUpdate(
        'update UserProfile set Photo=? where MemberNo =? ;',
        [image, memberNo]);
  }

  Future<UserProfileModel> getUserProfile() async {
    // Get a reference to the database
    final Database db = await database;

    // Query the table for All The Districts.
    final List<Map<String, dynamic>> maps = await db
        .query(userProfileTblSqlite, where: 'IsLogin=?', whereArgs: [1]);

    // Convert the List<Map<String, dynamic> into a List<District>.

    if (maps.length > 0) {
      return UserProfileModel(
        isLogin: maps[0]['IsLogin'],
        memberNo: maps[0]['MemberNo'],
        memberLoginID: maps[0]['MemberLoginID'],
        memberID: maps[0]['MemberID'],
        memberName: maps[0]['MemberName'],
        memberRegisterDate: maps[0]['MemberRegisterDate'],
        memberExpireDate: maps[0]['MemberExpireDate'],
        memberTypeNo: maps[0]['MemberTypeNo'],
        memberLevelNo: maps[0]['MemberLevelNo'],
        memberLevelName: maps[0]['MemberLevelName'],
        memberPoint: maps[0]['MemberPoint'],
        photo: maps[0]['Photo'],
      );
    } else {
      return UserProfileModel(
        isLogin: 0,
      );
    }
  }

  Future<int> deleteTable({@required String sqliteTableName}) async {
    final Database db = await database;
    //return await db.de
    return await db.delete(sqliteTableName);
  }

  Future<int> updateWeightData({@required WeightModel weightM}) async {
    final Database db = await database;
    return await db.update(weightTblSqlite, {'Weight': '${weightM.weight}'},
        where: 'MeasureDate = ?', whereArgs: [weightM.measureDateTime]);
  }

  Future<WeightModel> getCurrentWeightData() async {
    // Get a reference to the database
    final Database db = await database;

// Query the table for current weight
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from BodyWeight order by MeasureDateTime desc limit 1;');

    print("getCurrentWeightData map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.

    if (maps.length > 0) {
      return WeightModel(
        measureDateTime: maps[0]['MeasureDateTime'],
        weight: maps[0]['Weight'],
        measureMonth: maps[0]['MeasureMonth'],
        measureYear: maps[0]['MeasureYear'],
      );
    } else {
      return null;
    }
  }

  Future<WeightModel> getInitialWeightData() async {
    // Get a reference to the database
    final Database db = await database;
    WeightModel weightModel;
// Query the table for current weight
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from BodyWeight order by MeasureDateTime asc limit 1;');

    print("getInitialWeightData map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    if (maps.length > 0) {
      weightModel = WeightModel(
        measureDateTime: maps[0]['MeasureDateTime'],
        weight: maps[0]['Weight'],
        measureMonth: maps[0]['MeasureMonth'],
        measureYear: maps[0]['MeasureYear'],
      );
    }
    return weightModel;
  }

  /*Future<List<WeightModel>> getInitialWeightData() async {
    // Get a reference to the database
    final Database db = await database;

// Query the table for initial weight
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from BodyWeight order by MeasureDateTime asc limit 1;');

    print("getInitialWeightData map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return WeightModel(
        measureDateTime: maps[i]['MeasureDateTime'],
        weight: maps[i]['Weight'],
        measureMonth: maps[i]['MeasureMonth'],
        measureYear: maps[i]['MeasureYear'],
      );
    });
  }

  Future<List<MonthlyWeightModel>> getMonthlyWeightData(
      {@required String measureYear}) async {
    // Get a reference to the database
    final Database db = await database;

// Query the table for all The Monthly Weight Data.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select MeasureMonth,sum(Weight) as AverageWeight from BodyWeight where MeasureDateTime like '$measureYear%' group by MeasureMonth;");

    print("getDownloadedProjPhoto map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MonthlyWeightModel(
        measureMonth: maps[i]['MeasureMonth'],
        averageWeight: maps[i]['AverageWeight'],
      );
    });
  }*/

  /* Future<List<MonthlyWeightModel>> getMonthlyWeightData(
      {@required String measureYear}) async {
    // Get a reference to the database
    final Database db = await database;
    List<MonthlyWeightModel> a = [];
// Query the table for all The Monthly Weight Data.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select MeasureMonth,sum(Weight) as AverageWeight from BodyWeight where MeasureDateTime like '$measureYear%' group by MeasureMonth;");

    print("getDownloadedProjPhoto map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    maps.forEach((v) {
      print("for each $v");
      print("v mm is ${v['MeasureMonth']}");
      if (v['MeasureMonth'] == "1") {
        a[0] = MonthlyWeightModel(
          measureMonth: int.parse(v['MeasureMonth']),
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 2) {
        a[1] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }else if (v['MeasureMonth'] == 3) {
        a[2] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 4) {
        a[3] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 5) {
        a[4] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 6) {
        a[5] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 7) {
        a[6] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 8) {
        a[7] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 9) {
        a[8] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 10) {
        a[9] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 11) {
        a[10] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
      else if (v['MeasureMonth'] == 12) {
        a[11] = MonthlyWeightModel(
          measureMonth: v['MeasureMonth'],
          averageWeight: v['AverageWeight'],
        );
      }
    });
print("a is $a");
    return a;
  }*/

  Future<List<MonthlyWeightModel>> getMonthlyWeightData() async {
    // Get a reference to the database
    final Database db = await database;

// Query the table for all The Monthly Weight Data.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        //"select MeasureMonth,sum(Weight)/count(Weight) as AverageWeight from BodyWeight where MeasureDateTime like '2020%' group by MeasureMonth order by MeasureMonth desc;");
        "select MeasureYear , MeasureMonth, avg(Weight) AverageWeight from BodyWeight group by MeasureYear, MeasureMonth order by MeasureYear desc, MeasureMonth desc limit 12;");
    print("getMonthlyWeightData map is $maps");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MonthlyWeightModel(
        measureYear: maps[i]['MeasureYear'],
        measureMonth: maps[i]['MeasureMonth'],
        averageWeight: maps[i]['AverageWeight'],
      );
    });
  }

  Future close() async {
    final Database db = await database;
    db.close();
  }
}
