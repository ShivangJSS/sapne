class Statemaster {
  int? local_id;
  String? project_name;
  String? state_lgd_code;
  String? lang_id;
  String? state_logo;

  Statemaster({
    this.local_id,
    this.project_name,
    this.state_lgd_code,
    this.lang_id,
    this.state_logo,
  });

  static const String tableName = "state_master";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnProjectName = "project_name";
  static const String columnStateLgdCode = "state_lgd_code";
  static const String columnLangId = "lang_id";
  static const String columnstate_logo = "state_logo";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnProjectName TEXT, "
      "$columnStateLgdCode TEXT, "
      "$columnstate_logo TEXT, "
      "$columnLangId TEXT "
      ")";

  // Convert from Map
  factory Statemaster.fromMap(Map<String, dynamic> json) {
    return Statemaster(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      project_name: json[columnProjectName]?.toString(),
      state_lgd_code: json[columnStateLgdCode]?.toString(),
      state_logo: json[columnstate_logo]?.toString(),
      lang_id: json[columnLangId]?.toString(),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnProjectName: project_name,
      columnStateLgdCode: state_lgd_code,
      columnstate_logo: state_logo,
      columnLangId: lang_id,
    };
  }

}
