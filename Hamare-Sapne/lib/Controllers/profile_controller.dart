import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Modals/clf_master.dart';
import '../Modals/updateCoachProfile.dart';

class ProfileController extends GetxController {


  void onInit() {
    super.onInit();
    getDataProfile();
  }


  var fullname = ''.obs;
  var phone = ''.obs;
  var coachId = ''.obs;
  var coachImage = ''.obs;

  Future<void> getDataProfile() async {
    String name = await SharedPreferHelper.getPrefString("full_name");
    String ph = await SharedPreferHelper.getPrefString("mobile_no");
    String id = await SharedPreferHelper.getPrefString("userId");
    String image = await SharedPreferHelper.getPrefString("coach_image");
    print('name is $name');

    fullname.value = name;
    phone.value = ph;
    coachId.value = id;
    coachImage.value = image;
   await initializeData();
    update(); // Notify UI
  }

  var data1 = <UpdateCoachProfile>[].obs;
  List<ClfMaster> clfData =[];

  String getClfName(String? clfId) {
    if (clfId == null || clfId.isEmpty) return 'Not Available';

    final clf = clfData.firstWhere(
          (element) => element.clf_code == clfId,
      orElse: () => ClfMaster(clf_code: '', clf_name: 'Not Available'),
    );
    return clf.clf_name ?? 'Not Available';
  }

  Future<void> initializeData() async {
    String cId = await SharedPreferHelper.getPrefString("userId");
    if (cId.isEmpty) {
      print("No userId found — profile not loaded");

      return;
    }
    print('CID is profile$cId');
    String query = "Select * from coach_profile where c_id = $cId";
    String query1 = "Select * from clf_master";

    List<UpdateCoachProfile> data = await DatabaseHelper.instance.getList(query);
    List<ClfMaster> dataCLF = await DatabaseHelper.instance.getCLFList(query1);

    data1.assignAll(data);
    clfData.assignAll(dataCLF);

    update(); // Notify listeners
  }

}