import 'package:cs_compas/pages/home.dart';
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
          color: AppColors.primaryColor,
          border: Border.all(color: AppColors.tertiaryColor, width: 3),
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
                  height: 130, //height of images
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Canvas page
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                  height: 130, //height of images
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Council FB page
                      _actionButtonPages(
                        imageUrl: "assets/provincialPage.jpg",
                        labelImage: "CCS Council Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100068659266555"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //Cipher FB page
                      _actionButtonPages(
                        imageUrl: "assets/cenvasPage.jpg",
                        labelImage: "Cenvas Page",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=61562716684826"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //Cipher FB page
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                      _actionButtonPages(
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
                      _actionButtonPages(
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
              // Council members
              const SizedBox(
                height: 10,
              ),
              _titleActionButtons(label: "CCS Council Officers"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 130, //height of images
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Council FB page
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/bryson.jpg",
                        labelImage: "Gov Gagula",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100010649170418"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/chavez.jpg",
                        labelImage: "Vice Gov Chavez",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100002329390864"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/poblacion.jpg",
                        labelImage: "Rep poblacion",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100002353288542"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/draper.jpg",
                        labelImage: "BM Draper",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100000588657286"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/balane.jpg",
                        labelImage: "BM Balane",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100004411247569"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/tupas.jpg",
                        labelImage: "BM Tupas",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100008139348809"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/damelerio.jpg",
                        labelImage: "BM Damelerio",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100009460432897"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/gonzales.jpg",
                        labelImage: "BM Gonzales",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100054243183372"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/jacildo.jpg",
                        labelImage: "BM Jacildo",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100079262975160"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/auman.jpg",
                        labelImage: "BM Auman",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100001585643079"),
                            false),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      _actionButtonPagesOfficers(
                        imageUrl: "assets/sanJose.jpg",
                        labelImage: "BM San Jose",
                        onTap: () => _launchUrl(
                            Uri.parse(
                                "https://www.facebook.com/profile.php?id=100084537758852"),
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

  Widget _actionButtonPages({
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
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
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
              color: AppColors.secondaryColor,
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
            color: AppColors.tertiaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
