import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Common/BrandColors.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Manage_Aspirations/feedback.dart';

class FeedbackList extends StatefulWidget {
  const FeedbackList({super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {

  List<Map<String, String>> families = [
    {
      "name": "Ramesh Kumar",
      "head": "Shyam Lal",
      "village": "Patna",
      "members": "5",
      "image": "assets/man.jpg",
      "date": "01-01-2020",
    },
    {
      "name": "Suresh Yadav",
      "head": "Mohan Yadav",
      "village": "Gaya",
      "members": "7",
      "image": "assets/man.jpg",
      "date": "15-02-2021",
    },
    {
      "name": "Anita Devi",
      "head": "Hari Prasad",
      "village": "Nalanda",
      "members": "4",
      "image": "assets/girl.jpg",

      "date": "10-05-2022",
    },
    {
      "name": "Anita Devi",
      "head": "Hari Prasad",
      "village": "Nalanda",
      "members": "4",
      "image": "assets/girl.jpg",
      "date": "10-05-2022",
    },
    {
      "name": "Anita Devi",
      "head": "Hari Prasad",
      "village": "Nalanda",
      "members": "4",
      "image": "assets/girl.jpg",
      "date": "10-05-2022",
    },
    {
      "name": "Anita Devi",
      "head": "Hari Prasad",
      "village": "Nalanda",
      "members": "4",
      "image": "assets/girl.jpg",
      "date": "10-05-2022",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.appbackgroundColor,
      appBar: AppBar(
        backgroundColor: BrandColors.appColor,
        elevation: 2,
        automaticallyImplyLeading: false, // Flutter का default back हटा देंगे
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
              'Feedback',
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Name...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF45757F)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Color(0xFF45757F)),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: BrandColors.apporangeColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: BrandColors.apporangeColor, width: 2),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: families.length,
              itemBuilder: (context, index) {
                final family = families[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(
                    //   color: BrandColors.apporangeColor, // Thin colored border
                    //   width: 1,
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: BrandColors.appColor.withOpacity(0.2),
                              backgroundImage: family["image"] != null &&
                                  family["image"]!.isNotEmpty
                                  ? AssetImage(family["image"]!)
                                  : null,
                              child: family["image"] == null || family["image"]!.isEmpty
                                  ? const Icon(Icons.person,
                                  color: BrandColors.appColor, size: 28)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                family["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedbackPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BrandColors.apporangeColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 2),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),
                        _buildDetailRow("Name", family["name"] ?? ""),
                        _buildDetailRow("Village", family["village"] ?? ""),
                        _buildDetailRow("Members", family["members"] ?? ""),
                        _buildDetailRow("Date", family["date"] ?? ""),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: BrandColors.apporangeColor,
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => FeedbackPage()));
      //   },
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedOption1;
    String? selectedOption2;
    String? selectedOption3;
    String? selectedOption4;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Apply Filter",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // DropdownButtonFormField<String>(
                    //   value: selectedOption1,
                    //   hint: Text("Select State"),
                    //   items: [
                    //     "Uttar Pradesh",
                    //     "Maharashtra",
                    //     "Karnataka",
                    //     "Tamil Nadu",
                    //     "Gujarat"
                    //   ]
                    //       .map(
                    //           (e) => DropdownMenuItem(child: Text(e), value: e))
                    //       .toList(),
                    //   onChanged: (val) => setState(() => selectedOption1 = val),
                    // ),
                    // SizedBox(height: 10),
                    // DropdownButtonFormField<String>(
                    //   value: selectedOption2,
                    //   hint: Text("Select District"),
                    //   items: [
                    //     "Lucknow",
                    //     "Varanasi",
                    //     "Kanpur Nagar",
                    //     "Prayagraj",
                    //     "Gorakhpur"
                    //   ]
                    //       .map(
                    //           (e) => DropdownMenuItem(child: Text(e), value: e))
                    //       .toList(),
                    //   onChanged: (val) => setState(() => selectedOption2 = val),
                    // ),
                    // SizedBox(height: 10),
                    // DropdownButtonFormField<String>(
                    //   value: selectedOption3,
                    //   hint: Text("Select Block"),
                    //   items: [
                    //     "Bakshi Ka Talab",
                    //     "Chinhat",
                    //     "Sadar",
                    //     "Malihabad",
                    //     "Sarojini Nagar"
                    //   ]
                    //       .map(
                    //           (e) => DropdownMenuItem(child: Text(e), value: e))
                    //       .toList(),
                    //   onChanged: (val) => setState(() => selectedOption3 = val),
                    // ),
                    // SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedOption4,
                      hint: Text("Select Village"),
                      items: [
                        "Chandpur",
                        "Rampur",
                        "Bhawanipur",
                        "Sultanpur",
                        "Nagla Kalan"
                      ]
                          .map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (val) => setState(() => selectedOption4 = val),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    setState(() {
                      selectedOption1 = null;
                      selectedOption2 = null;
                      selectedOption3 = null;
                      selectedOption4 = null;
                    });
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Color(0xFF45757F),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.appColor,
                  ),
                  onPressed: () {
                    print(
                        "Apply clicked with filters: $selectedOption1, $selectedOption2, $selectedOption3, $selectedOption4");
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
