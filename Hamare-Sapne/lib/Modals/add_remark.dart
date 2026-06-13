
class AddRmk {
  int? local_id;
  String? reamars_id;
  String? coachId;
  String? participantId;
  String? challengeCat;
  String? challengeSubCat;
  String? other_challenge_text;
  String? wayforwardCat;
  String? wayforwardSubCat;
  String? other_wayforward_sub_cat_text;
  String? latitude;
  String? longitude;
  String? mobileVersion;
  String? deviceName;
  String? appVersion;
  String? feedback_id;
  String? question_id;
  String? other_challenge_cat7;
  String? other_challenge_sub6;
  String? other_challenge_sub11;
  String? other_challenge_sub19;
  String? other_challenge_sub25;
  String? other_challenge_sub33;
  String? other_challenge_sub38;
  String? other_wayforward_cat8;
  String? other_wayforward_sub9;
  String? other_wayforward_sub17;
  String? other_wayforward_sub23;
  String? other_wayforward_sub29;
  String? other_wayforward_sub35;
  String? other_wayforward_sub40;
  String? other_wayforward_sub44;
  String? created_at;
  String? status;

  AddRmk({
    this.local_id,
    this.reamars_id,
    this.coachId,
    this.participantId,
    this.challengeCat,
    this.challengeSubCat,
    this.other_challenge_text,
    this.wayforwardCat,
    this.wayforwardSubCat,
    this.other_wayforward_sub_cat_text,
    this.latitude,
    this.longitude,
    this.mobileVersion,
    this.deviceName,
    this.appVersion,
    this.feedback_id,
    this.question_id,
    this.other_challenge_cat7,
    this.other_challenge_sub6,
    this.other_challenge_sub11,
    this.other_challenge_sub19,
    this.other_challenge_sub25,
    this.other_challenge_sub33,
    this.other_challenge_sub38,
    this.other_wayforward_cat8,
    this.other_wayforward_sub9,
    this.other_wayforward_sub17,
    this.other_wayforward_sub23,
    this.other_wayforward_sub29,
    this.other_wayforward_sub35,
    this.other_wayforward_sub40,
    this.other_wayforward_sub44,
    this.created_at,
    this.status,
  });

  // Table name
  static const String tableName = "remark";

  // Columns
  static const String columnLocalId = "local_id";
  static const String columnRemarkId = "reamars_id";
  static const String columnCoachId = "coach_id";
  static const String columnParticipantId = "participant_id";
  static const String columnChallengeCat = "challenge_cat";
  static const String columnChallengeSubCat = "challenge_sub_cat";
  static const String columnOtherChallengeText = "other_challenge_text";
  static const String columnWayFrowordCat = "wayforward_cat";
  static const String columnChlWayforwordSubCat = "wayforward_sub_cat";
  static const String columnOtherWayText = "other_wayforward_sub_cat_text";
  static const String columnLatitude = "latitude";
  static const String columnLongitude = "longitude";
  static const String columnMobileVersion = "mobile_version";
  static const String columnDeviceName = "device_name";
  static const String columnAppVersion = "app_version";
  static const String columnFeedbackId = "feedback_id";
  static const String columnQuestionId = "question_id";
  static const String columnOtherChallengeCat7 =  "other_challenge_cat7";
  static const String columnOtherChallengeSub6 = "other_challenge_sub6";
  static const String columnOtherChallengeSub11 = "other_challenge_sub11";
  static const String columnOtherChallengeSub19 = "other_challenge_sub19";
  static const String columnOtherChallengeSub25 =  "other_challenge_sub25";
  static const String columnOtherChallengeSub33 =  "other_challenge_sub33";
  static const String columnOtherChallengeSub38 = "other_challenge_sub38";
  static const String columnOtherWayForwardCat8 = "other_wayforward_cat8";
  static const String columnOtherWayForwardSub9 = "other_wayforward_sub9";
  static const String columnOtherWayForwardSub17 = "other_wayforward_sub17";
  static const String columnOtherWayForwardSub23 = "other_wayforward_sub23";
  static const String columnOtherWayForwardSub29 = "other_wayforward_sub29";
  static const String columnOtherWayForwardSub35 =  "other_wayforward_sub35";
  static const String columnOtherWayForwardSub40 = "other_wayforward_sub40";
  static const String columnOtherWayForwardSub44 = "other_wayforward_sub44";

  static const String columnCreatedAt = "created_at";
  static const String columnStatus = "status";

  // Table create query
  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnRemarkId TEXT,
      $columnCoachId TEXT,
      $columnParticipantId TEXT,
      $columnChallengeCat TEXT,
      $columnChallengeSubCat TEXT,
      $columnOtherChallengeText TEXT,
      $columnWayFrowordCat TEXT,
      $columnChlWayforwordSubCat TEXT,
      $columnOtherWayText TEXT,
      $columnLatitude TEXT,
      $columnLongitude TEXT,
      $columnMobileVersion TEXT,
      $columnDeviceName TEXT,
      $columnAppVersion TEXT,
      $columnFeedbackId TEXT,
      $columnQuestionId TEXT,
      
       $columnOtherChallengeCat7 TEXT,
       $columnOtherChallengeSub6 TEXT,
       $columnOtherChallengeSub11 TEXT,
       $columnOtherChallengeSub19 TEXT,
       $columnOtherChallengeSub25 TEXT,
       $columnOtherChallengeSub33 TEXT,
       $columnOtherChallengeSub38 TEXT,
       $columnOtherWayForwardCat8 TEXT,
       $columnOtherWayForwardSub9 TEXT,
       $columnOtherWayForwardSub17 TEXT,
       $columnOtherWayForwardSub23 TEXT,
       $columnOtherWayForwardSub29 TEXT,
       $columnOtherWayForwardSub35 TEXT,
       $columnOtherWayForwardSub40 TEXT,
       $columnOtherWayForwardSub44 TEXT,
      
      $columnCreatedAt TEXT,
      $columnStatus TEXT
    )
  ''';

  // Convert from Map
  factory AddRmk.fromMap(Map<String, dynamic> map) {
    return AddRmk(
      local_id: map['local_id'],
      reamars_id: map['reamars_id'],
      coachId: map['coach_id'],
      participantId: map['participant_id'],
      challengeCat: map['challenge_cat'],
      challengeSubCat: map['challenge_sub_cat'],
      other_challenge_text: map['other_challenge_text'],
      wayforwardCat: map['wayforward_cat'],
      wayforwardSubCat: map['wayforward_sub_cat'],
      other_wayforward_sub_cat_text: map['other_wayforward_sub_cat_text'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      mobileVersion: map['mobile_version'],
      deviceName: map['device_name'],
      appVersion: map['app_version'],
      feedback_id: map['feedback_id'],
      created_at: map['created_at'],

      other_challenge_cat7: map['other_challenge_cat7'],
      other_challenge_sub6: map['other_challenge_sub6'],
      other_challenge_sub11: map['other_challenge_sub11'],
      other_challenge_sub19: map['other_challenge_sub19'],
    other_challenge_sub25: map['other_challenge_sub25'],
    other_challenge_sub33:map['other_challenge_sub33'],
      other_challenge_sub38:map['other_challenge_sub38'],

      // Way forward other reasons
      other_wayforward_cat8: map['other_wayforward_cat8'],
       other_wayforward_sub9:map['other_wayforward_sub9'],
    other_wayforward_sub17:map['other_wayforward_sub17'],
    other_wayforward_sub23:map['other_wayforward_sub23'],
      other_wayforward_sub29:map['other_wayforward_sub29'],
      other_wayforward_sub35:map['other_wayforward_sub35'],
      other_wayforward_sub40:map['other_wayforward_sub40'],
    other_wayforward_sub44:map['other_wayforward_sub44'],

      question_id: map['question_id'],
      status: map['status'],
    );
  }
  // to json
  Map<String, dynamic> toMap() {
    return {
      'local_id': local_id,
      'reamars_id': reamars_id,
      'coach_id': coachId,
      'participant_id': participantId,
      'challenge_cat': challengeCat,
      'challenge_sub_cat': challengeSubCat,
      'other_challenge_text': other_challenge_text,
      'wayforward_cat': wayforwardCat,
      'wayforward_sub_cat': wayforwardSubCat,
      'other_wayforward_sub_cat_text': other_wayforward_sub_cat_text,
      'latitude': latitude,
      'longitude': longitude,
      'mobile_version': mobileVersion,
      'device_name': deviceName,
      'app_version': appVersion,
      'feedback_id': feedback_id,
      'question_id': question_id,
      'other_challenge_cat7': other_challenge_cat7,
      'other_challenge_sub6': other_challenge_sub6,
      'other_challenge_sub11': other_challenge_sub11,
      'other_challenge_sub19': other_challenge_sub19,
      'other_challenge_sub25': other_challenge_sub25,
      'other_challenge_sub33':other_challenge_sub33,
      'other_challenge_sub38':other_challenge_sub38,

      // Way forward other reasons
      'other_wayforward_cat8': other_wayforward_cat8,
      'other_wayforward_sub9':other_wayforward_sub9,
      'other_wayforward_sub17':other_wayforward_sub17,
      'other_wayforward_sub23':other_wayforward_sub23,
      'other_wayforward_sub29':other_wayforward_sub29,
      'other_wayforward_sub35':other_wayforward_sub35,
      'other_wayforward_sub40':other_wayforward_sub40,
      'other_wayforward_sub44':other_wayforward_sub44,


      'created_at': created_at,
      'status': status,
    };
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      "coach_id": coachId,
      "reamars_id": reamars_id,
      "participant_id": participantId,
      "challenge_cat": challengeCat,
      "challenge_sub_cat": challengeSubCat,
      "other_challenge_text": other_challenge_text,
      "wayforward_cat": wayforwardCat,
      "wayforward_sub_cat": wayforwardSubCat,
      "other_wayforward_sub_cat_text": other_wayforward_sub_cat_text,
      "latitude": latitude,
      "longitude": longitude,
      "mobile_version": mobileVersion,
      "device_name": deviceName,
      "app_version": appVersion,
      "feedback_id": feedback_id,
      "question_id": question_id,
      'other_challenge_cat7': other_challenge_cat7,
      'other_challenge_sub6': other_challenge_sub6,
      'other_challenge_sub11': other_challenge_sub11,
      'other_challenge_sub19': other_challenge_sub19,
      'other_challenge_sub25': other_challenge_sub25,
      'other_challenge_sub33':other_challenge_sub33,
      'other_challenge_sub38':other_challenge_sub38,
      'other_wayforward_cat8': other_wayforward_cat8,
      'other_wayforward_sub9':other_wayforward_sub9,
      'other_wayforward_sub17':other_wayforward_sub17,
      'other_wayforward_sub23':other_wayforward_sub23,
      'other_wayforward_sub29':other_wayforward_sub29,
      'other_wayforward_sub35':other_wayforward_sub35,
      'other_wayforward_sub40':other_wayforward_sub40,
      'other_wayforward_sub44':other_wayforward_sub44,
      "created_at": created_at,
      "status": status,
    };
  }

}
