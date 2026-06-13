class FeedBackModel {
  int? localId;
  String? feedbackId;
  String? coachId;
  String? participantId;
  String? aspSubCatId;
  String? aspCatId;
  String? aspirationId;   // 🔹 नया field
  String? questionId;
  String? optionId;
  String? month;
  String? latitude;
  String? longitude;
  String? mobileVersion;
  String? deviceName;
  String? appVersion;
  String? createdAt;
  String? jsonData;
  String? status;

  FeedBackModel({
    this.localId,
    this.feedbackId,
    this.coachId,
    this.participantId,
    this.aspSubCatId,
    this.aspCatId,
    this.aspirationId,   // 🔹 constructor में भी
    this.questionId,
    this.optionId,
    this.month,
    this.latitude,
    this.longitude,
    this.mobileVersion,
    this.deviceName,
    this.appVersion,
    this.createdAt,
    this.status,
    this.jsonData,
  });

  // Table name
  static const String tableName = "feedback";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnFeedbackId = "feedback_id";
  static const String columnCoachId = "coach_id";
  static const String columnParticipantId = "participant_id";
  static const String columnAspSubCatId = "asp_sub_cat_id";
  static const String columnAspCatId = "asp_cat_id";
  static const String columnAspirationId = "aspiration_id";  // 🔹 नया column
  static const String columnQuestionId = "question_id";
  static const String columnOptionId = "option_id";
  static const String columnMonth = "month";
  static const String columnLatitude = "latitude";
  static const String columnLongitude = "longitude";
  static const String columnMobileVersion = "mobile_version";
  static const String columnDeviceName = "device_name";
  static const String columnAppVersion = "app_version";
  static const String columnCreatedAt = "created_at";
  static const String columnStatus = "status";
  static const String columnJsonData = "json_data";

  // Create table query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnFeedbackId TEXT,
      $columnCoachId TEXT,
      $columnParticipantId TEXT,
      $columnAspSubCatId TEXT,
      $columnAspCatId TEXT,
      $columnAspirationId TEXT,   -- 🔹 नया field
      $columnQuestionId TEXT,
      $columnOptionId TEXT,
      $columnMonth TEXT,
      $columnLatitude TEXT,
      $columnLongitude TEXT,
      $columnMobileVersion TEXT,
      $columnDeviceName TEXT,
      $columnAppVersion TEXT,
      $columnCreatedAt TEXT,
      $columnJsonData TEXT,
      $columnStatus TEXT
    )
  ''';

  // ✅ From Map (DB → Object)
  factory FeedBackModel.fromMap(Map<String, dynamic> json) {
    return FeedBackModel(
      localId: json[columnLocalId], // 🔹 अब यह भी शामिल किया गया है
      feedbackId: json[columnFeedbackId],
      coachId: json[columnCoachId],
      participantId: json[columnParticipantId],
      aspSubCatId: json[columnAspSubCatId],
      aspCatId: json[columnAspCatId],
      aspirationId: json[columnAspirationId],   // 🔹 नया field
      questionId: json[columnQuestionId],
      optionId: json[columnOptionId],
      month: json[columnMonth],
      latitude: json[columnLatitude],
      longitude: json[columnLongitude],
      mobileVersion: json[columnMobileVersion],
      deviceName: json[columnDeviceName],
      appVersion: json[columnAppVersion],
      createdAt: json[columnCreatedAt],
      jsonData: json[columnJsonData],
      status: json[columnStatus],
    );
  }

  // ✅ To Map (Object → DB insert)
  Map<String, dynamic> toMap() {
    return {
      columnFeedbackId: feedbackId,
      columnCoachId: coachId,
      columnParticipantId: participantId,
      columnAspSubCatId: aspSubCatId,
      columnAspCatId: aspCatId,
      columnAspirationId: aspirationId,   // 🔹 नया field
      columnQuestionId: questionId,
      columnOptionId: optionId,
      columnMonth: month,
      columnLatitude: latitude,
      columnLongitude: longitude,
      columnMobileVersion: mobileVersion,
      columnDeviceName: deviceName,
      columnAppVersion: appVersion,
      columnCreatedAt: createdAt,
      columnJsonData: jsonData,
      columnStatus: status ?? "",
    };
  }

  // ✅ To JSON (for API payload)
  Map<String, dynamic> toJson() {
    return {
      "feedback_id": feedbackId,
      "coach_id": coachId,
      "participant_id": participantId,
      "asp_sub_cat_id": aspSubCatId,
      "asp_cat_id": aspCatId,
      "aspiration_id": aspirationId,   // 🔹 नया field
      "question_id": questionId,
      "option_id": optionId,
      "month": month,
      "latitude": latitude,
      "longitude": longitude,
      "mobile_version": mobileVersion,
      "device_name": deviceName,
      "app_version": appVersion,
      "created_at": createdAt,
      "json_data": jsonData,
      "status": status ?? "",
    };
  }
}
