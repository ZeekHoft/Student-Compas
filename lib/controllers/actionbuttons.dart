import 'package:cs_compas/controllers/color_control.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  late Future<Map> jsonData;

  @override
  void initState() {
    super.initState();
    jsonData = loadContent();
  }

  Future<Map> loadContent() async {
    final String jsonString =
        await rootBundle.loadString('assets/content.json');
    final Map data = jsonDecode(jsonString);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: jsonData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Map content = snapshot.data as Map;
            return ListView(
                physics: const BouncingScrollPhysics(),
                children: _generateList(content));
          } else {
            return const Placeholder();
          }
        });
  }

  List<Widget> _generateList(Map content) {
    List<Widget> children = [];
    for (String title in content.keys) {
      var sectionTitle = _titleActionButtons(label: title);
      children.add(sectionTitle);

      // Officers
      if (title == "CCS Council Officers") {
        List<Widget> officers = [];
        for (Map<String, dynamic> officer in content[title]!) {
          var abOfficer = _actionButtonPagesOfficers(
              imageUrl: officer['imageUrl'],
              labelImage: officer['labelImage'],
              onTap: () => _launchUrl(Uri.parse(officer['link']), false));
          officers.add(abOfficer);
        }
        children.add(Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 16,
          spacing: 8,
          children: officers,
        ));
      } else {
        // Student Information Tools and FB Pages
        List<Widget> section = [];
        for (Map<String, dynamic> item in content[title]!) {
          var actionButton = _actionButtonPages(
              imageUrl: item['imageUrl'],
              labelImage: item['labelImage'],
              onTap: () => _launchUrl(Uri.parse(item['link']), false));
          section.add(actionButton);
        }
        children.add(_actionButtonSection(children: section));
      }
    }
    return children;
  }

  void _launchUrl(Uri uri, bool inAPP) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inAPP) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
          );
        } else {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("URI error in home.dart: ${e.toString()}");
      }
    }
  }

  Widget _actionButtonSection({required List<Widget> children}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.container,
              border: Border.all(color: AppColors.black, width: 3),
              borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 120,
            child: Row(
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButtonPages({
    // attributes for action button
    //required parameters for orginal widget
    required String imageUrl,
    required String labelImage,
    required VoidCallback onTap, // requires a GestureDetector
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                foregroundDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.black, width: 3),
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Text(
              labelImage,
              style: const TextStyle(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButtonPagesOfficers({
    // attributes for action button
    //required parameters for orginal widget
    required String imageUrl,
    required String labelImage,
    required VoidCallback onTap, // requires a GestureDetector
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                  shape: BeveledRectangleBorder(
                      side: BorderSide(color: AppColors.black, width: 1.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomLeft: Radius.circular(7))),
                  color: AppColors.container)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 7),
          child: SizedBox(
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.container,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.black, width: 2)),
                        child: Image.asset(
                          imageUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        labelImage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleActionButtons({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Center(
        child: SizedBox(
          height: 48,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: const [BoxShadow(offset: Offset(1, 2))],
              color: AppColors.accent,
              border: Border.all(color: AppColors.black, width: 3),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
