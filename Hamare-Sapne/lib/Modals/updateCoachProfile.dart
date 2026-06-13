
class UpdateCoachProfile {
  String? c_id;
  String? coach_name;
  String? name_of_husband_father;
  String? user_name;
  String? password;
  String? coach_id;
  String? gender;
  String? coach_dob;
  String? joining_date;
  String? state_lgd_code;
  String? district_lgd_code;
  String? gp_lgd_code;
  String? village_lgd_code;
  String? mobile_no;
  String? clf_id;
  String? total_partipant;
  String? name_of_bank;
  String? name_on_bank_account;
  String? branch;
  String? ifsc_code;
  String? passbook_image;
  String? coach_image;
  String? coach_active_inactive;
  String? coach_category_id;
  String? sub_category_id;
  String? role_id;
  String? is_reset;
  String? status;
  String? created_at;


  UpdateCoachProfile({
    this.c_id,
    this.coach_name,
    this.name_of_husband_father,
    this.user_name,
    this.password,
    this.coach_id,
    this.gender,
    this.coach_dob,
    this.joining_date,
    this.state_lgd_code,
    this.district_lgd_code,
    this.gp_lgd_code,
    this.village_lgd_code,
    this.mobile_no,
    this.clf_id,
    this.total_partipant,
    this.name_of_bank,
    this.name_on_bank_account,
    this.branch,
    this.ifsc_code,
    this.coach_image,
    this.passbook_image,
    this.coach_active_inactive,
    this.coach_category_id,
    this.sub_category_id,
    this.role_id,
    this.is_reset,
    this.status,
    this.created_at,
  });
  static const String tableName = "coach_profile";

  static const String columnCoachId = "c_id";
  static const String columnCoachName = "coach_name";
  static const String columnHusbandFatherName = "name_of_husband_father";
  static const String columnUserName = "user_name";
  static const String columnPassword = "password";
  static const String columnCoachUniqueId = "coach_id";
  static const String columnGender = "gender";
  static const String columnCoachDob = "coach_dob";
  static const String columnJoiningDate = "joining_date";
  static const String columnStateLgdCode = "state_lgd_code";
  static const String columnDistrictLgdCode = "district_lgd_code";
  static const String columnGpLgdCode = "gp_lgd_code";
  static const String columnVillageLgdCode = "village_lgd_code";
  static const String columnMobileNo = "mobile_no";
  static const String columnClfId = "clf_id";
  static const String columnTotalParticipant = "total_partipant";
  static const String columnBankName = "name_of_bank";
  static const String columnNameOnBank = "name_on_bank_account";
  static const String columnBranch = "branch";
  static const String columnIfscCode = "ifsc_code";
  static const String columnPassbookImage = "passbook_image";
  static const String columnCoachImage = "coach_image";
  static const String columnCoachActiveInactive = "coach_active_inactive";
  static const String columnCoachCategoryId = "coach_category_id";
  static const String columnSubCategoryId = "sub_category_id";
  static const String columnRoleId = "role_id";
  static const String columnIsReset = "is_reset";
  static const String columnStatus = "status";
  static const String columnCreatedAt = "created_at";

  static const String createTable = """
  CREATE TABLE $tableName (
    $columnCoachId TEXT,
    $columnCoachName TEXT,
    $columnHusbandFatherName TEXT,
    $columnUserName TEXT,
    $columnPassword TEXT,
    $columnCoachUniqueId TEXT,
    $columnGender TEXT,
    $columnCoachDob TEXT,
    $columnJoiningDate TEXT,
    $columnStateLgdCode TEXT,
    $columnDistrictLgdCode TEXT,
    $columnGpLgdCode TEXT,
    $columnVillageLgdCode TEXT,
    $columnMobileNo TEXT,
    $columnClfId TEXT,
    $columnTotalParticipant TEXT,
    $columnBankName TEXT,
    $columnNameOnBank TEXT,
    $columnBranch TEXT,
    $columnIfscCode TEXT,
    $columnPassbookImage TEXT,
    $columnCoachImage TEXT,
    $columnCoachActiveInactive TEXT,
    $columnCoachCategoryId TEXT,
    $columnSubCategoryId TEXT,
    $columnRoleId TEXT,
    $columnIsReset TEXT,
    $columnStatus TEXT,
    $columnCreatedAt TEXT
  )
""";


  // Convert from Map
  factory UpdateCoachProfile.fromMap(Map<String, dynamic> map) {
    return UpdateCoachProfile(
      c_id: map['c_id']?.toString(),
      coach_name: map['coach_name']?.toString(),
      name_of_husband_father: map['name_of_husband_father']?.toString(),
      user_name: map['user_name']?.toString(),
      password: map['password']?.toString(),
      coach_id: map['coach_id']?.toString(),
      gender: map['gender']?.toString(),
      coach_dob: map['coach_dob']?.toString(),
      joining_date: map['joining_date']?.toString(),
      state_lgd_code: map['state_lgd_code']?.toString(),
      district_lgd_code: map['district_lgd_code']?.toString(),
      gp_lgd_code: map['gp_lgd_code']?.toString(),
      village_lgd_code: map['village_lgd_code']?.toString(),
      mobile_no: map['mobile_no']?.toString(),
      clf_id: map['clf_id']?.toString(),
      total_partipant: map['total_partipant']?.toString(),
      name_of_bank: map['name_of_bank']?.toString(),
      name_on_bank_account: map['name_on_bank_account']?.toString(),
      branch: map['branch']?.toString(),
      ifsc_code: map['ifsc_code']?.toString(),
      passbook_image: map['passbook_image']?.toString(),
      coach_image: map['coach_image']?.toString(),
      coach_active_inactive: map['coach_active_inactive']?.toString(),
      coach_category_id: map['coach_category_id']?.toString(),
      sub_category_id: map['sub_category_id']?.toString(),
      role_id: map['role_id']?.toString(),
      is_reset: map['is_reset']?.toString(),
      status: map['status']?.toString(),
      created_at: map['created_at']?.toString(),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'c_id': c_id,
      'coach_name': coach_name,
      'name_of_husband_father': name_of_husband_father,
      'user_name': user_name,
      'password': password,
      'coach_id': coach_id,
      'gender': gender,
      'coach_dob': coach_dob,
      'joining_date': joining_date,
      'state_lgd_code': state_lgd_code,
      'district_lgd_code': district_lgd_code,
      'gp_lgd_code': gp_lgd_code,
      'village_lgd_code': village_lgd_code,
      'mobile_no': mobile_no,
      'clf_id': clf_id,
      'total_partipant': total_partipant,
      'name_of_bank': name_of_bank,
      'name_on_bank_account': name_on_bank_account,
      'branch': branch,
      'ifsc_code': ifsc_code,
      'passbook_image': passbook_image,
      'coach_image': coach_image,
      'coach_active_inactive': coach_active_inactive,
      'coach_category_id': coach_category_id,
      'sub_category_id': sub_category_id,
      'role_id': role_id,
      'is_reset': is_reset,
      'status': status,
      'created_at': created_at,
    };
  }

  // to Json
  Map<String, dynamic> toJson() {
    return {
      'c_id': c_id,
      'coach_name': coach_name,
      'name_of_husband_father': name_of_husband_father,
      'user_name': user_name,
      'password': password,
      'coach_id': coach_id,
      'gender': gender,
      'coach_dob': coach_dob,
      'joining_date': joining_date,
      'state_lgd_code': state_lgd_code,
      'district_lgd_code': district_lgd_code,
      'gp_lgd_code': gp_lgd_code,
      'village_lgd_code': village_lgd_code,
      'mobile_no': mobile_no,
      'clf_id': clf_id,
      'total_partipant': total_partipant,
      'name_of_bank': name_of_bank,
      'name_on_bank_account': name_on_bank_account,
      'branch': branch,
      'ifsc_code': ifsc_code,
      'passbook_image': passbook_image,
      'coach_image': coach_image,
      'coach_active_inactive': coach_active_inactive,
      'coach_category_id': coach_category_id,
      'sub_category_id': sub_category_id,
      'role_id': role_id,
      'is_reset': is_reset,
      'status': status,
      'created_at': created_at,
    };
  }

  // for update
  Map<String, dynamic> toMapForUpdate() {
    return {
      'c_id': c_id,
      'coach_name': coach_name,
      'name_of_husband_father': name_of_husband_father,
      'user_name': user_name,
      'password': password,
      'coach_id': coach_id,
      'gender': gender,
      'coach_dob': coach_dob,
      'joining_date': joining_date,
      'state_lgd_code': state_lgd_code,
      'district_lgd_code': district_lgd_code,
      'gp_lgd_code': gp_lgd_code,
      'village_lgd_code': village_lgd_code,
      'mobile_no': mobile_no,
      'clf_id': clf_id,
      'total_partipant': total_partipant,
      'name_of_bank': name_of_bank,
      'name_on_bank_account': name_on_bank_account,
      'branch': branch,
      'ifsc_code': ifsc_code,
      'passbook_image': passbook_image,
      'coach_image': coach_image,
      'coach_active_inactive': coach_active_inactive,
      'coach_category_id': coach_category_id,
      'sub_category_id': sub_category_id,
      'role_id': role_id,
      'is_reset': is_reset,
      'status': status,
      'created_at': created_at,
    };

}

}
