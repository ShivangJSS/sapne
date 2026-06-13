class VillageList {
  int? local_id;
  String? village_id;
  String? village_name;
  String? village_lgd_code;
  String? gp_lgd_code;
  String? c_id;
  String? coach_name;
  String? lang_id;

  VillageList({
    this.local_id,
    this.village_id,
    this.village_name,
    this.village_lgd_code,
    this.gp_lgd_code,
    this.c_id,
    this.coach_name,
    this.lang_id,
  });

  static const String tableName = "village_list";

  // Columns
  static const String ColumnLocalId = "local_id";
  static const String columnVillId = "village_id";
  static const String columnVillName = "village_name";
  static const String columnVillLgdCode = "village_lgd_code";
  static const String columnGpLgdCode = "gp_lgd_code";
  static const String columnCId = "c_id";
  static const String columnCoachName = "coach_name";
  static const String columnlang_id = "lang_id";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnVillId TEXT, "
      "$columnVillName TEXT, "
      "$columnVillLgdCode TEXT, "
      "$columnGpLgdCode TEXT, "
      "$columnCId TEXT, "
      "$columnlang_id TEXT, "
      "$columnCoachName TEXT "
      ")";

  // Convert from Map
  factory VillageList.fromMap(Map<String, dynamic> json) {
    return VillageList(
      local_id: json[ColumnLocalId] != null ? int.tryParse(json[ColumnLocalId].toString()) : null,
      village_id: json[columnVillId] ?? "",
      village_name: json[columnVillName] ?? "",
      village_lgd_code: json[columnVillLgdCode] ?? "",
      gp_lgd_code: json[columnGpLgdCode] ?? "",
      c_id: json[columnCId] ?? "",
      lang_id: json[columnlang_id] ?? "",
      coach_name: json[columnCoachName] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnLocalId: local_id,
      columnVillId: village_id,
      columnVillName: village_name,
      columnVillLgdCode: village_lgd_code,
      columnGpLgdCode: gp_lgd_code,
      columnCId: c_id,
      columnlang_id: lang_id,
      columnCoachName: coach_name,
    };
  }

//
  // // Convert to JSON (for API)
  // Map<String, dynamic> toJson() {
  //   return {
  //     "local_id": local_id,
  //     "village_id": village_id,
  //     "village_name": village_name,
  //     "village_lgd_code": village_lgd_code,
  //     "gp_lgd_code": gp_lgd_code,
  //     "c_id": c_id,
  //     "coach_name": coach_name,
  //   };
  // }
}
