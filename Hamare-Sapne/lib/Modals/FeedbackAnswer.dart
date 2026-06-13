/// 🔹 OptionValue model (हर question+answer के लिए)
class OptionValue {
  final String questionId;
  final String optionId;

  OptionValue({
    required this.questionId,
    required this.optionId,
  });

  Map<String, dynamic> toMap() {
    return {
      "question_id": questionId,
      "option_id": optionId,
    };
  }

  factory OptionValue.fromMap(Map<String, dynamic> map) {
    return OptionValue(
      questionId: map["question_id"] ?? "",
      optionId: map["option_id"] ?? "",
    );
  }
}

/// 🔹 FeedbackSubCategory model (subcategory level पर grouping)
class FeedbackSubCategory {
  final String feedbackId;
  final String coachId;
  final String participantId;
  final String aspSubCatId;
  final String aspCatId;
  final String month;
  final String latitude;
  final String longitude;
  final String mobileVersion;
  final String deviceName;
  final String appVersion;
  final String createdAt;
  final String jsonData;
  final String status;

  final List<OptionValue> optionValue; // ✅ multiple questions

  FeedbackSubCategory({
    required this.feedbackId,
    required this.coachId,
    required this.participantId,
    required this.aspSubCatId,
    required this.aspCatId,
    required this.month,
    required this.latitude,
    required this.longitude,
    required this.mobileVersion,
    required this.deviceName,
    required this.appVersion,
    required this.createdAt,
    required this.status,
    required this.jsonData,
    required this.optionValue,
  });

  Map<String, dynamic> toMap() {
    return {
      "feedback_id": feedbackId,
      "coach_id": coachId,
      "participant_id": participantId,
      "asp_sub_cat_id": aspSubCatId,
      "asp_cat_id": aspCatId,
      "month": month,
      "latitude": latitude,
      "longitude": longitude,
      "mobile_version": mobileVersion,
      "device_name": deviceName,
      "app_version": appVersion,
      "created_at": createdAt,
      "json_data": jsonData,
      "status": status,
      "option_value": optionValue.map((e) => e.toMap()).toList(),
    };
  }

  factory FeedbackSubCategory.fromMap(Map<String, dynamic> map) {
    return FeedbackSubCategory(
      feedbackId: map["feedback_id"] ?? "",
      coachId: map["coach_id"] ?? "",
      participantId: map["participant_id"] ?? "",
      aspSubCatId: map["asp_sub_cat_id"] ?? "",
      aspCatId: map["asp_cat_id"] ?? "",
      month: map["month"] ?? "",
      latitude: map["latitude"] ?? "",
      longitude: map["longitude"] ?? "",
      mobileVersion: map["mobile_version"] ?? "",
      deviceName: map["device_name"] ?? "",
      appVersion: map["app_version"] ?? "",
      createdAt: map["created_at"] ?? "",
      jsonData: map["json_data"] ?? "",
      status: map["status"] ?? "",
      optionValue: (map["option_value"] as List<dynamic>? ?? [])
          .map((e) => OptionValue.fromMap(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return "FeedbackSubCategory(feedbackId: $feedbackId, coachId: $coachId, participantId: $participantId, aspSubCatId: $aspSubCatId, aspCatId: $aspCatId, month: $month, latitude: $latitude, longitude: $longitude, mobileVersion: $mobileVersion, deviceName: $deviceName, appVersion: $appVersion, createdAt: $createdAt, status: $status, optionValue: $optionValue,jsonData: $jsonData)";
  }
}
