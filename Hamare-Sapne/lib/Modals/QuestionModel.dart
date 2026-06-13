class QuestionModel {
  int? local_id;
  String? question_id;
  String? sub_category_id;
  String? question_name;
  String? lang_id;
  String? key_word;
  String? status;
  String? question_id_code; // ✅ New key

  QuestionModel({
    this.local_id,
    this.question_id,
    this.sub_category_id,
    this.question_name,
    this.lang_id,
    this.key_word,
    this.status,
    this.question_id_code, // ✅ include in constructor
  });

  static const String tableName = "question_list";

  // Columns
  static const String ColumnLocalId = "local_id";
  static const String columnQuestionId = "question_id";
  static const String columnSubCategoryId = "sub_category_id";
  static const String columnQuestionName = "question_name";
  static const String columnLangId = "lang_id";
  static const String columnKeyWord = "key_word";
  static const String columnStatus = "status";
  static const String columnQuestionIdCode = "question_id_code"; // ✅ new column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnQuestionId TEXT, "
      "$columnSubCategoryId TEXT, "
      "$columnQuestionName TEXT, "
      "$columnLangId TEXT, "
      "$columnKeyWord TEXT, "
      "$columnQuestionIdCode TEXT, " // ✅ added
      "$columnStatus TEXT "
      ")";

  // Convert from Map
  factory QuestionModel.fromMap(Map<String, dynamic> json) {
    return QuestionModel(
      local_id: json[ColumnLocalId] != null ? int.tryParse(json[ColumnLocalId].toString()) : null,
      question_id: json[columnQuestionId] ?? "",
      sub_category_id: json[columnSubCategoryId] ?? "",
      question_name: json[columnQuestionName] ?? "",
      lang_id: json[columnLangId] ?? "",
      key_word: json[columnKeyWord] ?? "",
      question_id_code: json[columnQuestionIdCode] ?? "", // ✅ added
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnLocalId: local_id,
      columnQuestionId: question_id,
      columnSubCategoryId: sub_category_id,
      columnQuestionName: question_name,
      columnLangId: lang_id,
      columnKeyWord: key_word,
      columnQuestionIdCode: question_id_code, // ✅ added
      columnStatus: status,
    };
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "question_id": question_id,
      "sub_category_id": sub_category_id,
      "question_name": question_name,
      "lang_id": lang_id,
      "key_word": key_word,
      "question_id_code": question_id_code, // ✅ added
      "status": status,
    };
  }
}
