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
              //Facebook page

              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CCS facebook page",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse(
                        "https://www.facebook.com/groups/977686173457202"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageCCS.jpg'),
                ),
              ),

              //Student Handbook
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CPU student handbook",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse(
                        "https://cpu.edu.ph/wp-content/uploads/2023/09/2023-gold-and-blue-student-handbook.pdf"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageHandbook.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //Canvas page

              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "CPU online canvas",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse("https://cpu.instructure.com/login/canvas"),
                    false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageCanvas.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //SOS page

              const Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Center(
                  child: Text(
                    "SOS student account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl(
                    Uri.parse("https://my.cpu.edu.ph/Membership/Login"), false),
                child: Container(
                  decoration: getContainerDecoration(),
                  margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                  alignment: Alignment.center,
                  child: Image.asset('assets/imageSOS.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
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

  BoxDecoration getContainerDecoration() {
    return BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: const BorderRadius.all(Radius.zero));
  }
}
