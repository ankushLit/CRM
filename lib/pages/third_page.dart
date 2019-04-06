import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThirdScreen extends StatefulWidget {
  ThirdScreen({Key key}) : super(key: key);

  @override
  _ThirdScreen createState() => new _ThirdScreen();
}
class _ThirdScreen extends State<ThirdScreen> {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String month = new DateFormat.MMMM().format(
    new DateTime.now(),
  );
  int index = new DateTime.now().month;
  void _selectforward() {
    if (index < 12)
      setState(() {
        ++index;
        month = months[index - 1];
      });
  }

  void _selectbackward() {
    if (index > 1)
      setState(() {
        --index;
        month = months[index - 1];
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Screen"),
      ),
      backgroundColor: Color(0x00000000),
      body: (new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: _selectbackward,
            ),
            new Text(
              month.toUpperCase(),
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            new IconButton(
              icon: new Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: _selectforward,
            ),
          ],
        )),
        floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.supervisor_account)
      ),
    );
  }
}