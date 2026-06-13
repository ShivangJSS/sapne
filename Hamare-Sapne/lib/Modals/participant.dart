import 'package:trikal_up/Modals/add_remark.dart';

class Participant {
  int? local_id;
  String? p_id;
  String? name_participant;
  String? participant_id;
  String? participant_age;
  String? father_name;
  String? state_lgd_code;
  String? district_lgd_code;
  String? block_lgd_code;
  String? gram_panchayat_lgd_code;
  String? village_lgd_code;
  String? tola_para;
  String? community_institution;
  String? selection_year;
  String? marital_status;
  String? mobile_no;
  String? level_of_education;
  String? total_family_members;
  String? number_adults_member;
  String? number_children_member;
  String? head_of_family;
  String? signature_literate;
  String? any_differently_abled_person_family;
  String? total_differently_adults_member;
  String? total_differently_children_member;
  String? are_you_member_of_shg;
  String? do_you_attend_any_shg_meeting;
  String? would_you_want_shg_member;
  String? coach_id;
  String? coach_contact_number;
  String? hh_visit_day;
  String? participant_photo;
  String? status;
  String? coach_name;
  String? latitude;
  String? longitude;
  String? sub_category_id;
  String? coach_category_id;
  String? martial_status_other;
  String? any_diffrent_abled_reason;
  String? participant_active_inactive;

  Participant({
    this.local_id,
    this.p_id,
    this.name_participant,
    this.participant_id,
    this.participant_age,
    this.father_name,
    this.state_lgd_code,
    this.district_lgd_code,
    this.block_lgd_code,
    this.gram_panchayat_lgd_code,
    this.village_lgd_code,
    this.tola_para,
    this.community_institution,
    this.selection_year,
    this.marital_status,
    this.mobile_no,
    this.level_of_education,
    this.total_family_members,
    this.number_adults_member,
    this.number_children_member,
    this.head_of_family,
    this.signature_literate,
    this.any_differently_abled_person_family,
    this.total_differently_adults_member,
    this.total_differently_children_member,
    this.are_you_member_of_shg,
    this.do_you_attend_any_shg_meeting,
    this.would_you_want_shg_member,
    this.coach_id,
    this.coach_contact_number,
    this.hh_visit_day,
    this.participant_photo,
    this.status,
    this.coach_name,
    this.latitude,
    this.longitude,
    this.sub_category_id,
    this.coach_category_id,
    this.martial_status_other,
    this.any_diffrent_abled_reason,
    this.participant_active_inactive,
  });

  static const String tableName = "participant";

  static const String columnLocalId = "local_id";
  static const String columnPId = "p_id";
  static const String columnParticipantName = "name_participant";
  static const String columnParticipantId = "participant_id";
  static const String columnParticipantAge = "participant_age";
  static const String columnParticipantFatherName = "father_name";
  static const String columnStateLgdCode = "state_lgd_code";
  static const String columnDistrictLgdCode = "district_lgd_code";
  static const String columnBlockLgdCode = "block_lgd_code";
  static const String columnGramPanchayetLgdCode = "gram_panchayat_lgd_code";
  static const String columnVillageLgdCode = "village_lgd_code";
  static const String columnTolaPara = "tola_para";
  static const String columnCommunityInstitution = "community_institution";
  static const String columnSelectionYear = "selection_year";
  static const String columnMaritalStatus = "marital_status";
  static const String columnMobileNo = "mobile_no";
  static const String columnLevelOfEducation = "level_of_education";
  static const String columnTotalFamilyMember = "total_family_members";
  static const String columnNumberAdultMember = "number_adults_member";
  static const String columnNumberChildrenMember = "number_children_member";
  static const String columnHeadOfFamily = "head_of_family";
  static const String columnSignatureLiterate = "signature_literate";
  static const String columnAnyDiffAbledPersonFamily = "any_differently_abled_person_family";
  static const String columnTotalDiffAdultMember = "total_differently_adults_member";
  static const String columnTotalDiffChildrenMember = "total_differently_children_member";
  static const String columnMemberOfShg = "are_you_member_of_shg";
  static const String columnAttendAnyShg = "do_you_attend_any_shg_meeting";
  static const String columnWantShgMember = "would_you_want_shg_member";
  static const String columnCoachId = "coach_id";
  static const String columnCoachContactNumber = "coach_contact_number";
  static const String columnHhVisitDay = "hh_visit_day";
  static const String columnParticipantPhoto = "participant_photo";
  static const String columnStatus = "status";
  static const String columnCoachName = "coach_name";
  static const String columnLatitude = "latitude";
  static const String columnLongitude = "longitude";
  static const String columnSubCategoryId = "sub_category_id";
  static const String columnCoachCategoryId = "coach_category_id";
  static const String columnmartial_status_other = "martial_status_other";
  static const String columnany_diffrent_abled_reason = "any_diffrent_abled_reason";
  static const String columnParticipantInactiveInactive = "participant_active_inactive";

  static const String createTable =
      "CREATE TABLE $tableName ("
      "$columnLocalId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$columnPId TEXT, "
      "$columnParticipantName TEXT, "
      "$columnParticipantId TEXT, "
      "$columnParticipantAge TEXT, "
      "$columnParticipantFatherName TEXT, "
      "$columnStateLgdCode TEXT, "
      "$columnDistrictLgdCode TEXT, "
      "$columnBlockLgdCode TEXT, "
      "$columnGramPanchayetLgdCode TEXT, "
      "$columnVillageLgdCode TEXT, "
      "$columnTolaPara TEXT, "
      "$columnCommunityInstitution TEXT, "
      "$columnSelectionYear TEXT, "
      "$columnMaritalStatus TEXT, "
      "$columnMobileNo TEXT, "
      "$columnLevelOfEducation TEXT, "
      "$columnTotalFamilyMember TEXT, "
      "$columnNumberAdultMember TEXT, "
      "$columnNumberChildrenMember TEXT, "
      "$columnHeadOfFamily TEXT, "
      "$columnSignatureLiterate TEXT, "
      "$columnAnyDiffAbledPersonFamily TEXT, "
      "$columnTotalDiffAdultMember TEXT, "
      "$columnTotalDiffChildrenMember TEXT, "
      "$columnMemberOfShg TEXT, "
      "$columnAttendAnyShg TEXT, "
      "$columnWantShgMember TEXT, "
      "$columnCoachId TEXT, "
      "$columnCoachContactNumber TEXT, "
      "$columnHhVisitDay TEXT, "
      "$columnParticipantPhoto TEXT, "
      "$columnStatus TEXT, "
      "$columnCoachName TEXT, "
      "$columnLatitude TEXT, "
      "$columnSubCategoryId TEXT, "
      "$columnCoachCategoryId TEXT, "
      "$columnmartial_status_other TEXT, "
      "$columnany_diffrent_abled_reason TEXT, "
      "$columnParticipantInactiveInactive TEXT, "
      "$columnLongitude TEXT"
      ")";

  // Convert from Map
  factory Participant.fromMap(Map<String, dynamic> json) {
    return Participant(
      local_id: json[columnLocalId] != null ? int.tryParse(json[columnLocalId].toString()) : null,
      p_id: json[columnPId],
      name_participant: json[columnParticipantName],
      participant_id: json[columnParticipantId],
      participant_age: json[columnParticipantAge],
      father_name: json[columnParticipantFatherName],
      state_lgd_code: json[columnStateLgdCode],
      district_lgd_code: json[columnDistrictLgdCode],
      block_lgd_code: json[columnBlockLgdCode],
      gram_panchayat_lgd_code: json[columnGramPanchayetLgdCode],
      village_lgd_code: json[columnVillageLgdCode],
      tola_para: json[columnTolaPara],
      community_institution: json[columnCommunityInstitution],
      selection_year: json[columnSelectionYear],
      marital_status: json[columnMaritalStatus],
      mobile_no: json[columnMobileNo],
      level_of_education: json[columnLevelOfEducation],
      total_family_members: json[columnTotalFamilyMember],
      number_adults_member: json[columnNumberAdultMember],
      number_children_member: json[columnNumberChildrenMember],
      head_of_family: json[columnHeadOfFamily],
      signature_literate: json[columnSignatureLiterate],
      any_differently_abled_person_family: json[columnAnyDiffAbledPersonFamily],
      total_differently_adults_member: json[columnTotalDiffAdultMember],
      total_differently_children_member: json[columnTotalDiffChildrenMember],
      are_you_member_of_shg: json[columnMemberOfShg],
      do_you_attend_any_shg_meeting: json[columnAttendAnyShg],
      would_you_want_shg_member: json[columnWantShgMember],
      coach_id: json[columnCoachId],
      coach_contact_number: json[columnCoachContactNumber],
      hh_visit_day: json[columnHhVisitDay],
      participant_photo: json[columnParticipantPhoto],
      status: json[columnStatus],
      coach_name: json[columnCoachName],
      latitude: json[columnLatitude],
      longitude: json[columnLongitude],
      sub_category_id: json[columnSubCategoryId],
      coach_category_id: json[columnCoachCategoryId],
      martial_status_other: json[columnmartial_status_other],
      any_diffrent_abled_reason: json[columnany_diffrent_abled_reason],
      participant_active_inactive: json[columnParticipantInactiveInactive],
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      columnPId: p_id,
      columnParticipantName: name_participant,
      columnParticipantId: participant_id,
      columnParticipantAge: participant_age,
      columnParticipantFatherName: father_name,
      columnStateLgdCode: state_lgd_code,
      columnDistrictLgdCode: district_lgd_code,
      columnBlockLgdCode: block_lgd_code,
      columnGramPanchayetLgdCode: gram_panchayat_lgd_code,
      columnVillageLgdCode: village_lgd_code,
      columnTolaPara: tola_para,
      columnCommunityInstitution: community_institution,
      columnSelectionYear: selection_year,
      columnMaritalStatus: marital_status,
      columnMobileNo: mobile_no,
      columnLevelOfEducation: level_of_education,
      columnTotalFamilyMember: total_family_members,
      columnNumberAdultMember: number_adults_member,
      columnNumberChildrenMember: number_children_member,
      columnHeadOfFamily: head_of_family,
      columnSignatureLiterate: signature_literate,
      columnAnyDiffAbledPersonFamily: any_differently_abled_person_family,
      columnTotalDiffAdultMember: total_differently_adults_member,
      columnTotalDiffChildrenMember: total_differently_children_member,
      columnMemberOfShg: are_you_member_of_shg,
      columnAttendAnyShg: do_you_attend_any_shg_meeting,
      columnWantShgMember: would_you_want_shg_member,
      columnCoachId: coach_id,
      columnCoachContactNumber: coach_contact_number,
      columnHhVisitDay: hh_visit_day,
      columnParticipantPhoto: participant_photo,
      columnStatus: status,
      columnCoachName: coach_name,
      columnLatitude: latitude,
      columnLongitude: longitude,
      columnSubCategoryId: sub_category_id,
     columnCoachCategoryId: coach_category_id,
      columnmartial_status_other: martial_status_other,
      columnany_diffrent_abled_reason: any_diffrent_abled_reason,
      columnParticipantInactiveInactive: participant_active_inactive,
    };
  }

  // to Json
  Map<String, dynamic> toJson() {
    return {
      "local_id": local_id,
      "p_id": p_id,
      "name_participant": name_participant,
      "participant_id": participant_id,
      "participant_age": participant_age,
      "father_name": father_name,
      "state_lgd_code": state_lgd_code,
      "district_lgd_code": district_lgd_code,
      "block_lgd_code": block_lgd_code,
      "gram_panchayat_lgd_code": gram_panchayat_lgd_code,
      "village_lgd_code": village_lgd_code,
      "tola_para": tola_para,
      "community_institution": community_institution,
      "selection_year": selection_year,
      "marital_status": marital_status,
      "mobile_no": mobile_no,
      "level_of_education": level_of_education,
      "total_family_members": total_family_members,
      "number_adults_member": number_adults_member,
      "number_children_member": number_children_member,
      "head_of_family": head_of_family,
      "signature_literate": signature_literate,
      "any_differently_abled_person_family": any_differently_abled_person_family,
      "total_differently_adults_member": total_differently_adults_member,
      "total_differently_children_member": total_differently_children_member,
      "are_you_member_of_shg": are_you_member_of_shg,
      "do_you_attend_any_shg_meeting": do_you_attend_any_shg_meeting,
      "would_you_want_shg_member": would_you_want_shg_member,
      "coach_id": coach_id,
      "coach_contact_number": coach_contact_number,
      "hh_visit_day": hh_visit_day,
      "participant_photo": participant_photo,
      "status": status,
      "coach_name": coach_name,
      "latitude": latitude,
      "longitude": longitude,
      "coach_category_id": coach_category_id,
      "sub_category_id": sub_category_id,
      "martial_status_other": martial_status_other,
      "any_diffrent_abled_reason": any_diffrent_abled_reason,
      "participant_active_inactive": participant_active_inactive,
    };
  }

  // for update
  Map<String, dynamic> toMapForUpdate() {
    return {
      columnParticipantName: name_participant,
      columnParticipantId: participant_id,
      columnParticipantAge: participant_age,
      columnParticipantFatherName: father_name,
      columnStateLgdCode: state_lgd_code,
      columnDistrictLgdCode: district_lgd_code,
      columnBlockLgdCode: block_lgd_code,
      columnGramPanchayetLgdCode: gram_panchayat_lgd_code,
      columnVillageLgdCode: village_lgd_code,
      columnTolaPara: tola_para,
      columnCommunityInstitution: community_institution,
      columnSelectionYear: selection_year,
      columnMaritalStatus: marital_status,
      columnMobileNo: mobile_no,
      columnLevelOfEducation: level_of_education,
      columnTotalFamilyMember: total_family_members,
      columnNumberAdultMember: number_adults_member,
      columnNumberChildrenMember: number_children_member,
      columnHeadOfFamily: head_of_family,
      columnSignatureLiterate: signature_literate,
      columnAnyDiffAbledPersonFamily: any_differently_abled_person_family,
      columnTotalDiffAdultMember: total_differently_adults_member,
      columnTotalDiffChildrenMember: total_differently_children_member,
      columnMemberOfShg: are_you_member_of_shg,
      columnAttendAnyShg: do_you_attend_any_shg_meeting,
      columnWantShgMember: would_you_want_shg_member,
      columnCoachId: coach_id,
      columnCoachContactNumber: coach_contact_number,
      columnHhVisitDay: hh_visit_day,
      columnParticipantPhoto: participant_photo,
      columnStatus: status,
      columnCoachName: coach_name,
      columnLatitude: latitude,
      columnLongitude: longitude,
      columnSubCategoryId: sub_category_id,
      columnCoachCategoryId: coach_category_id,
      columnmartial_status_other: martial_status_other,
      columnany_diffrent_abled_reason: any_diffrent_abled_reason,
      columnParticipantInactiveInactive: participant_active_inactive,
    };
  }

}
