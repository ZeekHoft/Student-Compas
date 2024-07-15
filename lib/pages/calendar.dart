import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:cs_compas/calendar_controller/util_calendar.dart';
import 'package:cs_compas/controllers/load_notif_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

const remoteCalendarKey = "events";

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
  final utilCalendar = UtilCalendar();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LoadNotifCalendar().fetchDataAsync();
      notifierData.value = LoadNotifCalendar().calendarEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.white])),
        child: ValueListenableBuilder(
          valueListenable: notifierData,
          builder: (context, CalendarEvents? value, child) {
            if (value == null) {
              return const Center(child: Text("Normal School Month"));
            }

            return Timeline(
              sessions: value.sessions,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "button calendar",
        mini: true,
        backgroundColor: Colors.black,
        onPressed: () => _syncDataCalendar(),
        tooltip: 'Sync Calendar',
        child: const Icon(
          Icons.sync,
          color: Colors.amber,
        ),
      ),
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
      final rs = remoteConfig.getString(remoteCalendarKey);
      notifierData.value = await utilCalendar.parseJsonConfig(rs);
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
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              SizedBox(height: 8.0),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.amber),
              )
            ],
          ),
        );
      },
    );
  }
}

class Timeline extends StatelessWidget {
  final List<Session> sessions;

  const Timeline({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TimelineTile(
              beforeLineStyle: const LineStyle(
                color: Colors.black,
                thickness: 4,
              ),
              indicatorStyle: IndicatorStyle(
                width: 60,
                height: 60,
                indicator: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ClipOval(
                    child: SizedBox(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              session.monthname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              endChild: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${session.dayname} - ${session.dateStart.day.toString()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      ),
                      Text(
                        session.event.toString(),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                        textAlign: TextAlign.start,
                        overflow:
                            TextOverflow.clip, // Add TextOverflow.ellipsis
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
