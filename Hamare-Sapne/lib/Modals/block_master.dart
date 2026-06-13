
class BlockMaster {
  String? block_id;
  String? block_name;
  String? block_lgd_code;
  String? district_id;
  String? district_lgd_code;
  String? state_id;
  String? lang_id;
  String? state_lgd_code;
  String? status;

  BlockMaster({
    this.block_id,
    this.block_name,
    this.block_lgd_code,
    this.district_id,
    this.district_lgd_code,
    this.state_id,
    this.state_lgd_code,
    this.status,
    this.lang_id,
  });

  static const String tableName = "block_master";

// Columns
  static const String ColumnBlockId = "block_id";
  static const String ColumnBlockName = "block_name";
  static const String ColumnBlockLgdCode = "block_lgd_code";
  static const String ColumnDistrictId = "district_id";
  static const String columnDistrictLgdCode = "district_lgd_code";
  static const String columnStateId = "state_id";
  static const String columnStateLgdCode = "state_lgd_code";
  static const String columnStatus = "status";
  static const String columnlang_id = "lang_id";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$ColumnBlockId TEXT, "
      "$ColumnBlockName TEXT, "
      "$ColumnBlockLgdCode TEXT, "
      "$ColumnDistrictId TEXT, "
      "$columnStateId TEXT, "
      "$columnStateLgdCode TEXT, "
      "$columnDistrictLgdCode TEXT, "
      "$columnlang_id TEXT, "
      "$columnStatus TEXT "
      ")";

// Convert from Map
  factory BlockMaster.fromMap(Map<String, dynamic> json) {
    return BlockMaster(
      block_id: json[ColumnBlockId] ?? "",
      block_name: json[ColumnBlockName] ?? "",
      block_lgd_code: json[ColumnBlockLgdCode] ?? "",
      district_id: json[ColumnDistrictId] ?? "",
      state_id: json[columnStateId] ?? "",
      state_lgd_code: json[columnStateLgdCode] ?? "",
      district_lgd_code: json[columnDistrictLgdCode] ?? "",
      lang_id: json[columnlang_id] ?? "",
      status: json[columnStatus] ?? "",
    );
  }

// // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      ColumnDistrictId: district_id,
      ColumnBlockName: block_name,
      ColumnBlockId: block_id,
      ColumnBlockLgdCode: block_lgd_code,
      columnStateId: state_id,
      columnlang_id: lang_id,
      columnStateLgdCode: state_lgd_code,
      columnDistrictLgdCode: district_lgd_code,
      columnStatus: status,
    };
  }

}
