import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crm/components/picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:crm/controllers/database_controller.dart';
import 'remarks_information_page.dart';
import 'package:crm/components/alert_box.dart';

class DetailPage extends StatefulWidget {
  _State createState() => new _State();
  final String status;
  final String customerName;
  final String address;
  final String contactNumber;
  final String location;
  final String cid;
  DetailPage(this.status, this.customerName, this.address, this.contactNumber,
      this.location, this.cid);
}

class _State extends State<DetailPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    print('Pyaload: ${payload}');
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                RemarksPage(widget.customerName, widget.cid)));
  }

  void setNotification(DateTime date, BuildContext c) async {
    DatabaseController.insertNotifications(date.toString(), widget.cid,
        widget.customerName, c, flutterLocalNotificationsPlugin, date);
  }

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: new Image(
            image: new AssetImage('assets/icons/' + widget.status + '.png')),
      ),
    );

    final callCustomer = GestureDetector(
      child: Container(
        child: new Icon(
          Icons.phone,
          color: Colors.black,
          size: MediaQuery.of(context).size.height * 0.04,
        ),
      ),
      onTap: () => launch('tel://' + '+91' + widget.contactNumber),
    );

    final topContentText = Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.edit,
                color: Colors.black,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new AddEntryDialog(
                        whereFrom: true,
                        cid: widget.cid,
                      );
                    },
                    fullscreenDialog: true));
              },
            ),
            Icon(
              Icons.account_circle,
              color: Colors.black,
              size: MediaQuery.of(context).size.height * 0.041,
            ),
            callCustomer
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                child: Text(
                  widget.customerName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.1),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.1),
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0xFFF2CB1D)),
          child: Center(
            child: topContentText,
          ),
        ),
      ],
    );

    final bottomContentText = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new ListTile(
          leading: levelIndicator,
          title: new Text(
            widget.status.substring(0, 1).toUpperCase() +
                widget.status.substring(1),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.location_city),
          title: new Text(
            widget.address,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
        ),
      ],
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.03),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            DatePicker.showDateTimePicker(context, showTitleActions: true,
                onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
              setNotification(date, context);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          color: Color(0xFF2B4876),
          child:
              Text("Schedule Follow Up", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
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
