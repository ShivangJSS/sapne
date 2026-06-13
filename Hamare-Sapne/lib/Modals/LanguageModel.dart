class LanguageModel {
  int? local_id;
  String? language_id;
  String? language_name;
  String? language_code;
  String? status;

  LanguageModel({
    this.local_id,
    this.language_id,
    this.language_name,
    this.language_code,
    this.status,
  });

  static const String tableName = "language";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnLanguageId = "language_id";
  static const String columnLanguageName = "language_name";
  static const String columnLanguageCode = "language_code";
  static const String columnStatus = "status";

  // Table create SQL
  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnLanguageId TEXT, "
      "$columnLanguageName TEXT, "
      "$columnLanguageCode TEXT, "
      "$columnStatus TEXT"
      ")";

  // Convert from Map
  factory LanguageModel.fromMap(Map<String, dynamic> json) {
    return LanguageModel(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      language_id: json[columnLanguageId] ?? "",
      language_name: json[columnLanguageName] ?? "",
      language_code: json[columnLanguageCode] ?? "",
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map (for DB)
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnLanguageId: language_id,
      columnLanguageName: language_name,
      columnLanguageCode: language_code,
      columnStatus: status,
    };
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "language_id": language_id,
      "language_name": language_name,
      "language_code": language_code,
      "status": status,
    };
  }
}
