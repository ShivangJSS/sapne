import 'package:trikal_up/Modals/village_list.dart';

class PanchayatList {
  int? local_id;
  String? gp_id;
  String? gp_name;
  String? gp_lgd_code;
  String? user_name;
  String? c_id;
  String? lang_id;
  List<VillageList> villages = [];

  PanchayatList({
    this.local_id,
    this.gp_id,
    this.gp_name,
    this.gp_lgd_code,
    this.user_name,
    this.c_id,
    this.lang_id,
  });

  static const String tableName = "panchayat_list";

  // Columns
  static const String ColumnLocalId = "local_id";
  static const String columnGpId = "gp_id";
  static const String columnGpName = "gp_name";
  static const String columnGpLgdCode = "gp_lgd_code";
  static const String columnUserName = "user_name";
  static const String columnCId = "c_id";
  static const String columnlang_id = "lang_id";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnGpId TEXT, "
      "$columnGpName TEXT, "
      "$columnGpLgdCode TEXT, "
      "$columnUserName TEXT, "
      "$columnlang_id TEXT, "
      "$columnCId TEXT "
      ")";

  // Convert from Map
  factory PanchayatList.fromMap(Map<String, dynamic> json) {
    return PanchayatList(
      local_id: json[ColumnLocalId] != null ? int.tryParse(json[ColumnLocalId].toString()) : null,
      gp_id: json[columnGpId] ?? "",
      gp_name: json[columnGpName] ?? "",
      gp_lgd_code: json[columnGpLgdCode] ?? "",
      user_name: json[columnUserName] ?? "",
      lang_id: json[columnlang_id] ?? "",
      c_id: json[columnCId] ?? "",
    );
  }

  // // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnLocalId: local_id,
      columnGpId: gp_id,
      columnGpName: gp_name,
      columnlang_id: lang_id,
      columnGpLgdCode: gp_lgd_code,
      columnUserName: user_name,
      columnCId: c_id,
    };
  }

  //
  // // Convert to JSON (for API)
  // Map<String, dynamic> toJson() {
  //   return {
  //     "local_id": local_id,
  //     "gp_id": gp_id,
  //     "gp_name": gp_name,
  //     "gp_lgd_code": gp_lgd_code,
  //     "user_name": user_name,
  //     "c_id": c_id,
  //   };
  // }
}
