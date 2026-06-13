import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/DatabaseHelper.dart';
import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Controllers/aspiration_controller.dart';
import '../HomeScreen/HomeScreen.dart';

AspirationController asp_controller = Get.find<AspirationController>();

class AddAspiration extends StatefulWidget {
  const AddAspiration({super.key});

  @override
  State<AddAspiration> createState() => _AddAspirationState();
}

class _AddAspirationState extends State<AddAspiration> {


  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  void dispose() {
    asp_controller.myTimer.stop();
    super.dispose();
  }
  Future<void> getData() async {
    await asp_controller.clearData();
    await asp_controller.getAllCategory();
    await asp_controller.loadSubcategories();
    await asp_controller.getSubCategoryQuestion();

    if (!mounted) return; // ✅ Guard against disposed widget
    await asp_controller.getLocation(context);

    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.appColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded( // ⭐ important
              child: Text(
                "addasp_appbaar_text".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis, // ⭐ prevent overflow
              ),
            ),

          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔎 Description + Search Input
              TextField(
                controller: asp_controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "type_question".tr,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),

              const SizedBox(height: 10),

              // 🟠 Go Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.apporangeColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    final query = asp_controller.descriptionController.text.trim();

                    if (query.isEmpty) {
                      SmartDialog.showToast("pls_enter_something".tr);
                      return;
                    }

                    FocusScope.of(context).unfocus();
                    asp_controller.matchCategory(query);
                  },
                  child: Text(
                    "go".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Category Section
              RichText(
                text: TextSpan(
                  text: "select_category".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF45757F),
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 🟢 Categories
              Obx(() => Column(
                children: asp_controller.categories.map((cat) {
                  final name = cat["asp_name"] ?? "unknown".tr;
                  final catId = cat["asp_cat_code"].toString();
                  final isSelected = asp_controller.selectedCategory.value == name;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Card(
                      color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: isSelected ? 6 : 2,
                      shadowColor: isSelected ? Colors.green.withOpacity(0.4) : Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          asp_controller.selectedCategory.value = name;
                          asp_controller.selectedCategoryId.value = catId;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-1, 0),
                                    child: Radio<String>(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -1, vertical: -4),
                                      value: name,
                                      groupValue: asp_controller.selectedCategory.value,
                                      activeColor: Colors.green,
                                      onChanged: (value) {
                                        asp_controller.selectedCategory.value = value!;
                                        asp_controller.selectedCategoryId.value = catId;
                                      },
                                    ),
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.green : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 110,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300, width: 2),
                                    color: Colors.white, // Background for transparent images
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: "${asp_controller.cat_image + cat["asp_photo"]}",
                                    fit: BoxFit.contain, // 🟢 ensures full image is visible (no cropping)
                                    alignment: Alignment.center,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image, color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 12),

              // Subcategory Section
              RichText(
                text: TextSpan(
                  text: "select_sub_category".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF45757F),
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Obx(() => Column(
                children: asp_controller.subcategories.map((subcat) {
                  final subCatName = subcat["asp_sub_category_name"]!;
                  final subCatId = subcat["asp_sub_cat_code"].toString();
                  final subCatImage = subcat["asp_sub_category_images"];
                  final isSelected = asp_controller.selectedSubCategory.value == subCatName;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Card(
                      color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: isSelected ? 5 : 2,
                      shadowColor: isSelected ? Colors.green.withOpacity(0.4) : Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          if (asp_controller.selectedSubCategory.value == subCatName) return;

                          asp_controller.selectedSubCategory.value = subCatName;
                          asp_controller.selectedSubCategoryId.value = subCatId;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Row(
                            children: [
                              Transform.translate(
                                offset: const Offset(-2, 0),
                                child: Radio<String>(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(horizontal: -1, vertical: -4),
                                  value: subCatName,
                                  groupValue: asp_controller.selectedSubCategory.value,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    if (asp_controller.selectedSubCategory.value == value) return;

                                    asp_controller.selectedSubCategory.value = value!;
                                    asp_controller.selectedSubCategoryId.value = subCatId;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 60, // slightly increased for better proportions
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300, width: 2),
                                  color: Colors.white, // helps transparent images look clean
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl: asp_controller.sub_cat_image + subCatImage,
                                  fit: BoxFit.contain, // 🟢 ensures full image visible, not cropped
                                  alignment: Alignment.center,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image, color: Colors.redAccent),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  subCatName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.green : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 30),

              // 🟠 Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.apporangeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black45,
                  ),
                  onPressed: () {
                    if (asp_controller.descriptionController.text.isEmpty) {
                      SmartDialog.showToast("pls_enter_something".tr);
                      return;
                    }
                    if (asp_controller.selectedCategoryId.value.isEmpty) {
                      SmartDialog.showToast("pls_select_category".tr);
                      return;
                    }
                    if (asp_controller.selectedSubCategoryId.value.isEmpty) {
                      SmartDialog.showToast("pls_select_sub_category".tr);
                      return;
                    }

                    asp_controller.btnSubmit(context);
                  },
                  child: Text(
                    "submit".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }











}
