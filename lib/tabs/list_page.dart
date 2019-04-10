import 'package:flutter/material.dart';
import 'package:crm/style/theme.dart' as Theme;
import 'package:crm/controllers/database_controller.dart';
import 'package:crm/components/alert_box.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with SingleTickerProviderStateMixin{
  List customers;
  String uid;

  @override
  void initState() {
    getUserId();
    super.initState();
  }
  void getUserId() async {
    String temp=await DatabaseController.getCurrentUser();
    setState((){
      uid = temp;
    });
  }
  @override
  Widget build(BuildContext context) {

    void _openAddEntryDialog() {
       Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) {
            return new AddEntryDialog(
              whereFrom: false,
            );
          },
          fullscreenDialog: true
      ));
    }
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
                child: DatabaseController.customerInfo(context,uid),
            ),
          ],
        ));

    return Scaffold(
        body: makeBody,
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              _openAddEntryDialog();
            },
            backgroundColor: Color(0xFF2B4876),
            child: Icon(Icons.person_add)),
    );
  }
}
