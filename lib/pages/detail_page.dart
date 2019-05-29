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
  final bool pgCnf;
  final String cid;
  final String email;
  final String typ;
  final String addressLine2;
  DetailPage(this.status, this.customerName, this.address, this.contactNumber,
      this.cid, this.email, this.addressLine2, this.pgCnf, this.typ);
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
    Future<void> _cnfOrder() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Confirmation'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to confirm the order ?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Confirm'),
                onPressed: () {
                  DatabaseController.addOrder(
                      widget.customerName,
                      widget.contactNumber,
                      widget.email,
                      widget.address,
                      'complete',
                      widget.addressLine2,
                      widget.cid,
                      widget.typ);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancle'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
            Image(
              height: MediaQuery.of(context).size.height * 0.041,
              image: AssetImage(
                  'assets/icons/' + widget.typ.toLowerCase() + '.png'),
            )
            // Icon(
            //   Icons.account_circle,
            //   color: Colors.black,
            //   size: MediaQuery.of(context).size.height * 0.041,
            // ),
            ,
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
            widget.address + ', ' + widget.addressLine2,
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
    final confirmOrderBtn = Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        child: Text('Confirm Order', style: TextStyle(color: Colors.white)),
        color: Color(0xFF2B4876),
        onPressed: _cnfOrder,
      ),
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            readButton,
            widget.pgCnf ? Container() : confirmOrderBtn
          ],
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
