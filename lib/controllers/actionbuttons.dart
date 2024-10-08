import 'package:cs_compas/controllers/color_control.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          var abOfficer = _ActionButtonOfficer(
              imageUrl: officer['imageUrl'],
              position: officer['position'],
              labelImage: officer['labelImage'],
              onTap: () => _launchUrl(Uri.parse(officer['link']), false));
          officers.add(abOfficer);
        }
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 16,
            spacing: 8,
            children: officers,
          ),
        ));
      } else {
        // Student Information Tools and FB Pages
        List<Widget> section = [];
        for (Map<String, dynamic> item in content[title]!) {
          var actionButton = _ActionButtonPage(
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.neutral,
              border: Border.all(color: AppColors.borderColor, width: 3),
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

  Widget _titleActionButtons({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 48,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(offset: Offset(1, 2))],
                  color: AppColors.secondary,
                  border: Border.all(color: AppColors.textDark, width: 3),
                ),
                child: Text(label,
                    style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
              ),
            ),
            Positioned(
              top: -18,
              right: -15,
              child: Transform.rotate(
                angle: 0.25,
                child: SizedBox(
                  height: 32,
                  width: 40,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        border:
                            Border.all(color: AppColors.borderColor, width: 3),
                        boxShadow: [
                          BoxShadow(offset: Offset.fromDirection(1.04, 2))
                        ]),
                    child: Icon(
                      switch (label) {
                        "Student Information Tools" =>
                          Icons.tips_and_updates_rounded,
                        "Organization Facebook Pages" => Icons.thumb_up_rounded,
                        "CCS Council Officers" => Icons.groups_rounded,
                        _ => Icons.cancel
                      },
                      color: AppColors.dark,
                      size: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionButtonOfficer extends StatefulWidget {
  // attributes for action button
  //required parameters for orginal widget
  final String imageUrl;
  final String position;
  final String labelImage;
  final VoidCallback onTap; // requires a GestureDetector

  const _ActionButtonOfficer({
    required this.imageUrl,
    required this.position,
    required this.labelImage,
    required this.onTap,
  });

  @override
  State<_ActionButtonOfficer> createState() => __ActionButtonOfficerState();
}

class __ActionButtonOfficerState extends State<_ActionButtonOfficer> {
  final double _itemWidth = 95;
  final double _itemHeight = 150;
  final double _sideLength = 7;
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.easeOutCubic;

  // variable for animation
  late double _animationValue = _sideLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _itemWidth + _sideLength,
      height: _itemHeight + _sideLength,
      child: GestureDetector(
        onTapDown: (details) => setState(() => _animationValue = 0),
        onTapUp: (value) => setState(() => _animationValue = _sideLength),
        onTapCancel: () => setState(() => _animationValue = _sideLength),
        onTap: () async {
          // Wait for animation to complete
          setState(() => _animationValue = 0);
          await Future.delayed(_duration);
          setState(() => _animationValue = _sideLength);
          widget.onTap();
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            // Bottom container
            AnimatedPositioned(
              duration: _duration,
              curve: _curve,
              right: _animationValue,
              child: Transform(
                transform: Matrix4.skewX(0.79),
                child: AnimatedContainer(
                  duration: _duration,
                  curve: _curve,
                  width: _itemWidth,
                  height: _animationValue,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    border: Border(
                      bottom:
                          BorderSide(color: AppColors.borderColor, width: 3),
                      left: BorderSide(color: AppColors.borderColor, width: 3),
                    ),
                  ),
                ),
              ),
            ),
            // Right container
            AnimatedPositioned(
              duration: _duration,
              curve: _curve,
              bottom: _animationValue,
              child: Transform(
                transform: Matrix4.skewY(0.78),
                child: AnimatedContainer(
                  duration: _duration,
                  curve: _curve,
                  width: _animationValue,
                  height: _itemHeight,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    border: Border(
                      right: BorderSide(color: AppColors.borderColor, width: 3),
                      top: BorderSide(color: AppColors.borderColor, width: 3),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: _duration,
              curve: _curve,
              bottom: _animationValue,
              right: _animationValue,
              child: SizedBox(
                width: _itemWidth,
                height: _itemHeight,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.midtone,
                      border:
                          Border.all(color: AppColors.borderColor, width: 3)),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.borderColor, width: 2))),
                        child: Image.asset(
                          widget.imageUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(widget.position,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      Text(
                        widget.labelImage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Button with label that redirects on tap
class _ActionButtonPage extends StatefulWidget {
  final String imageUrl;
  final String labelImage;
  final VoidCallback onTap;
  const _ActionButtonPage(
      {required this.imageUrl, required this.labelImage, required this.onTap});

  @override
  State<_ActionButtonPage> createState() => __ActionButtonPageState();
}

class __ActionButtonPageState extends State<_ActionButtonPage> {
  bool _pressing = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTapDown: (details) => setState(() => _pressing = true),
              onTapUp: (value) => setState(() => _pressing = false),
              onTapCancel: () => setState(() => _pressing = false),
              onTap: () async {
                // Wait for animation to complete
                setState(() => _pressing = true);
                await Future.delayed(const Duration(milliseconds: 300));
                setState(() => _pressing = false);
                widget.onTap();
              },
              child: AnimatedPadding(
                padding: EdgeInsets.all(_pressing ? 4 : 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  foregroundDecoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.borderColor, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    widget.imageUrl,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.labelImage,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
