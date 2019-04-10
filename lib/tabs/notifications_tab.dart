import 'package:flutter/material.dart';
import 'package:crm/controllers/database_controller.dart';
import 'package:crm/style/theme.dart' as Theme;


class NotificationTab extends StatefulWidget {
  NotificationTab({Key key}) : super(key: key);
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  String uid;
  void getUserId() async {
    String temp=await DatabaseController.getCurrentUser();
    setState((){
      uid = temp;
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final makeBody = Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Theme.Colors.loginGradientStart,
                Color(0xFFFFFFFF)
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: DatabaseController.notificationInfo(context,uid),
            ),
          ],
        ));
    return Scaffold(
        body: makeBody,
    );
}
}
