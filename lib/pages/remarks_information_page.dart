import 'package:flutter/material.dart';
import 'package:crm/controllers/database_controller.dart';
import 'package:crm/style/theme.dart' as Theme;


class RemarksPage extends StatefulWidget {
  RemarksPage(this.customerName,this.cid,{Key key}) : super(key: key);
  _RemarksPageState createState() => _RemarksPageState();
  final String customerName;
  final String cid;
}

class _RemarksPageState extends State<RemarksPage> {
  TextEditingController _c = new TextEditingController();
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
              child: DatabaseController.remarkInfo(context,widget.cid,widget.customerName,_c),
            ),
          ],
        ));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customerName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFF2CB1D),
      ),
      body: makeBody,
    );
  }
}
