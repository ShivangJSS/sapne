import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Common/BrandColors.dart';
import '../HomeScreen/HomeScreen.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  Map<int, int> selectedOptions = {};
  final List<Map<String, dynamic>> options = [
    {"label": "Achieved", "icon": "assets/ach.png"},
    {"label": "Partially Achieved", "icon": "assets/pa.png"},
    {"label": "Not Achieved", "icon": "assets/na.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.appbackgroundColor,
      appBar: AppBar(
        backgroundColor: BrandColors.appColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        leadingWidth: 40,
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
            const Text(
              'Hamari Uplabdhi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
      body: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // thoda rounded corner
                        child: Image.asset(
                          "assets/lady1.png",
                          width: 84,
                          height: 115,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Right side details
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: Divya Sharma",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),

                            // manage large text length
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Icon(Icons.public, size: 16, color: BrandColors.appColor),
                            //     SizedBox(width: 6),
                            //     Expanded(
                            //       child: Text(
                            //         "State : Maharashtra",
                            //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            //         softWrap: true,
                            //         overflow: TextOverflow.visible,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 4),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Icon(Icons.map, size: 16, color: BrandColors.appColor),
                            //     SizedBox(width: 6),
                            //     Expanded(
                            //       child: Text(
                            //         "District : Nandurbar",
                            //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            //         softWrap: true,
                            //         overflow: TextOverflow.visible,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 4),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Icon(Icons.account_tree, size: 16, color: BrandColors.appColor),
                            //     SizedBox(width: 6),
                            //     Expanded(
                            //       child: Text(
                            //         "Block : Akkalkuwa",
                            //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            //         softWrap: true,
                            //         overflow: TextOverflow.visible,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.home_work, size: 16, color: BrandColors.appColor),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "Village : Ranipur",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  // const SizedBox(height: 16),
                  // DropdownButtonFormField<String>(
                  //   decoration: InputDecoration(
                  //     hintText: "Select Financial Year",
                  //     isDense: true, // height kam
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.black54, width: 1),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.orange, width: 1.5),
                  //     ),
                  //   ),
                  //   dropdownColor: Colors.white,
                  //   items: ["2023-2024","2024-2025", "2025-2026"]
                  //       .map((e) => DropdownMenuItem(
                  //     value: e,
                  //     child: Text(
                  //       e,
                  //       style: TextStyle(fontSize: 14),
                  //     ),
                  //   ))
                  //       .toList(),
                  //   onChanged: (val) {},
                  // ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Select Month",
                      isDense: true, // height kam
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black54, width: 1), // halka black
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1.5), // focus orange
                      ),
                    ),
                    dropdownColor: Colors.white,
                    items: ["April", "May", "june", "July","August","September","October","November","December","January","February","March"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14),
                      ),
                    ))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
          ),
          // Baaki content scrollable
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(6),
              children: [
                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCategory("Livelihoods and Productive Asset Ownership", [
                          "To build new house in a year",
                          "Want 4 cows in next 2 months",
                        ]),
                        const SizedBox(height: 20),
                        buildCategory("Food and Nutrition", [
                          "Two time meals",
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.apporangeColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // submit logic
                    },
                    child: const Text("Submit", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategory(String title, List<String> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...List.generate(questions.length, (qIndex) {
          int questionId = title.hashCode + qIndex; // unique key
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${qIndex + 1}. ${questions[qIndex]}",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(options.length, (optIndex) {
                    bool isSelected = selectedOptions[questionId] == optIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[questionId] = optIndex;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withOpacity(0.2)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Image.asset(
                          options[optIndex]["icon"],
                          height: 40,
                          width: 40,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: options
                      .map((o) => Container(
                    width: 70,
                    alignment: Alignment.center,
                    child: Text(
                      o["label"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ))
                      .toList(),
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
