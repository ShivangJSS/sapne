class CategoryList {
  int? local_id;
  String? asp_cat_id;
  String? asp_name;
  String? asp_photo;
  String? lang_id;
  String? key_word;
  int? status;
  String? asp_cat_code; // ✅ New key added

  CategoryList({
    this.local_id,
    this.asp_cat_id,
    this.asp_name,
    this.asp_photo,
    this.lang_id,
    this.key_word,
    this.status,
    this.asp_cat_code, // ✅ include in constructor
  });

  static const String tableName = "category_list";

  // Columns
  static const String ColumnLocalId = "local_id";
  static const String columnId = "asp_cat_id";
  static const String columnAspName = "asp_name";
  static const String columnAspPhoto = "asp_photo";
  static const String columnAspLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnkey_word = "key_word";
  static const String columnAspCatCode = "asp_cat_code"; // ✅ new column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnId TEXT, "
      "$columnAspName TEXT, "
      "$columnAspPhoto TEXT, "
      "$columnAspLangId TEXT, "
      "$columnkey_word TEXT, "
      "$columnAspCatCode TEXT, " // ✅ include in table
      "$columnStatus TEXT "
      ")";

  // Convert from Map
  factory CategoryList.fromMap(Map<String, dynamic> json) {
    return CategoryList(
      local_id: json[ColumnLocalId] != null ? int.tryParse(json[ColumnLocalId].toString()) : null,
      asp_cat_id: json[columnId] ?? "",
      asp_name: json[columnAspName] ?? "",
      asp_photo: json[columnAspPhoto] ?? "",
      lang_id: json[columnAspLangId] ?? "",
      key_word: json[columnkey_word] ?? "",
      asp_cat_code: json[columnAspCatCode] ?? "", // ✅ added
      status: json[columnStatus] is int ? json[columnStatus] : int.tryParse(json[columnStatus]?.toString() ?? "0"),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnLocalId: local_id,
      columnId: asp_cat_id,
      columnAspName: asp_name,
      columnAspPhoto: asp_photo,
      columnAspLangId: lang_id,
      columnkey_word: key_word,
      columnAspCatCode: asp_cat_code, // ✅ added
      columnStatus: status,
    };
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "asp_cat_id": asp_cat_id,
      "asp_name": asp_name,
      "asp_photo": asp_photo,
      "lang_id": lang_id,
      "key_word": key_word,
      "asp_cat_code": asp_cat_code, // ✅ added
      "status": status,
    };
  }
}
