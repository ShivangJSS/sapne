class WayforCatMaster {
  int? local_id;
  String? way_forward_cat_id;
  String? way_forward_cat_name;
  String? lang_id;
  String? status;
  String? way_forward_cat_code; // ✅ नया field जोड़ा गया

  WayforCatMaster({
    this.local_id,
    this.way_forward_cat_id,
    this.way_forward_cat_name,
    this.lang_id,
    this.status,
    this.way_forward_cat_code, // ✅ constructor में जोड़ा
  });

  static const String tableName = "wayfor_cat_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnWayforCatId = "way_forward_cat_id";
  static const String columnWayforCatName = "way_forward_cat_name";
  static const String columnLangId = "lang_id";
  static const String columnStatus = "status";
  static const String columnWayforCatCode = "way_forward_cat_code"; // ✅ नया column

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnWayforCatId TEXT, "
      "$columnWayforCatName TEXT, "
      "$columnLangId TEXT, "
      "$columnStatus TEXT, "
      "$columnWayforCatCode TEXT" // ✅ नया column add
      ")";

  // Convert from Map
  factory WayforCatMaster.fromMap(Map<String, dynamic> json) {
    return WayforCatMaster(
      local_id: json[columnLocalId] != null
          ? int.tryParse(json[columnLocalId].toString())
          : null,
      way_forward_cat_id: json[columnWayforCatId] ?? "",
      way_forward_cat_name: json[columnWayforCatName] ?? "",
      lang_id: json[columnLangId] ?? "",
      status: json[columnStatus] ?? "",
      way_forward_cat_code: json[columnWayforCatCode] ?? "", // ✅ नया field
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnWayforCatId: way_forward_cat_id,
      columnWayforCatName: way_forward_cat_name,
      columnLangId: lang_id,
      columnStatus: status,
      columnWayforCatCode: way_forward_cat_code, // ✅ नया field
    };
  }
}
