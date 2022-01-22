import 'dart:async';
import 'package:auto_vaccine/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen>
    with WidgetsBindingObserver {
  Widgets wid = Widgets();

  checkSlots(String pincode) async {
    if (Widgets.notify == true) {
      var response = await Dio().get(
          "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=$pincode&date=${Widgets.date.day}-${Widgets.date.month}-${Widgets.date.year}");
      setState(() {
        Widgets.validate1 = false;
        Widgets.firstData = response.data['sessions'];
      });
      for (int i = 0; i < Widgets.firstData.length; i++) {
        if (Widgets.age == null &&
            Widgets.vaccineName == null &&
            Widgets.dose == null &&
            Widgets.firstData[i]['available_capacity'] != 0 &&
            Widgets.firstData[i]['fee'] == '0') {
          wid.showNotification(
              Widgets.firstData[i]['name'].toString(),
              i,
              Widgets.firstData[i]['available_capacity'].toString(),
              Widgets.firstData[i]['available_capacity_dose1'].toString(),
              Widgets.firstData[i]['available_capacity_dose2'].toString(),
              Widgets.firstData[i]['vaccine'].toString(),
              Widgets.firstData[i]['min_age_limit'].toString());
        }
        if (Widgets.firstData[i]['available_capacity'] != 0 &&
            Widgets.firstData[i]['available_capacity_${Widgets.dose}'] != 0 &&
            Widgets.firstData[i]['vaccine'] == Widgets.vaccineName &&
            Widgets.firstData[i]['min_age_limit'] == Widgets.age &&
            Widgets.firstData[i]['fee'] == '0') {
          wid.showNotification(
              Widgets.firstData[i]['name'].toString(),
              i,
              Widgets.firstData[i]['available_capacity'].toString(),
              Widgets.firstData[i]['available_capacity_dose1'].toString(),
              Widgets.firstData[i]['available_capacity_dose2'].toString(),
              Widgets.firstData[i]['vaccine'].toString(),
              Widgets.firstData[i]['min_age_limit'].toString());
        }
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      if (Widgets.pinCodeTaker1 != null) {
        Widgets.timer1 = Timer.periodic(Duration(seconds: 30), (Timer t) {
          checkSlots(Widgets.pinCodeTaker1.text);
        });
      } else
        return null;
      if (Widgets.pinCodeTaker2 != null) {
        Widgets.timer2 = Timer.periodic(Duration(seconds: 60),
            (Timer t) => checkSlots(Widgets.pinCodeTaker2.text));
      } else
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                controller: Widgets.pinCodeTaker1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Enter First Pincode",
                  errorText: Widgets.validate1 ? 'Enter correct pincode' : null,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                controller: Widgets.pinCodeTaker2,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Enter Second Pincode ( optional )",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Select Vaccine",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              height: 50,
              width: 165,
              child: CheckboxListTile(
                title: Text(
                  "COVISHIELD",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                value: Widgets.covishield,
                activeColor: Colors.greenAccent,
                onChanged: (newValue) {
                  setState(() {
                    Widgets.notify = false;
                    Widgets.covaxin = false;
                    Widgets.sputnik = false;
                    Widgets.vaccineSelected = newValue;
                    Widgets.covishield = newValue;
                    Widgets.vaccineName = 'COVISHIELD';
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Container(
              height: 50,
              width: 165,
              child: CheckboxListTile(
                title: Text(
                  "COVAXIN",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                value: Widgets.covaxin,
                activeColor: Colors.greenAccent,
                onChanged: (newValue) {
                  setState(() {
                    Widgets.notify = false;
                    Widgets.covishield = false;
                    Widgets.sputnik = false;
                    Widgets.vaccineSelected = newValue;
                    Widgets.covaxin = newValue;
                    Widgets.vaccineName = 'COVAXIN';
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Container(
              height: 50,
              width: 165,
              child: CheckboxListTile(
                title: Text(
                  "SPUTNIK V",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                value: Widgets.sputnik,
                activeColor: Colors.greenAccent,
                onChanged: (newValue) {
                  setState(() {
                    Widgets.notify = false;
                    Widgets.covishield = false;
                    Widgets.covaxin = false;
                    Widgets.vaccineSelected = newValue;
                    Widgets.sputnik = newValue;
                    Widgets.vaccineName = 'SPUTNIK V';
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Select Dose",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  width: 165,
                  child: CheckboxListTile(
                    title: Text(
                      "Dose 1",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: Widgets.dose1,
                    activeColor: Colors.greenAccent,
                    onChanged: (newValue) {
                      setState(() {
                        Widgets.doseSelected = newValue;
                        Widgets.notify = false;
                        Widgets.dose2 = false;
                        Widgets.dose1 = newValue;
                        Widgets.dose = "dose1";
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  height: 50,
                  width: 165,
                  child: CheckboxListTile(
                    title: Text(
                      "Dose 2",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: Widgets.dose2,
                    activeColor: Colors.greenAccent,
                    onChanged: (newValue) {
                      setState(() {
                        Widgets.doseSelected = newValue;
                        Widgets.notify = false;
                        Widgets.dose1 = false;
                        Widgets.dose2 = newValue;
                        Widgets.dose = "dose2";
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            Text(
              "Select Age",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  width: 120,
                  child: CheckboxListTile(
                    title: Text(
                      "15 +",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: Widgets.fifteen,
                    activeColor: Colors.greenAccent,
                    onChanged: (newValue) {
                      setState(() {
                        Widgets.ageSelected = newValue;
                        Widgets.notify = false;
                        Widgets.fortyfive = false;
                        Widgets.eighteen = false;
                        Widgets.fifteen = newValue;
                        Widgets.age = 15;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  height: 50,
                  width: 120,
                  child: CheckboxListTile(
                    title: Text(
                      "18 +",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: Widgets.eighteen,
                    activeColor: Colors.greenAccent,
                    onChanged: (newValue) {
                      setState(() {
                        Widgets.ageSelected = newValue;
                        Widgets.notify = false;
                        Widgets.fortyfive = false;
                        Widgets.fifteen = false;
                        Widgets.eighteen = newValue;
                        Widgets.age = 18;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  height: 50,
                  width: 120,
                  child: CheckboxListTile(
                    title: Text(
                      "45 +",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: Widgets.fortyfive,
                    activeColor: Colors.greenAccent,
                    onChanged: (newValue) {
                      setState(() {
                        Widgets.ageSelected = newValue;
                        Widgets.notify = false;
                        Widgets.eighteen = false;
                        Widgets.fifteen = false;
                        Widgets.fortyfive = newValue;
                        Widgets.age = 45;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                if (Widgets.notify == true) {
                  ask(BuildContext context) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Stop Notification"),
                            actions: [
                              TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    setState(() {
                                      Widgets.notify = false;
                                      Navigator.pop(context);
                                    });
                                  }),
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }

                  ask(context);
                } else if (Widgets.pinCodeTaker1.text.isEmpty ||
                    Widgets.pinCodeTaker1.text.length != 6) {
                  setState(() {
                    Widgets.validate1 = true;
                  });
                } else {
                  setState(() {
                    Widgets.notify = true;
                    Widgets.validate1 = false;
                  });
                }
              },
              child: Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Send Notification",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Divider(),
                    Icon(
                      Widgets.notify
                          ? Icons.notifications_active_sharp
                          : Icons.notifications_active_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We will notify when new slots are available in the given pincode for ${Widgets.date.day}-${Widgets.date.month}-${Widgets.date.year}. "
              "Please don\'t remove this application from your recent apps ",
              style: TextStyle(
                  color: Widgets.notify ? Colors.white : Colors.transparent,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
