import 'package:cs_compas/controllers/color_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DefaultCalendar extends StatefulWidget {
  const DefaultCalendar({
    super.key,
  });

  @override
  State<DefaultCalendar> createState() => _DefaultCalendarState();
}

class _DefaultCalendarState extends State<DefaultCalendar> {
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
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.backgroundColor, AppColors.backgroundColor])),
      child: Column(
        children: [
          _buildHeader(),
          _buildMonthName(),
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
                    return buildCalendar(month);
                  }))
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // this widget will allow user to interact with the calendar such as selecting year and month
    bool isLastMonthOfYear = _currentMonth.month == 12;
    // Check if the current month is the last month of the year (December)

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // move the previous pages
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: AppColors.dark,
            ),
          ),
          //display the currecnt month
          // M - month number/ MM - month number with leading zeroes/ MMM - month name shortcut/ MMMM - full name

          DropdownButton<int>(
            // Dropdown for selecting a year
            value: _currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                setState(() {
                  // Sets the current month to January of the selected year
                  _currentMonth = DateTime(year, 1, 1);

                  // Calculates the month index based on the selected year and sets the page
                  int yearDiff = DateTime.now().year - year;
                  int monthIndex = 12 * yearDiff + _currentMonth.month - 1;
                  _pageController.jumpToPage(monthIndex);
                });
              }
            },
            items: [
              // Generates DropdownMenuItems for a range of years from current year to 10 years ahead
              for (int year = DateTime.now().year;
                  year <= DateTime.now().year + 10;
                  year++)
                DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
            ],
          ),

          IconButton(
              onPressed: () {
                //Move to the next page of it's not the last month of the year
                if (!isLastMonthOfYear) {
                  setState(() {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.dark,
              ))
        ],
      ),
    );
  }

  Widget _buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: AppColors.tertiary,
            border: Border.all(color: AppColors.dark, width: 4),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
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
      ),
    );
  }

  Widget _buildWeekDay(String day) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        child: Column(
          children: [
            Text(
              day,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthName() {
    return Container(
      decoration: customContainer(),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "${DateFormat('MMMM').format(_currentMonth)} ",
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              showDate(),
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }

  //build the month calendar
  Widget buildCalendar(DateTime month) {
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

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.5,
        ),
        // Calculating the total number of cells required in the grid
        itemCount: daysInMonth + weekdayOfFirstDay - 2,
        itemBuilder: (context, index) {
          if (index < weekdayOfFirstDay - 1) {
            DateTime date = DateTime(
                month.year, month.month, index - weekdayOfFirstDay + 2);
            date.day.toString();

            int previousMonthDay =
                daysInPreviousMonth - (weekdayOfFirstDay - index - 1) + 1;

            return Card(
              child: Center(
                child: Text(
                  previousMonthDay.toString(),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            //Display the current months days
            DateTime date = DateTime(
                month.year, month.month, index - weekdayOfFirstDay + 2);
            String text = date.day.toString(); // number of dates in the month

            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: AppColors.dark,
                      title: const Text(
                        'Event Details',
                        style: TextStyle(color: AppColors.tertiary),
                      ),
                      content: const Text(
                        "Need Internet to fetch data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tertiary)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                decoration: const BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Card(
                  shadowColor: Colors.transparent,
                  color: AppColors.tertiary,
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
                                color: AppColors.dark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  BoxDecoration customContainer() {
    return BoxDecoration(
        color: AppColors.tertiary,
        border: Border.all(color: AppColors.dark, width: 4),
        borderRadius: const BorderRadius.all(Radius.circular(10)));
  }

  String showDate() {
    final now = DateTime.now();
    String formatter = DateFormat('MMM-dd-E').format(now);
    return formatter;
  }

  String showYear() {
    final now = DateTime.now();
    String formatter = DateFormat('yyyy').format(now);
    return formatter;
  }
}
