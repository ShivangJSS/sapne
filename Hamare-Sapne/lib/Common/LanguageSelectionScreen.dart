import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Common/AppLanguages.dart';
import 'package:trikal_up/Login/Login.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLangCode = "en_US";
  final AppLanguages appLanguages = AppLanguages();

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    await appLanguages.loadLanguages();
    setState(() {}); // refresh UI after loading from DB
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("select_language".tr,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E9092),
        elevation: 2,
      ),
      body: appLanguages.languages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: appLanguages.languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lang = appLanguages.languages[index];
                final code = lang['code'] as String;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: selectedLangCode == code
                        ? const Color(0xFF1E9092).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedLangCode == code
                          ? const Color(0xFF1E9092)
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: RadioListTile<String>(
                    value: code,
                    groupValue: selectedLangCode,
                    activeColor: const Color(0xFF1E9092),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      lang['name'] as String,
                      style: TextStyle(
                        fontSize: size.width < 360 ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: selectedLangCode == code
                            ? const Color(0xFF1E9092)
                            : Colors.black87,
                      ),
                    ),
                    secondary: Icon(
                      Icons.flag,
                      color: selectedLangCode == code
                          ? const Color(0xFF1E9092)
                          : Colors.grey,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedLangCode = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // ✅ Modern OK Button
          SafeArea(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF1E9092),
                  elevation: 3,
                ),
                onPressed: () async {
                  await SharedPreferHelper.setPrefString("lang", selectedLangCode);
                  final selectedLang = appLanguages.languages.firstWhere(
                        (lang) => lang['code'] == selectedLangCode,
                    orElse: () => {
                      "id": "1",
                      "code": "en_US",
                      "locale": const Locale("en", "US"),
                      "name": "English",
                    },
                  );
                  await SharedPreferHelper.setPrefString(
                    "languageId",
                    selectedLang['id'].toString(),
                  );
                  Get.updateLocale(selectedLang['locale'] as Locale);
                  Get.offAll(() => const Login());
                },
                child: Text(
                  "ok".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          ) ],
      ),
    );
  }
}
