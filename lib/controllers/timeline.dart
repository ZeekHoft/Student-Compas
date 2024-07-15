import 'package:cs_compas/calendar_controller/calendar_entity.dart';

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
