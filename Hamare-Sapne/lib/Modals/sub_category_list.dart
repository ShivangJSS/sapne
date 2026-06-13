class SubCategoryList {
  int? local_id;
  String? asp_sub_cat_id;
  String? asp_sub_category_name;
  String? asp_sub_category_images;
  String? lang_id;
  String? key_word;
  String? status;
  String? asp_sub_cat_code; // ✅ New key

  SubCategoryList({
    this.local_id,
    this.asp_sub_cat_id,
    this.asp_sub_category_name,
    this.asp_sub_category_images,
    this.lang_id,
    this.key_word,
    this.status,
    this.asp_sub_cat_code, // ✅ include in constructor
  });

  static const String tableName = "sub_category_list";

  // Columns
  static const String ColumnLocalId = "local_id";
  static const String columnSubCatId = "asp_sub_cat_id";
  static const String columnSubCatName = "asp_sub_category_name";
  static const String columnSubCatImage = "asp_sub_category_images";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnkey_word = "key_word";
  static const String columnSubCatCode = "asp_sub_cat_code"; // ✅ new column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnSubCatId TEXT, "
      "$columnSubCatName TEXT, "
      "$columnSubCatImage TEXT, "
      "$columnLangId TEXT, "
      "$columnkey_word TEXT, "
      "$columnSubCatCode TEXT, " // ✅ added
      "$columnStatus TEXT "
      ")";

  // Convert from Map
  factory SubCategoryList.fromMap(Map<String, dynamic> json) {
    return SubCategoryList(
      local_id: json[ColumnLocalId] != null ? int.tryParse(json[ColumnLocalId].toString()) : null,
      asp_sub_cat_id: json[columnSubCatId] ?? "",
      asp_sub_category_name: json[columnSubCatName] ?? "",
      asp_sub_category_images: json[columnSubCatImage] ?? "",
      lang_id: json[columnLangId] ?? "",
      key_word: json[columnkey_word] ?? "",
      asp_sub_cat_code: json[columnSubCatCode] ?? "", // ✅ added
      status: json[columnStatus] ?? "",
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnLocalId: local_id,
      columnSubCatId: asp_sub_cat_id,
      columnSubCatName: asp_sub_category_name,
      columnSubCatImage: asp_sub_category_images,
      columnLangId: lang_id,
      columnkey_word: key_word,
      columnSubCatCode: asp_sub_cat_code, // ✅ added
      columnStatus: status,
    };
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "asp_sub_cat_id": asp_sub_cat_id,
      "asp_sub_category_name": asp_sub_category_name,
      "asp_sub_category_images": asp_sub_category_images,
      "lang_id": lang_id,
      "key_word": key_word,
      "asp_sub_cat_code": asp_sub_cat_code, // ✅ added
      "status": status,
    };
  }
}
