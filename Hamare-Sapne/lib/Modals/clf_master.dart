class ClfMaster {
  int? local_id;
  String? clf_id;
  String? state_lgd_code;
  String? district_lgd_code;
  String? block_lgd_code;
  String? region_name;
  String? clf_code;
  String? clf_name;
  String? clf_nic_code;
  String? lang_id;
  String? is_active;

  ClfMaster({
    this.local_id,
    this.clf_id,
    this.state_lgd_code,
    this.district_lgd_code,
    this.block_lgd_code,
    this.region_name,
    this.clf_code,
    this.clf_name,
    this.clf_nic_code,
    this.lang_id,
    this.is_active,
  });

  static const String tableName = "clf_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnClfId = "clf_id";
  static const String columnStateLgdCode = "state_lgd_code";
  static const String columnDistrictLgdCode = "district_lgd_code";
  static const String columnBlockLgdCode = "block_lgd_code";
  static const String columnRegionName = "region_name";
  static const String columnClfCode = "clf_code";
  static const String columnClfName = "clf_name";
  static const String columnClfNicCode = "clf_nic_code";
  static const String columnLangId = "lang_id";
  static const String columnIsActive = "is_active";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnClfId TEXT, "
      "$columnStateLgdCode TEXT, "
      "$columnDistrictLgdCode TEXT, "
      "$columnBlockLgdCode TEXT, "
      "$columnRegionName TEXT, "
      "$columnClfCode TEXT, "
      "$columnClfName TEXT, "
      "$columnClfNicCode TEXT, "
      "$columnLangId TEXT, "
      "$columnIsActive TEXT"
      ")";
  // Convert from Map
  factory ClfMaster.fromMap(Map<String, dynamic> json) {
    return ClfMaster(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      clf_id: json[columnClfId]?.toString(),
      state_lgd_code: json[columnStateLgdCode]?.toString(),
      district_lgd_code: json[columnDistrictLgdCode]?.toString(),
      block_lgd_code: json[columnBlockLgdCode]?.toString(),
      region_name: json[columnRegionName]?.toString(),
      clf_code: json[columnClfCode]?.toString(),
      clf_name: json[columnClfName]?.toString(),
      clf_nic_code: json[columnClfNicCode]?.toString(),
      lang_id: json[columnLangId]?.toString(),
      is_active: json[columnIsActive]?.toString(),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnClfId: clf_id,
      columnStateLgdCode: state_lgd_code,
      columnDistrictLgdCode: district_lgd_code,
      columnBlockLgdCode: block_lgd_code,
      columnRegionName: region_name,
      columnClfCode: clf_code,
      columnClfName: clf_name,
      columnClfNicCode: clf_nic_code,
      columnLangId: lang_id,
      columnIsActive: is_active,
    };
  }


}
