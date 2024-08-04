import 'package:cs_compas/pages/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.6,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _titleActionButtons(label: "Student Information Tools"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      border:
                          Border.all(color: AppColors.tertiaryColor, width: 3),
                      borderRadius: BorderRadius.circular(8)),
                  child: SizedBox(
                    height: 120, //height of images
                    child: Row(
                      // scrollDirection: Axis.horizontal,
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
                        _actionButtonPages(
                          imageUrl: "assets/jpgHandbook.jpg",
                          labelImage: "Student Handbook",
                          onTap: () => _launchUrl(
                              Uri.parse(
                                  "https://cpu.edu.ph/wp-content/uploads/2023/09/2023-gold-and-blue-student-handbook.pdf"),
                              false),
                        ),
                        //SOS page
                        _actionButtonPages(
                          imageUrl: "assets/jpgSOS.jpg",
                          labelImage: "Online SOS",
                          onTap: () => _launchUrl(
                              Uri.parse(
                                  "https://my.cpu.edu.ph/Membership/Login"),
                              false),
                        ),
                        //CPU republic page
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _titleActionButtons(label: "Organization Facebook Pages"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      border:
                          Border.all(color: AppColors.tertiaryColor, width: 3),
                      borderRadius: BorderRadius.circular(8)),
                  child: SizedBox(
                    height: 120, //height of images
                    child: Row(
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
                        //Cipher FB page
                        _actionButtonPages(
                          imageUrl: "assets/cenvasPage.jpg",
                          labelImage: "Cenvas Page",
                          onTap: () => _launchUrl(
                              Uri.parse(
                                  "https://www.facebook.com/profile.php?id=61562716684826"),
                              false),
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
                        //CCS FB page
                        _actionButtonPages(
                          imageUrl: "assets/ccsPage.jpg",
                          labelImage: "CSS Page",
                          onTap: () => _launchUrl(
                              Uri.parse(
                                  "https://www.facebook.com/profile.php?id=100076214379794"),
                              false),
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
                        //DMIA FB page
                        _actionButtonPages(
                          imageUrl: "assets/dmiaPage.jpg",
                          labelImage: "MIDAS Page",
                          onTap: () => _launchUrl(
                              Uri.parse(
                                  "https://www.facebook.com/profile.php?id=100064085917363"),
                              false),
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
              ),
            ),
            // Council members
            const SizedBox(
              height: 10,
            ),
            _titleActionButtons(label: "CCS Council Officers"),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 20,
              spacing: 10,
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
                _actionButtonPagesOfficers(
                  imageUrl: "assets/chavez.jpg",
                  labelImage: "Vice Gov Chavez",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100002329390864"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/poblacion.jpg",
                  labelImage: "Rep poblacion",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100002353288542"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/draper.jpg",
                  labelImage: "BM Draper",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100000588657286"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/balane.jpg",
                  labelImage: "BM Balane",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100004411247569"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/tupas.jpg",
                  labelImage: "BM Tupas",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100008139348809"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/damelerio.jpg",
                  labelImage: "BM Damelerio",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100009460432897"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/gonzales.jpg",
                  labelImage: "BM Gonzales",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100054243183372"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/jacildo.jpg",
                  labelImage: "BM Jacildo",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100079262975160"),
                      false),
                ),
                _actionButtonPagesOfficers(
                  imageUrl: "assets/auman.jpg",
                  labelImage: "BM Auman",
                  onTap: () => _launchUrl(
                      Uri.parse(
                          "https://www.facebook.com/profile.php?id=100001585643079"),
                      false),
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
          ],
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
                    border:
                        Border.all(color: AppColors.tertiaryColor, width: 3),
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
                color: AppColors.tertiaryColor,
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
                      side: BorderSide(
                          color: AppColors.tertiaryColor, width: 1.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomLeft: Radius.circular(7))),
                  color: AppColors.primaryColor)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 7),
          child: SizedBox(
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(color: AppColors.tertiaryColor, width: 2),
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.tertiaryColor, width: 2)),
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
                          color: AppColors.tertiaryColor,
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
    return Center(
      child: SizedBox(
        height: 48,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(offset: Offset(1, 2))],
            color: const Color.fromARGB(255, 255, 181, 95),
            border: Border.all(color: AppColors.tertiaryColor, width: 3),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.tertiaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
