import 'dart:io';
import 'package:path/path.dart' as dbPath;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trikal_up/Modals/AspirationModel.dart';
import 'package:trikal_up/Modals/challenge_cat_master.dart';
import 'package:trikal_up/Modals/challenge_subcat_master.dart';
import 'package:trikal_up/Modals/clf_master.dart';
import 'package:trikal_up/Modals/panchayet_list.dart';
import 'package:trikal_up/Modals/sub_category_list.dart';
import 'package:trikal_up/Modals/updateCoachProfile.dart';
import 'package:trikal_up/Modals/village_list.dart';
import 'package:trikal_up/Modals/wayfor_cat_master.dart';
import 'package:trikal_up/Modals/wayfor_subcat_master.dart';

import '../Modals/FeedBackModel.dart';
import '../Modals/LanguageModel.dart';
import '../Modals/QuestionModel.dart';
import '../Modals/asp_option.dart';
import '../Modals/block_master.dart';
import '../Modals/district_master.dart';
import '../Modals/participant.dart';
import '../Modals/add_remark.dart';
import '../Modals/category_list.dart';
import '../Modals/stateMaster.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  static const String _dbName = "hs_db.db";
  static const int _dbVersion = 2;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = dbPath.join(documentsDirectory.path, _dbName);

    _database = await openDatabase(path, version: _dbVersion, onCreate: _onCreate,);
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Participant.createTable);
    await db.execute(CategoryList.createTable);
    await db.execute(SubCategoryList.createTable);
    await db.execute(PanchayatList.createTable);
    await db.execute(VillageList.createTable);
    await db.execute(QuestionModel.createTable);
    await db.execute(AspOption.createTable);
    await db.execute(AspirationModel.createTable);
    await db.execute(ChallengeCatMaster.createTable);
    await db.execute(ChallengeSubcatMaster.createTable);
    await db.execute(WayforCatMaster.createTable);
    await db.execute(WayforSubcatMaster.createTable);
    await db.execute(AddRmk.createTable);
    await db.execute(LanguageModel.createTable);
    await db.execute(FeedBackModel.createTable);
    await db.execute(ClfMaster.createTable);
    await db.execute(Statemaster.createTable);
    await db.execute(UpdateCoachProfile.createTable);
    await db.execute(DistrictMaster.createTable);
    await db.execute(BlockMaster.createTable);
  }


  Future<int> insertData(Map<String, dynamic> mapList, String table) async {
    Database db = await database;
    return await db.insert(table, mapList);
    // return res;
  }
  Future<List<UpdateCoachProfile>> getList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => UpdateCoachProfile.fromMap(f)).toList();
  }  Future<List<AddRmk>> getRemarkList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => AddRmk.fromMap(f)).toList();
  }
  Future<List<ClfMaster>> getCLFList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => ClfMaster.fromMap(f)).toList();
  }
  Future<List<SubCategoryList>> getSubList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => SubCategoryList.fromMap(f)).toList();
  } Future<List<QuestionModel>> getQuestionList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => QuestionModel.fromMap(f)).toList();
  }
  Future<List<AspirationModel>> getAsp(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => AspirationModel.fromMap(f)).toList();
  }
  Future<List<PanchayatList>> getPanchayatList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => PanchayatList.fromMap(f)).toList();
  }Future<List<DistrictMaster>> getDistrict(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => DistrictMaster.fromMap(f)).toList();
  }Future<List<BlockMaster>> getBlockList(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => BlockMaster.fromMap(f)).toList();
  }
  // Update Opration
  Future<int> updateData(Map<String, dynamic> mapList, String id) async {
    final db = await database;
    int res = await db.update(Participant.tableName, mapList, where: '${Participant.columnPId} = ?', whereArgs: [id],);
    return res;
  }
  Future<int> updateProfile(Map<String, dynamic> mapList, String id) async {
    final db = await database;
    int res = await db.update(UpdateCoachProfile.tableName, mapList, where: '${UpdateCoachProfile.columnCoachId} = ?', whereArgs: [id],);
    return res;
  }
  // Select Opration
  Future<List<T>> SelectData<T>(String query, T Function(Map<String, dynamic>) fromMap) async {
    final db = await database;
    final result = await db.rawQuery(query);
    return result.map((map) => fromMap(map)).toList();
  }

  // delete/update or any query
  Future<int> RunQuery(String query) async {
    final db = await database;
    return await db.rawUpdate(query);
  }

  // truncate table
  Future<void> truncateTable(String table) async {
    final db = await instance.database;
    await db.delete(table);
    await db.execute("VACUUM");
  }
// 🔹 Insert Feedback (return localId)
  Future<int> insertFeedback(FeedBackModel feedback) async {
    final db = await database;
    return await db.insert(
      FeedBackModel.tableName,
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<Map<String, dynamic>?> getRemarkByFeedbackId(String feedbackId, String QuestionId) async {
    final db = await database;

    final result = await db.query(
      AddRmk.tableName,
      columns: [
        AddRmk.columnLocalId,
        AddRmk.columnRemarkId,
        AddRmk.columnCoachId,
        AddRmk.columnParticipantId,
        AddRmk.columnChallengeCat,
        AddRmk.columnChallengeSubCat,
        AddRmk.columnOtherChallengeText,
        AddRmk.columnWayFrowordCat,
        AddRmk.columnChlWayforwordSubCat,
        AddRmk.columnOtherWayText,
        AddRmk.columnOtherChallengeSub6,
        AddRmk.columnOtherChallengeSub11,
        AddRmk.columnOtherChallengeSub19,
        AddRmk.columnOtherChallengeSub25,
        AddRmk.columnOtherChallengeSub33,
        AddRmk.columnOtherChallengeSub38,
        AddRmk.columnOtherWayForwardSub9,
        AddRmk.columnOtherWayForwardSub17,
        AddRmk.columnOtherWayForwardSub23,
        AddRmk.columnOtherWayForwardSub29,
        AddRmk.columnOtherWayForwardSub35,
        AddRmk.columnOtherWayForwardSub40,
        AddRmk.columnOtherWayForwardSub44,
        AddRmk.columnLatitude,
        AddRmk.columnLongitude,
        AddRmk.columnMobileVersion,
        AddRmk.columnDeviceName,
        AddRmk.columnAppVersion,
        AddRmk.columnFeedbackId,
        AddRmk.columnQuestionId,
        AddRmk.columnStatus,
      ],
      where: "${AddRmk.columnFeedbackId} = ? AND ${AddRmk.columnQuestionId} = ?",
      whereArgs: [feedbackId, QuestionId],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<String?> getProjectName(String stateLgdCode, String langId) async {
    final db = await database; // same instance pattern

    final result = await db.query(
      Statemaster.tableName,
      columns: [Statemaster.columnProjectName],
      where: "${Statemaster.columnStateLgdCode} = ? AND ${Statemaster.columnLangId} = ?",
      whereArgs: [stateLgdCode, langId],
    );

    if (result.isNotEmpty) {
      return result.first[Statemaster.columnProjectName] as String?;
    } else {
      return null;
    }
  }
  Future<String?> getProjectImage(String stateLgdCode, String langId) async {
    final db = await database; // same instance pattern

    final result = await db.query(
      Statemaster.tableName,
      columns: [Statemaster.columnstate_logo],
      where: "${Statemaster.columnStateLgdCode} = ? AND ${Statemaster.columnLangId} = ?",
      whereArgs: [stateLgdCode, langId],
    );

    if (result.isNotEmpty) {
      return result.first[Statemaster.columnstate_logo] as String?;
    } else {
      return null;
    }
  }

  Future<String?> getName(String stateLgdCode) async {
    final db = await database; // same instance pattern

    final result = await db.query(
      Statemaster.tableName,
      columns: [Statemaster.columnProjectName],
      where: "${Statemaster.columnStateLgdCode} = ? AND ${Statemaster.columnLangId} = ?",
      whereArgs: [stateLgdCode],
    );

    if (result.isNotEmpty) {
      return result.first[Statemaster.columnProjectName] as String?;
    } else {
      return null;
    }
  }
  Future<Map<String, int>> getFeedbackCounts() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT
      SUM(CASE WHEN option_id = '1' THEN 1 ELSE 0 END) AS pending_count,
      SUM(CASE WHEN option_id = '2' THEN 1 ELSE 0 END) AS partially_count,
      SUM(CASE WHEN option_id = '3' THEN 1 ELSE 0 END) AS completed_count
    FROM ${FeedBackModel.tableName}
  ''');

    if (result.isNotEmpty) {
      final row = result.first;
      return {
        "pending": row["pending_count"] as int? ?? 0,
        "partially": row["partially_count"] as int? ?? 0,
        "completed": row["completed_count"] as int? ?? 0,
      };
    }
    return {"pending": 0, "partially": 0, "completed": 0};
  }
  Future<List<Map<String, dynamic>>> getDataByCoachId(String coachId) async {
    final db = await database;
    final result = await db.query(
      'coach_profile',
      where: 'c_id = ?',
      whereArgs: [coachId],
    );
    return result;
  }

}
