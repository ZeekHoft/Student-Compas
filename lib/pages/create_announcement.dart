import 'dart:convert';

import 'package:cs_compas/anouncement_controllers/announcement_entity.dart';
import 'package:cs_compas/controllers/color_control.dart';
import 'package:cs_compas/pages/notif.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final _formKey = GlobalKey<FormState>();
  final remoteConfig = FirebaseRemoteConfig.instance;
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _dateTimeFrom = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();

  // get the current announcemnt through the textformfield and check for validation
  Future<void> _submitAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      final dateNow = DateTime.now().toUtc();
      final newSession = Session(
        id: "Announcement",
        link: _linkController.text,
        title: _titleController.text,
        dateTimeFrom: dateNow,
        body: _bodyController.text,
        sender: [_senderController.text],
      );

      //access remoteconfig and set the new session of announcement

      final existingAnnouncement =
          await remoteConfig.getString(remoteUserDataKey);
      final parsedAnnouncement =
          Announcement.fromJson(jsonDecode(existingAnnouncement));
      parsedAnnouncement.sessions.add(newSession);

      remoteConfig.setDefaults({
        remoteUserDataKey: jsonEncode(parsedAnnouncement),
      });
      await remoteConfig.fetchAndActivate();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Announcement successfully added")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Make announcements")),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: customContainer(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                          labelText: 'Link (optional)',
                          hintText: 'Enter a link (if applicable)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),
                      //Title
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: "Announcement Title (Required)",
                          hintText: "Please input a Title for the announcement",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      //Date
                      // TextFormField(
                      //   controller: _dateTimeFrom,
                      //   decoration: const InputDecoration(
                      //     labelText: "Date & Time of announcement (Required)",
                      //     hintText:
                      //         "Please input a Date & Time for the announcement",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Please enter a Date & Time";
                      //     }
                      //     return null;
                      //   },
                      // ),

                      // const SizedBox(
                      //   height: 20,
                      // ),
                      //Content
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          labelText: "Announcement Body (Required)",
                          hintText:
                              "Please input main content for the announcement",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter content";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //Sender
                      TextFormField(
                        controller: _senderController,
                        decoration: const InputDecoration(
                          labelText: "Announcement Sender (Required)",
                          hintText: "Please input Sender for the announcement",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Position of Sender";
                          }
                          return null;
                        },
                      ),

                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            await _submitAnnouncement();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Announcement successfully added")));
                          }
                        },
                        child: const Text(
                          "press me",
                          style: TextStyle(backgroundColor: Colors.amber),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration customContainer() {
  return BoxDecoration(
      color: AppColors.midtone,
      border: Border.all(color: AppColors.borderColor, width: 3),
      boxShadow: [BoxShadow(offset: Offset.fromDirection(1, 3))]);
}
