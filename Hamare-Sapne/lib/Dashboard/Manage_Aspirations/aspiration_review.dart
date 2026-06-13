import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Common/BrandColors.dart';
import '../HomeScreen/HomeScreen.dart';

class AspirationReview extends StatefulWidget {
  const AspirationReview({super.key});

  @override
  State<AspirationReview> createState() => _AspirationReviewState();
}

class _AspirationReviewState extends State<AspirationReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // soft bg
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
              'Aspirations Review',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 6,
          shadowColor: Colors.deepPurple.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _aspirationBlock(
                  title: "Personal Aspiration",
                  content:
                  "To continuously grow as a person by learning new skills",
                  icon: Icons.person,
                  color: Colors.blueAccent,
                ),
                const Divider(thickness: 1, height: 28),
                _aspirationBlock(
                  title: "Family Aspiration",
                  content:
                  "To own a home where the family can live comfortably and securely.\n\n"
                      "To create a financially stable life with earning of 1 Lakh.",
                  icon: Icons.family_restroom,
                  color: Colors.green,
                ),
                const Divider(thickness: 1, height: 28),
                _aspirationBlock(
                  title: "Social Aspiration",
                  content: "NA",
                  icon: Icons.groups,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // aspiration block widget
  Widget _aspirationBlock({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // leading icon with circular background
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        // text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


