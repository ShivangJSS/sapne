class AspOption {
  int? local_id;
  String? option_id;
  String? question_id;
  String? option_name;
  String? lang_id;
  String? status;

  AspOption({
    this.local_id,
    this.option_id,
    this.question_id,
    this.option_name,
    this.lang_id,
    this.status,
  });

  static const String tableName = "asp_option";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnOptionId = "option_id";
  static const String columnQuestionId = "question_id";
  static const String columnOptionName = "option_name";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnOptionId TEXT, "
      "$columnQuestionId TEXT, "
      "$columnOptionName TEXT, "
      "$columnLangId TEXT, "
      "$columnStatus TEXT"
      ")";
  // Convert from Map
  factory AspOption.fromMap(Map<String, dynamic> json) {
    return AspOption(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      option_id: json[columnOptionId] ?? "",
      question_id: json[columnQuestionId] ?? "",
      option_name: json[columnOptionName] ?? "",
      lang_id: json[columnLangId] ?? "",
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnOptionId: option_id,
      columnQuestionId: question_id,
      columnOptionName: option_name,
      columnLangId: lang_id,
      columnStatus: status,
    };
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "option_id": option_id,
      "question_id": question_id,
      "option_name": option_name,
      "lang_id": lang_id,
      "status": status,
    };
  }

}
