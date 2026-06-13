class ChallengeSubcatMaster {
  int? local_id;
  String? challenges_sub_cat_id;
  String? challenges_cat_id;
  String? challenges_sub_cat_name;
  String? lang_id;
  String? status;
  String? challenges_sub_cat_code; // ✅ New key

  ChallengeSubcatMaster({
    this.local_id,
    this.challenges_sub_cat_id,
    this.challenges_cat_id,
    this.challenges_sub_cat_name,
    this.lang_id,
    this.status,
    this.challenges_sub_cat_code, // ✅ include in constructor
  });

  static const String tableName = "challenge_sub_cat_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnChallengeSubCatId = "challenges_sub_cat_id";
  static const String columnCatId = "challenges_cat_id";
  static const String columnChallengeSubCatName = "challenges_sub_cat_name";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnChallengeSubCatCode = "challenges_sub_cat_code"; // ✅ new column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnChallengeSubCatId TEXT, "
      "$columnCatId TEXT, "
      "$columnChallengeSubCatName TEXT, "
      "$columnLangId TEXT, "
      "$columnChallengeSubCatCode TEXT, " // ✅ added
      "$columnStatus TEXT"
      ")";

  // Convert from Map
  factory ChallengeSubcatMaster.fromMap(Map<String, dynamic> json) {
    return ChallengeSubcatMaster(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      challenges_sub_cat_id: json[columnChallengeSubCatId] ?? "",
      challenges_cat_id: json[columnCatId] ?? "",
      challenges_sub_cat_name: json[columnChallengeSubCatName] ?? "",
      lang_id: json[columnLangId] ?? "",
      challenges_sub_cat_code: json[columnChallengeSubCatCode] ?? "", // ✅ added
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnChallengeSubCatId: challenges_sub_cat_id,
      columnCatId: challenges_cat_id,
      columnChallengeSubCatName: challenges_sub_cat_name,
      columnLangId: lang_id,
      columnChallengeSubCatCode: challenges_sub_cat_code, // ✅ added
      columnStatus: status,
    };
  }
}
