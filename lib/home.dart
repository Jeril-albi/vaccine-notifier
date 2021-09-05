import 'dart:async';

import 'package:auto_vaccine/Notification.dart';
import 'package:auto_vaccine/slots.dart';
import 'package:auto_vaccine/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with WidgetsBindingObserver {
  bool validate = false;
  Timer timer;
  Widgets wid = Widgets();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
              child: child,
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  surface: Colors.blue,
                ),
              ));
        },
        context: context,
        initialDate: Widgets.searchSelectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != Widgets.searchSelectedDate)
      setState(() {
        Widgets.searchSelectedDate = picked;
      });
  }

  fetchSlots() async {
    var response = await Dio().get(
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=${Widgets.searchPinCodeTaker.text}&date=${Widgets.searchSelectedDate.day}-${Widgets.searchSelectedDate.month}-${Widgets.searchSelectedDate.year}");
    setState(() {
      Widgets.searchData = response.data['sessions'];
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Slots()));
  }

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
        Widgets.timer1 = Timer.periodic(Duration(seconds: 30),
            (Timer t) => checkSlots(Widgets.pinCodeTaker1.text));
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
          title: Text("CoWin Notify"),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                    controller: Widgets.searchPinCodeTaker,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Enter Pincode",
                      errorText: validate ? 'Enter correct pincode' : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Date",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        }),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Date: ${Widgets.searchSelectedDate.day} - ${Widgets.searchSelectedDate.month} - ${Widgets.searchSelectedDate.year}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (Widgets.searchPinCodeTaker.text.isEmpty ||
                            Widgets.searchPinCodeTaker.text.length != 6) {
                          validate = true;
                        } else {
                          fetchSlots();
                          validate = false;
                        }
                      });
                    },
                    child: Text("Search"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: Container(
                    height: 35,
                    width: 155,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Set Notification",
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
              ],
            ),
          ),
        ));
  }
}
