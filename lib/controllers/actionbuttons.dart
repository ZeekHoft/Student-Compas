import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        height: screenHeight * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              _titleActionButtons(label: "Student Information Tools"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 110, //height of images
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Canvas page
                      _actionButton(
                        imageUrl: "assets/jpgCanvas.jpg",
                        labelImage: "Online Canvas",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://cpu.instructure.com/login/canvas"),
                            false),
                      ),
                      //Handbook page
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButton(
                        imageUrl: "assets/jpgHandbook.jpg",
                        labelImage: "Student Handbook",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://cpu.edu.ph/wp-content/uploads/2023/09/2023-gold-and-blue-student-handbook.pdf"),
                            false),
                      ),
                      //SOS page
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButton(
                        imageUrl: "assets/jpgSOS.jpg",
                        labelImage: "Online SOS",
                        onTap: () => _launchUrl(
                            Uri.parse("https://my.cpu.edu.ph/Membership/Login"),
                            false),
                      ),
                      //CPU republic page
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButton(
                        imageUrl: "assets/jpgRepublic.jpg",
                        labelImage: "CPU republic",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100070022602096"),
                            false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _titleActionButtons(label: "Organization Facebook Pages"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 110, //height of images
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Council FB page
                      _actionButton(
                        imageUrl: "assets/councilPage.jpg",
                        labelImage: "CCS Council Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/groups/977686173457202"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //Cipher FB page
                      _actionButton(
                        imageUrl: "assets/cipherPage.jpg",
                        labelImage: "Cipher Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=61555733671039"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //CCS FB page
                      _actionButton(
                        imageUrl: "assets/ccsPage.jpg",
                        labelImage: "CSS Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100076214379794"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //ITSO FB page
                      _actionButton(
                        imageUrl: "assets/itsoPage.jpg",
                        labelImage: "ITSO Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100067320420361"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //DMIA FB page
                      _actionButton(
                        imageUrl: "assets/dmiaPage.jpg",
                        labelImage: "MIDAS Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100064085917363"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //LISSO FB page
                      _actionButton(
                        imageUrl: "assets/lissoPage.jpg",
                        labelImage: "LISSO Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100063651357008"),
                            false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _actionButton({
    // attributes for action button
    //required parameters for orginal widget
    required String imageUrl,
    required String labelImage,
    required VoidCallback onTap, // requires a GestureDetector
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _titleActionButtons({required String label}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
