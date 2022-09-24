// ignore_for_file: prefer_const_constructors, unused_import, depend_on_referenced_packages, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tejaswini_admin/constants.dart';
import 'package:tejaswini_admin/widgets.dart';
import 'package:tejaswini_admin/screens/location.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  void _registerPlatformInstance() {
    if (Platform.isAndroid) {
      GeolocatorAndroid.registerWith();
    } else if (Platform.isIOS) {
      GeolocatorApple.registerWith();
    }
  }

  String location = "";

  determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      location = '$position.latitude, $position.longitude';
    });
  }

  @override
  void initState() {
    _registerPlatformInstance();
    determinePosition();
    super.initState();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? currentUser = auth.currentUser;

    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  color: text,
                  content: "Welcome ${currentUser!.displayName.toString()}",
                  size: 20,
                  weight: FontWeight.normal),
              SizedBox(height: 20),
              CustomText(
                  color: text,
                  content: 'Inactive employees',
                  size: 20,
                  weight: FontWeight.w500),

              ContainerEmpStatus(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: db
                          .collection("employees")
                          .where('isWorking', isEqualTo: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            return InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController task =
                                            TextEditingController();
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          content: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 500,
                                            decoration: BoxDecoration(
                                                color: container,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CustomText(
                                                    color: text,
                                                    content:
                                                        '${document['name']} is offline',
                                                    size: 20,
                                                    weight: FontWeight.normal),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: accent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          document['task']
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return CustomText(
                                                            color: container,
                                                            content:
                                                                '${document['task'][index]}',
                                                            size: 20,
                                                            weight: FontWeight
                                                                .normal);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: TextField(
                                                          style: TextStyle(
                                                              letterSpacing: 0.5,
                                                              color: text,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.normal),
                                                          controller: task,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () async {
                                                          await db
                                                              .collection(
                                                                  "employees")
                                                              .doc(
                                                                  "${document['name']}")
                                                              .update({
                                                            "task": FieldValue
                                                                .arrayUnion([
                                                              task.text
                                                                  .toString()
                                                            ])
                                                          });
                                                          task.clear();
                                                          setState(() {});
                                                        },
                                                        child: CustomText(
                                                            color: text,
                                                            content: 'Add Task',
                                                            size: 20,
                                                            weight: FontWeight
                                                                .w400)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: CustomText(
                                    color: text,
                                    content: "${document['name']}",
                                    size: 20,
                                    weight: FontWeight.normal));
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              CustomText(
                  color: text,
                  content: 'Active employees',
                  size: 20,
                  weight: FontWeight.w500),
              //active employees status
              ContainerEmpStatus(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: db
                          .collection("employees")
                          .where('isWorking', isEqualTo: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            return InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController task =
                                            TextEditingController();
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          content: Container(
                                            padding: EdgeInsets.all(8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            decoration: BoxDecoration(
                                                color: container,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                CustomText(
                                                    color: text,
                                                    content:
                                                        '${document['name']}',
                                                    size: 20,
                                                    weight: FontWeight.normal),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: accent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          document['task']
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return CustomText(
                                                            color: container,
                                                            content:
                                                                '${document['task'][index]}',
                                                            size: 20,
                                                            weight: FontWeight
                                                                .normal);
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                // location
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Loc(
                                                                  lat: document[
                                                                          'location']
                                                                      [0],
                                                                  long: document[
                                                                          'location']
                                                                      [1])));
                                                      print(document['location'][0]);
                                                    },
                                                    child: CustomText(
                                                        color: text,
                                                        content:
                                                            "View Location",
                                                        size: 20,
                                                        weight:
                                                            FontWeight.normal)),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: TextField(
                                                          style: TextStyle(
                                                              letterSpacing: 0.5,
                                                              color: text,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.normal),
                                                          controller: task,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () async {
                                                          await db
                                                              .collection(
                                                                  "employees")
                                                              .doc(
                                                                  "${document['name']}")
                                                              .update({
                                                            "task": FieldValue
                                                                .arrayUnion([
                                                              task.text
                                                                  .toString()
                                                            ])
                                                          });
                                                          task.clear();
                                                          setState(() {});
                                                        },
                                                        child: CustomText(
                                                            color: text,
                                                            content: 'Add Task',
                                                            size: 20,
                                                            weight: FontWeight
                                                                .w400)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: CustomText(
                                    color: text,
                                    content: "${document['name']}",
                                    size: 20,
                                    weight: FontWeight.normal));
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
      drawer: Drawer(
        child: Scaffold(
          backgroundColor: back,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(backgroundColor: container),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(10),
                          shape: StadiumBorder(),
                          backgroundColor: container,
                          content: Text("Logout Success"),
                        ));
                      },
                      child: CustomText(
                          color: text,
                          weight: FontWeight.normal,
                          size: 20,
                          content: "Logout"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
