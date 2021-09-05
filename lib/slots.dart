import 'package:auto_vaccine/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Slots extends StatefulWidget {
  @override
  _Slots createState() => _Slots();
}

class _Slots extends State<Slots> {
  Widgets wid = Widgets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(" Available"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Widgets.searchData.length != 0
            ? ListView.builder(
                itemCount: Widgets.searchData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      wid.showNotification(
                          Widgets.searchData[index]['name'].toString(),
                          index,
                          Widgets.searchData[index]['available_capacity']
                              .toString(),
                          Widgets.searchData[index]['available_capacity_dose1']
                              .toString(),
                          Widgets.searchData[index]['available_capacity_dose2']
                              .toString(),
                          Widgets.searchData[index]['vaccine'].toString(),
                          Widgets.searchData[index]['min_age_limit']
                              .toString());
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 230,
                      color:
                          Widgets.searchData[index]['available_capacity'] != 0
                              ? Colors.red[900]
                              : Colors.grey[850],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Center  Name: ${Widgets.searchData[index]['name'].toString()}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Divider(),
                          Text(
                            "Available Slots: ${Widgets.searchData[index]['available_capacity'].toString()} ( D1: ${Widgets.searchData[index]['available_capacity_dose1'].toString()}, D2: ${Widgets.searchData[index]['available_capacity_dose2'].toString()} )",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Divider(),
                          Text(
                            "Status: ${Widgets.searchData[index]['fee_type'].toString()} ( ₹ ${Widgets.searchData[index]['fee'].toString()} )",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Divider(),
                          Text(
                            "Vaccine Name: ${Widgets.searchData[index]['vaccine'].toString()}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Divider(),
                          Text(
                            "Min Age: ${Widgets.searchData[index]['min_age_limit'].toString()} ",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Divider(),
                          Text(
                            "Time : ${Widgets.searchData[index]['slots'].toString()}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No centers available on",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Text(
                    "${Widgets.searchPinCodeTaker.text}",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Text(
                    "in",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Text(
                    "${Widgets.searchSelectedDate.day}-${Widgets.searchSelectedDate.month}-${Widgets.searchSelectedDate.year}",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
      ),
    );
  }
}
