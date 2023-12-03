import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:travel_planning_app/event.dart';

class CalendarPage extends StatefulWidget {
  Map<DateTime, List<Event>> oldEvents = {};
  CalendarPage(this.oldEvents);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Event>> events = widget.oldEvents;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  void printEventsMap(Map<DateTime, List<Event>> events) {
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Truncate time component from the selected day
    DateTime truncatedDay = DateTime(day.year, day.month, day.day);

    if (events.containsKey(truncatedDay)) {
      return events[truncatedDay]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    printEventsMap(events);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 23,
            )),
        title: Text(
          "Calendar",
          style: TextStyle(
              color: Colors.white, fontFamily: "Poppins", fontSize: 28),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg1.jpg"), fit: BoxFit.cover),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text(
              "Your Traveling Date",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: TableCalendar(
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              focusedDay: _focusedDay,
              firstDay: DateTime(1900),
              lastDay: DateTime(2100),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
            ),
          ),
          Container(
            height: 200,
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  // print('Selected Events: $value');
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        // print('${value[index].title}');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Events",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: ListTile(
                                  onTap: () => print(""),
                                  title: Text(
                                    '${value[index].title}',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "Poppins"),
                                  )),
                            ),
                          ],
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
