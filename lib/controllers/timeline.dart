import 'package:cs_compas/calendar_controller/calendar_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timeline extends StatefulWidget {
  final List<Session> sessions;

  const Timeline({
    super.key,
    required this.sessions,
  });

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final PageController _pageController = PageController(
      initialPage: DateTime.now().month -
          1); //sets the initial page to the previous month of the current date.

  DateTime _currentMonth =
      DateTime.now(); // stores in the curerntly displayed month
  bool selectedcurrentyear = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          _buildHeader(),
          _buildWeeks(),
          Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentMonth =
                          DateTime(_currentMonth.year, index + 1, 1);
                    });
                  },
                  itemCount: 12 * 10, // show 10 years if u want... idc
                  itemBuilder: (context, pageIndex) {
                    DateTime month =
                        DateTime(_currentMonth.year, (pageIndex % 12) + 1, 1);
                    return buildCalendar(month, widget.sessions);
                  }))
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // this widget will allow user to interact with the calendar such as selecting year and month
    //bool isLastMonthOfYear = _currentMonth.month == 12;
    // Check if the current month is the last month of the year (December)

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // IconButton(
          //   onPressed: () {
          //     // move the previous pages
          //     if (_pageController.page! > 0) {
          //       _pageController.previousPage(
          //           duration: const Duration(milliseconds: 300),
          //           curve: Curves.easeInOut);
          //     }
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
          //display the currecnt month
          // M - month number/ MM - month number with leading zeroes/ MMM - month name shortcut/ MMMM - full name
          Text(
            DateFormat('MMMM').format(_currentMonth),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            dropdownColor: Colors.white,
            items: [
              // Generates DropdownMenuItems for a range of years from current year to 10 years ahead
              for (int year = DateTime.now().year;
                  year <= DateTime.now().year + 10;
                  year++)
                DropdownMenuItem<int>(value: year, child: Text(year.toString()))
            ],
            value: _currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                setState(
                  () {
                    //sets the current month to january of the selected year
                    _currentMonth = DateTime(year, 1, 1);

                    // Calculates the month index based on the selected year and sets the page
                    int yearDiff = DateTime.now().year - year;
                    int monthIndex = 12 * yearDiff + _currentMonth.month - 1;
                    _pageController.jumpToPage(monthIndex);
                  },
                );
              }
            },
          ),
          // IconButton(
          //     onPressed: () {
          //       //Move to the next page of it's not hte last month of the year
          //       if (!isLastMonthOfYear) {
          //         setState(() {
          //           _pageController.nextPage(
          //               duration: const Duration(milliseconds: 300),
          //               curve: Curves.easeInOut);
          //         });
          //       }
          //     },
          //     icon: const Icon(
          //       Icons.arrow_forward,
          //       color: Colors.black,
          //     ))
        ],
      ),
    );
  }

  Widget _buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWeekDay('Mon'),
          _buildWeekDay('Tue'),
          _buildWeekDay('Wed'),
          _buildWeekDay('Thu'),
          _buildWeekDay('Fri'),
          _buildWeekDay('Sat'),
          _buildWeekDay('Sun'),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        day,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  //build the month calendar
  Widget buildCalendar(DateTime month, List<Session> sessions) {
    // Calculate varisu details for the months display
    int daysInMonth = DateTime(month.year, month.month + 1, 0)
        .day; //creating a DateTime object for the first day of the next month and extracting the day component, the code calculates the number of days in the current month.
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth
        .weekday; // determines the weekday of the first day of the specified month.

    // ignore: non_constant_identifier_names
    DateTime LastDayOfPreviousMonth =
        firstDayOfMonth.subtract(const Duration(days: 1));
    int daysInPreviousMonth = LastDayOfPreviousMonth.day;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.5,
      ),
      // Calculating the total number of cells required in the grid

      itemCount: daysInMonth + weekdayOfFirstDay - 2,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);

          date.day.toString();

          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - index - 1) + 1;

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.black),
                left: BorderSide(width: 1.0, color: Colors.black),
                right: BorderSide(width: 1.0, color: Colors.black),
                bottom: BorderSide(width: 1.0, color: Colors.black),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              previousMonthDay.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          );
        } else {
          //Display the current months days
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);
          String text = date.day.toString(); // number of dates in the month

          String eventText = '';
          // Logic for displaying the evnets
          for (Session session in sessions) {
            if (session.dayevent == date.day &&
                session.monthnum == month.month) {
              eventText += session.event;
            }
          }
          return InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Event Details',
                      style: TextStyle(color: Colors.amber),
                    ),
                    content: Text(
                      eventText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    //display the number of dates
                    child: Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        eventText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  BoxDecoration customContainer() {
    return BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: const BorderRadius.all(Radius.circular(10)));
  }
}

