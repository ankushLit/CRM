import 'package:crm/model/customer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crm/components/picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:crm/controllers/database_controller.dart';
import 'remarks_information_page.dart';

class DetailPage extends StatefulWidget {
  _State createState()=>new _State();
  final String status;
  final String customerName;
  final String address;
  final String contactNumber;
  final String location;
  final String cid;
  DetailPage(this.status, this.customerName, this.address, this.contactNumber,
      this.location,this.cid);
}

  class _State extends State<DetailPage>{
    DateTimePicker _picker;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


    @override
    void initState() {
      _picker = new DateTimePicker();
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var ios = new IOSInitializationSettings();
      var initSettings = new InitializationSettings(android, ios);
      flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification:onSelectNotification);
    }
    Future onSelectNotification(String payload){
      print('Pyaload: ${payload}');
       Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => RemarksPage(widget.customerName,widget.cid)));
    }

    void setNotification(DateTime date,BuildContext c)async{
          DatabaseController.insertNotifications(date.toString(), widget.cid, widget.customerName,c,flutterLocalNotificationsPlugin,date);

    }

    @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: new Image(image: new AssetImage('assets/icons/'+widget.status+'.png')),
      ),
    );

    final callCustomer = GestureDetector(
      child:Container(
      child: new Icon(
        Icons.phone,
        size: 40,
      ),
    ),
      onTap:()=> launch('tel://'+widget.contactNumber),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 90.0),
        ListTile(
          leading: Icon(
      Icons.account_circle,
      color: Colors.black,
      size: 40.0,
    ),
          trailing: Icon(Icons.edit,
      color: Colors.black,
      size: 30.0,
      ),
        ),
        SizedBox(height: 10.0),
        Text(
          widget.customerName,
          style: TextStyle(color: Colors.black, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.status + ' Client',
                      style: TextStyle(color: Colors.black),
                    ))),
            Expanded(flex: 1, child: callCustomer)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("drive-steering-wheel.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.all(30.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0xFFF2CB1D)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        )
      ],
    );

    final bottomContentText = new Text(
      "Address: "+widget.address,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                  setNotification(date,context);
                }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          color: Color(0xFF2B4876),
          child:
          Text("Schedule Follow Up", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
