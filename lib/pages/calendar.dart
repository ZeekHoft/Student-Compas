import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:cs_compas/calendar_controller/util_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const remote_calendar_data_key = "events";

class ValueDateNotifier extends ValueNotifier<CalendarEvents?> {
  ValueDateNotifier() : super(null);
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final notifierData = ValueDateNotifier();
  final util = UtilCalendar();

  @override
  void initState() {
    super.initState();
    remoteConfig.fetchAndActivate().then((_) {
      _syncDataCalendar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Events for the month:"),
      ),
      body: ValueListenableBuilder(
        valueListenable: notifierData,
        builder: (context, CalendarEvents? value, child) {
          if (value == null) {
            return const Center(child: Text("Normal School Month"));
          }
          return ListView.builder(
            itemCount: value.sessions.length,
            itemBuilder: (context, Index) {
              final session = value.sessions[Index];
              return ListTile(
                title: Text(session.dateStart.toString()),
                subtitle: Text(session.event.toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "button calendar",
          onPressed: () => _syncDataCalendar(),
          tooltip: 'Sync Calendar',
          child: const Icon(Icons.sync)),
    );
  }

  Future<void> _syncDataCalendar() async {
    //refreshes the announcemnts and forces to call every last one
    showLoadingWidget(context);
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Force fetch on every call
      ));
      await remoteConfig.fetchAndActivate();
      final rs = remoteConfig.getString(remote_calendar_data_key);
      notifierData.value = await util.parseJsonConfig(rs);
      Navigator.pop(context); // hide loading
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showLoadingWidget(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8.0),
              Text('Loading...')
            ],
          ),
        );
      },
    );
  }
}
