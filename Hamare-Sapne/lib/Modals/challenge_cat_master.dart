class ChallengeCatMaster {
  int? local_id;
  String? challenges_cat_id;
  String? challenges_cat_name;
  String? lang_id;
  String? status;
  String? challenges_cat_code; // ✅ New key

  ChallengeCatMaster({
    this.local_id,
    this.challenges_cat_id,
    this.challenges_cat_name,
    this.lang_id,
    this.status,
    this.challenges_cat_code, // ✅ include in constructor
  });

  static const String tableName = "challenge_cat_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnChallengeCatId = "challenges_cat_id";
  static const String columnChallengeCatName = "challenges_cat_name";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnChallengeCatCode = "challenges_cat_code"; // ✅ new column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnChallengeCatId TEXT, "
      "$columnChallengeCatName TEXT, "
      "$columnLangId TEXT, "
      "$columnChallengeCatCode TEXT, " // ✅ added
      "$columnStatus TEXT"
      ")";

  // Convert from Map
  factory ChallengeCatMaster.fromMap(Map<String, dynamic> json) {
    return ChallengeCatMaster(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      challenges_cat_id: json[columnChallengeCatId] ?? "",
      challenges_cat_name: json[columnChallengeCatName] ?? "",
      lang_id: json[columnLangId] ?? "",
      challenges_cat_code: json[columnChallengeCatCode] ?? "", // ✅ added
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnChallengeCatId: challenges_cat_id,
      columnChallengeCatName: challenges_cat_name,
      columnLangId: lang_id,
      columnChallengeCatCode: challenges_cat_code, // ✅ added
      columnStatus: status,
    };
  }
}
