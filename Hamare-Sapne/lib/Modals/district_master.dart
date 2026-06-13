

import 'package:trikal_up/Modals/village_list.dart';

class DistrictMaster {
String? district_id;
String? district_name;
String? state_id;
String? state_lgd_code;
String? district_lgd_code;
String? lang_id;
String? status;

DistrictMaster({
this.district_id,
this.district_name,
this.state_id,
this.state_lgd_code,
this.district_lgd_code,
this.status,
this.lang_id,
});

static const String tableName = "district_master";

// Columns
static const String ColumnDistrictId = "district_id";
static const String columnDistrictName = "district_name";
static const String columnStateId = "state_id";
static const String columnStateLgdCode = "state_lgd_code";
static const String columnDistrictLgdCode = "district_lgd_code";
static const String columnStatus = "status";
static const String columnlang_id = "lang_id";

static const String createTable =
"CREATE TABLE $tableName ("
"$ColumnDistrictId TEXT, "
"$columnDistrictName TEXT, "
"$columnStateId TEXT, "
"$columnStateLgdCode TEXT, "
"$columnDistrictLgdCode TEXT, "
"$columnlang_id TEXT, "
"$columnStatus TEXT "
")";

// Convert from Map
factory DistrictMaster.fromMap(Map<String, dynamic> json) {
return DistrictMaster(
  district_id: json[ColumnDistrictId] ?? "",
  district_name: json[columnDistrictName] ?? "",
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
  columnDistrictName: district_name,
  columnStateId: state_id,
columnlang_id: lang_id,
  columnStateLgdCode: state_lgd_code,
  columnDistrictLgdCode: district_lgd_code,
  columnStatus: status,
};
}

//
// // Convert to JSON (for API)
// Map<String, dynamic> toJson() {
//   return {
//     "local_id": local_id,
//     "gp_id": gp_id,
//     "gp_name": gp_name,
//     "gp_lgd_code": gp_lgd_code,
//     "user_name": user_name,
//     "c_id": c_id,
//   };
// }
}
