class AspirationModel {
  int? local_id;
  String? asp_details_id;
  String? coach_id;
  String? participant_id;
  String? question_id;
  String? remarks;
  String? asp_cat_id;
  String? sub_cat_id;
  String? lang_id;
  String? duration;
  String? latitude;
  String? longitude;
  String? mobile_version;
  String? device_name;
  String? app_version;
  String? created_at;
  String? status;

  AspirationModel({
    this.local_id,
    this.asp_details_id,
    this.coach_id,
    this.participant_id,
    this.question_id,
    this.remarks,
    this.asp_cat_id,
    this.sub_cat_id,
    this.lang_id,
    this.duration,
    this.latitude,
    this.longitude,
    this.mobile_version,
    this.device_name,
    this.app_version,
    this.created_at,
    this.status,
  });

  static const String tableName = "aspiration";

  static const String columnLocalId = "local_id";
  static const String columnAspDetailsId = "asp_details_id";
  static const String columnCoachId = "coach_id";
  static const String columnParticipantId = "participant_id";
  static const String columnQuestionId = "question_id";
  static const String columnRemarks = "remarks";
  static const String columnAspCatId = "asp_cat_id";
  static const String columnSubCatId = "sub_cat_id";
  static const String columnLangId = "lang_id";
  static const String columnDuration = "duration";
  static const String columnLatitude = "latitude";
  static const String columnLongitude = "longitude";
  static const String columnMobileVersion = "mobile_version";
  static const String columnDeviceName = "device_name";
  static const String columnAppVersion = "app_version";
  static const String columnCreatedAt = "created_at";
  static const String columnStatus = "status";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnAspDetailsId TEXT, "
      "$columnCoachId TEXT, "
      "$columnParticipantId TEXT, "
      "$columnQuestionId TEXT, "
      "$columnRemarks TEXT, "
      "$columnAspCatId TEXT, "
      "$columnSubCatId TEXT, "
      "$columnLangId TEXT, "
      "$columnDuration TEXT, "
      "$columnLatitude TEXT, "
      "$columnLongitude TEXT, "
      "$columnMobileVersion TEXT, "
      "$columnDeviceName TEXT, "
      "$columnAppVersion TEXT, "
      "$columnCreatedAt TEXT, "
      "$columnStatus TEXT"
      ")";

  // From Map
  factory AspirationModel.fromMap(Map<String, dynamic> json) {
    return AspirationModel(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      asp_details_id: json[columnAspDetailsId],
      coach_id: json[columnCoachId],
      participant_id: json[columnParticipantId],
      question_id: json[columnQuestionId],
      remarks: json[columnRemarks],
      asp_cat_id: json[columnAspCatId],
      sub_cat_id: json[columnSubCatId],
      lang_id: json[columnLangId],
      duration: json[columnDuration],
      latitude: json[columnLatitude],
      longitude: json[columnLongitude],
      mobile_version: json[columnMobileVersion],
      device_name: json[columnDeviceName],
      app_version: json[columnAppVersion],
      created_at: json[columnCreatedAt],
      status: json[columnStatus],
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      columnLocalId: local_id,
      columnAspDetailsId: asp_details_id,
      columnCoachId: coach_id,
      columnParticipantId: participant_id,
      columnQuestionId: question_id,
      columnRemarks: remarks,
      columnAspCatId: asp_cat_id,
      columnSubCatId: sub_cat_id,
      columnLangId: lang_id,
      columnDuration: duration,
      columnLatitude: latitude,
      columnLongitude: longitude,
      columnMobileVersion: mobile_version,
      columnDeviceName: device_name,
      columnAppVersion: app_version,
      columnCreatedAt: created_at,
      columnStatus: status,
    };
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "asp_details_id": asp_details_id,
      "coach_id": coach_id,
      "participant_id": participant_id,
      "question_id": question_id,
      "remarks": remarks,
      "asp_cat_id": asp_cat_id,
      "sub_cat_id": sub_cat_id,
      "lang_id": lang_id,
      "duration": duration,
      "latitude": latitude,
      "longitude": longitude,
      "mobile_version": mobile_version,
      "device_name": device_name,
      "app_version": app_version,
      "created_at": created_at,
      "status": status,
    };
  }

  // To Map For Update
  Map<String, dynamic> toMapForUpdate() {
    return {
      columnAspDetailsId: asp_details_id,
      columnCoachId: coach_id,
      columnParticipantId: participant_id,
      columnQuestionId: question_id,
      columnRemarks: remarks,
      columnAspCatId: asp_cat_id,
      columnSubCatId: sub_cat_id,
      columnLangId: lang_id,
      columnDuration: duration,
      columnLatitude: latitude,
      columnLongitude: longitude,
      columnMobileVersion: mobile_version,
      columnDeviceName: device_name,
      columnAppVersion: app_version,
      columnCreatedAt: created_at,
      columnStatus: status,
    };
  }
}
