import 'dart:async';

import 'package:auto_vaccine/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Widgets {
 static TextEditingController searchPinCodeTaker  = TextEditingController();
 static TextEditingController pinCodeTaker1 = TextEditingController();
 static TextEditingController pinCodeTaker2 = TextEditingController();
 static TextEditingController phNumberTaker = TextEditingController();
 static List firstData = [];
 static List searchData = [];
 static var sheduledData;
 static DateTime searchSelectedDate = DateTime.now();
  static DateTime selectedDate = DateTime.now();
 static DateTime date = selectedDate.add(Duration(days: 1));
 static bool validate1 = false;
 static bool numValidate = false;
 static Timer timer1;
 static Timer timer2;
 static Timer autoTimer;
 static String vaccineName;
 static int age;
 static bool dose1 = false;
 static bool dose2 = false;
 static String dose;
 static bool covishield = false;
 static  bool covaxin = false;
 static  bool sputnik = false;
 static  bool  eighteen = false;
 static  bool fortyfive = false;
 static bool notify = false;
 static bool vaccineSelected = false;
 static bool ageSelected = false;
 static bool doseSelected = false;

  showNotification(String name,int increase,String avail,String dose1,String dose2,String availVaccine,String minAge) async{
   var androidNotify = AndroidNotificationDetails(
       'channel', 'name', 'description',
       color: Colors.teal,
    styleInformation: BigTextStyleInformation("Name: $name \nAvailable: $avail slots\nDose 1: $dose1 \nDose2: $dose2\nVaccine: $availVaccine\nAge: $minAge+ ")
   );
   var notify = NotificationDetails(android: androidNotify);

   await flutterLocalNotificationsPlugin.show(
       increase,
       'New Vaccination Slots Available',
       'Name: $name',
       notify,
   );
  }

}