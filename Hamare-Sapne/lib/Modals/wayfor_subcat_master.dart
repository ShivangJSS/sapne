class WayforSubcatMaster {
  int? local_id;
  String? way_forward_sub_cat_id;
  String? way_forward_cat_id;
  String? way_forward_sub_cat_name;
  String? lang_id;
  String? status;
  String? way_forward_sub_cat_code; // ✅ New field added

  WayforSubcatMaster({
    this.local_id,
    this.way_forward_sub_cat_id,
    this.way_forward_cat_id,
    this.way_forward_sub_cat_name,
    this.lang_id,
    this.status,
    this.way_forward_sub_cat_code, // ✅ Add in constructor
  });

  static const String tableName = "wayfor_sub_cat_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnWayforSubCatId = "way_forward_sub_cat_id";
  static const String columnWayforCatId = "way_forward_cat_id";
  static const String columnWayforSubCatName = "way_forward_sub_cat_name";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnWayforSubCatCode = "way_forward_sub_cat_code"; // ✅ New column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnWayforSubCatId TEXT, "
      "$columnWayforCatId TEXT, "
      "$columnWayforSubCatName TEXT, "
      "$columnLangId TEXT, "
      "$columnStatus TEXT, "
      "$columnWayforSubCatCode TEXT"   // ✅ Add new column
      ")";

  // Convert from Map
  factory WayforSubcatMaster.fromMap(Map<String, dynamic> json) {
    return WayforSubcatMaster(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      way_forward_sub_cat_id: json[columnWayforSubCatId] ?? "",
      way_forward_cat_id: json[columnWayforCatId] ?? "",
      way_forward_sub_cat_name: json[columnWayforSubCatName] ?? "",
      lang_id: json[columnLangId] ?? "",
      status: json[columnStatus] ?? "",
      way_forward_sub_cat_code: json[columnWayforSubCatCode] ?? "", // ✅ Add here
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnWayforSubCatId: way_forward_sub_cat_id,
      columnWayforCatId: way_forward_cat_id,
      columnWayforSubCatName: way_forward_sub_cat_name,
      columnLangId: lang_id,
      columnStatus: status,
      columnWayforSubCatCode: way_forward_sub_cat_code, // ✅ Add here
    };
  }
}
