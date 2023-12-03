import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_planning_app/maputils.dart';
import 'package:travel_planning_app/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:math' as math;
import 'package:travel_planning_app/event.dart';

import 'package:travel_planning_app/calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _origin = TextEditingController();
  TextEditingController _destiny = TextEditingController();
  TextEditingController _journeyName = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _todo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CollectionReference _travelling =
        FirebaseFirestore.instance.collection("travelling");

    Map<DateTime, List<Event>> events = {};

    // DATE PICKER
    Future<void> _pickdate(TextEditingController controller) async {
      DateTime? dateTime = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2025));
      if (dateTime != null) {
        setState(() {
          controller.text = DateFormat("yyyy-MM-dd").format(dateTime);
        });
      }
    }

    // CREATE PLANNING
    Future<void> _startPlanning([DocumentSnapshot? documentSnapshot]) async {
      _journeyName.text = "";
      _destiny.text = "";
      _origin.text = "";
      _startDate.text = "";
      _endDate.text = "";
      _todo.text = "";
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Text(
                      "Yusafir...",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontFamily: "Agradian"),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 30,
                          left: 10,
                          right: 10,
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 150,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: const TextSpan(
                                          text: "Start Your Trip",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 22),
                                          children: [
                                        TextSpan(
                                            text: "(Mandatory)",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 88, 87, 87),
                                                fontFamily: "Poppins",
                                                fontSize: 13))
                                      ])),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          style:
                                              TextStyle(fontFamily: "Poppins"),
                                          controller: _origin,
                                          decoration: InputDecoration(
                                              hintText: "Depart Location"),
                                        )),
                                        SizedBox(width: 20),
                                        FaIcon(
                                          FontAwesomeIcons.arrowsLeftRight,
                                          size: 28,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: TextField(
                                            style: TextStyle(
                                                fontFamily: "Poppins"),
                                            controller: _destiny,
                                            decoration: InputDecoration(
                                                hintText: "Destiny Location"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange),
                                      onPressed: () {
                                        if (_origin.text != "" &&
                                            _destiny != "") {
                                          MapUtils.openMap(
                                              _origin.text, _destiny.text);
                                        }
                                      },
                                      child: Text(
                                        "Open in Google Map",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Journey Name",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Poppins",
                                            fontSize: 22),
                                        children: [
                                      TextSpan(
                                          text: "(Mandatory)",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 87, 87),
                                              fontFamily: "Poppins",
                                              fontSize: 13))
                                    ])),
                                TextField(
                                  controller: _journeyName,
                                  style: const TextStyle(fontFamily: "Poppins"),
                                  decoration: const InputDecoration(
                                    hintText: "Vacation Trip",
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 100,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Journey Date",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 22),
                                          children: [
                                        TextSpan(
                                            text: "(Mandatory)",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 88, 87, 87),
                                                fontFamily: "Poppins",
                                                fontSize: 13))
                                      ])),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _startDate,
                                          style:
                                              TextStyle(fontFamily: "Poppins"),
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Journey Start Date yyyy-MM-dd",
                                              suffixIcon: Icon(Icons
                                                  .calendar_month_outlined)),
                                          onTap: () => _pickdate(_startDate),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            controller: _endDate,
                                            style: TextStyle(
                                                fontFamily: "Poppins"),
                                            decoration: InputDecoration(
                                                hintText: "Journey End Date",
                                                suffixIcon: Icon(Icons
                                                    .calendar_month_outlined)),
                                            onTap: () => _pickdate(_endDate)),
                                      )
                                    ],
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Activities",
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 22)),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  height: 200,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Expanded(
                                    child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                        controller: _todo,
                                        maxLines: 20),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange),
                                            onPressed: () async {
                                              if (_origin.text != "" &&
                                                  _destiny.text != "" &&
                                                  _journeyName.text != "" &&
                                                  _startDate.text != "" &&
                                                  _endDate.text != "") {
                                                DateTime newStartDate =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .parse(_startDate.text);
                                                DateTime newEndDate =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .parse(_endDate.text);
                                                final String ToDO = _todo.text;
                                                await _travelling.add({
                                                  "origin": _origin.text,
                                                  "destination": _destiny.text,
                                                  "JourneyName":
                                                      _journeyName.text,
                                                  "startdate": newStartDate,
                                                  "enddate": newEndDate,
                                                  "todo": _todo.text
                                                });
                                                Navigator.of(context).pop();
                                                _journeyName.text = "";
                                                _destiny.text = "";
                                                _origin.text = "";
                                                _startDate.text = "";
                                                _endDate.text = "";
                                                _todo.text = "";
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Alert!"),
                                                        content: Text(
                                                            "Fill all Mandatory Fields"),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Ok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 241, 241, 241)),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Poppins",
                                                    color: Colors.orange))),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    // UPDATE
    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _journeyName.text = documentSnapshot["JourneyName"];
        _destiny.text = documentSnapshot["destination"];
        _origin.text = documentSnapshot["origin"];

        Timestamp TimeStampSD = documentSnapshot['startdate'];
        DateTime DStartDate = DateTime.parse(TimeStampSD.toDate().toString());
        Timestamp TimeStampED = documentSnapshot['enddate'];
        DateTime DEndDate = DateTime.parse(TimeStampED.toDate().toString());
        _startDate.text = DateFormat("yyyy-MM-dd").format(DStartDate);
        _endDate.text = DateFormat("yyyy-MM-dd").format(DEndDate);
        _todo.text = documentSnapshot['todo'];
      }
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Text(
                      "Yusafir...",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontFamily: "Agradian"),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 30,
                          left: 10,
                          right: 10,
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 150,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: const TextSpan(
                                          text: "Start Your Trip",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 22),
                                          children: [
                                        TextSpan(
                                            text: "(Mandatory)",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 88, 87, 87),
                                                fontFamily: "Poppins",
                                                fontSize: 13))
                                      ])),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          style:
                                              TextStyle(fontFamily: "Poppins"),
                                          controller: _origin,
                                          decoration: InputDecoration(
                                              hintText: "Depart Location"),
                                        )),
                                        SizedBox(width: 20),
                                        FaIcon(
                                          FontAwesomeIcons.arrowsLeftRight,
                                          size: 28,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: TextField(
                                            style: TextStyle(
                                                fontFamily: "Poppins"),
                                            controller: _destiny,
                                            decoration: InputDecoration(
                                                hintText: "Destiny Location"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange),
                                      onPressed: () {
                                        if (_origin.text != "" &&
                                            _destiny != "") {
                                          MapUtils.openMap(
                                              _origin.text, _destiny.text);
                                        }
                                      },
                                      child: Text(
                                        "Open in Google Map",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Journey Name",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Poppins",
                                            fontSize: 22),
                                        children: [
                                      TextSpan(
                                          text: "(Mandatory)",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 87, 87),
                                              fontFamily: "Poppins",
                                              fontSize: 13))
                                    ])),
                                TextField(
                                  controller: _journeyName,
                                  style: const TextStyle(fontFamily: "Poppins"),
                                  decoration: const InputDecoration(
                                    hintText: "Vacation Trip",
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 100,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Journey Date",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 22),
                                          children: [
                                        TextSpan(
                                            text: "(Mandatory)",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 88, 87, 87),
                                                fontFamily: "Poppins",
                                                fontSize: 13))
                                      ])),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _startDate,
                                          style:
                                              TextStyle(fontFamily: "Poppins"),
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Journey Start Date yyyy-MM-dd",
                                              suffixIcon: Icon(Icons
                                                  .calendar_month_outlined)),
                                          onTap: () => _pickdate(_startDate),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            controller: _endDate,
                                            style: TextStyle(
                                                fontFamily: "Poppins"),
                                            decoration: InputDecoration(
                                                hintText: "Journey End Date",
                                                suffixIcon: Icon(Icons
                                                    .calendar_month_outlined)),
                                            onTap: () => _pickdate(_endDate)),
                                      )
                                    ],
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Activities",
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 22)),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  height: 200,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Expanded(
                                    child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                        controller: _todo,
                                        maxLines: 20),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange),
                                            onPressed: () async {
                                              if (_origin.text != "" &&
                                                  _destiny.text != "" &&
                                                  _journeyName.text != "" &&
                                                  _startDate.text != "" &&
                                                  _endDate.text != "") {
                                                DateTime newStartDate =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .parse(_startDate.text);
                                                DateTime newEndDate =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .parse(_endDate.text);
                                                final String ToDO = _todo.text;
                                                await _travelling
                                                    .doc(documentSnapshot!.id)
                                                    .update({
                                                  "origin": _origin.text,
                                                  "destination": _destiny.text,
                                                  "JourneyName":
                                                      _journeyName.text,
                                                  "startdate": newStartDate,
                                                  "enddate": newEndDate,
                                                  "todo": _todo.text
                                                });
                                                Navigator.of(context).pop();
                                                _journeyName.text = "";
                                                _destiny.text = "";
                                                _origin.text = "";
                                                _startDate.text = "";
                                                _endDate.text = "";
                                                _todo.text = "";
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Alert!"),
                                                        content: Text(
                                                            "Fill all Mandatory Fields"),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Ok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 241, 241, 241)),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Poppins",
                                                    color: Colors.orange))),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    // DELETE
    Future<void> _delete(String productid) async {
      await _travelling.doc(productid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have Successfully deleted the Plan")));
    }

    // VIEW
    Future<void> _Display([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _journeyName.text = documentSnapshot["JourneyName"];
        _destiny.text = documentSnapshot["destination"];
        _origin.text = documentSnapshot["origin"];

        Timestamp TimeStampSD = documentSnapshot['startdate'];
        DateTime DStartDate = DateTime.parse(TimeStampSD.toDate().toString());
        Timestamp TimeStampED = documentSnapshot['enddate'];
        DateTime DEndDate = DateTime.parse(TimeStampED.toDate().toString());
        _startDate.text = DateFormat("yyyy-MM-dd").format(DStartDate);
        _endDate.text = DateFormat("yyyy-MM-dd").format(DEndDate);
        _todo.text = documentSnapshot['todo'];
      }

      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset("assets/images/i1.png", scale: 4),
                            Image.asset("assets/images/i2.png", scale: 4),
                            Image.asset("assets/images/i3.png", scale: 4),
                            Image.asset("assets/images/i4.png", scale: 4),
                            Image.asset("assets/images/i5.png", scale: 4)
                          ],
                        ),
                      ),
                      Divider(thickness: 1),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: 380,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      documentSnapshot!['JourneyName'],
                                      style: TextStyle(
                                          fontFamily: "Poppins", fontSize: 28),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 35,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Start Date",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15)),
                                        Text(_startDate.text,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 17))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("End Date",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15)),
                                        Text(_endDate.text,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 17))
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Depart",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15)),
                                        Text(documentSnapshot['origin'],
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 17))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Destination",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15)),
                                        Text(documentSnapshot['destination'],
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 17))
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Activities",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 20)),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          height: 120,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(documentSnapshot['todo'],
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 17))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Align(
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () => _startPlanning(),
              child: Text(
                "+",
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
            ),
            alignment: Alignment(0, 0.9)),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 350,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            )),
                        Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.airplanemode_on,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            ))
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Welcom to",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                      fontSize: 35,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  "Yusafir...",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 40,
                                      fontFamily: "Agradian"),
                                )
                              ],
                            ),
                            Image.asset(
                              "assets/images/air.png",
                              scale: 3,
                            )
                          ],
                        )),
                    Center(
                      child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 200,
                                  child: TextField(
                                    cursorColor: Theme.of(context).primaryColor,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  )),
                              Icon(
                                Icons.search_outlined,
                                size: 28,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: _travelling.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return GridView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              Timestamp TimeStampSD =
                                  documentSnapshot['startdate'];
                              DateTime DStartDate = DateTime.parse(
                                  TimeStampSD.toDate().toString());

                              Timestamp TimeStampED =
                                  documentSnapshot['enddate'];
                              DateTime DEndDate = DateTime.parse(
                                  TimeStampED.toDate().toString());

                              events.addAll({
                                DStartDate: [
                                  Event(documentSnapshot['JourneyName'])
                                ]
                              });

                              return Slidable(
                                startActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) =>
                                            _update(documentSnapshot),
                                        icon: Icons.edit,
                                        label: "Edit",
                                      )
                                    ]),
                                endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) =>
                                            _delete(documentSnapshot.id),
                                        icon: Icons.delete,
                                        label: "Delete",
                                      )
                                    ]),
                                child: InkWell(
                                  onTap: () => _Display(documentSnapshot),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/bg1.jpg"),
                                            fit: BoxFit.cover),
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blue.shade200,
                                              blurRadius: 10)
                                        ]),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${documentSnapshot["origin"]} - ${documentSnapshot["destination"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${DateFormat('MMMd').format(DStartDate)} - ${DateFormat('MMMd').format(DEndDate)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      })),
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(171, 158, 158, 158),
                          blurRadius: 10)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.home,
                          color: Colors.orange,
                          size: 32,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.place_outlined, size: 32)),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarPage(events))),
                        icon: const Icon(Icons.calendar_month_outlined,
                            size: 32)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_outline, size: 32))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
