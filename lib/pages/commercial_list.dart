import 'package:flutter/material.dart';
import 'package:crm/controllers/database_controller.dart';
import 'package:crm/style/theme.dart' as Theme;

class CommercialList extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<CommercialList> {
  String uid;
  void getUserId() async {
    String temp = await DatabaseController.getCurrentUser();
    setState(() {
      uid = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final makeBody = Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Theme.Colors.loginGradientStart, Color(0xFFFFFFFF)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Column(
          children: <Widget>[
            // ListView(
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     children: tempSearchStore.map((element) {
            //       print(element);
            //       return CustomerCard(
            //           element['status'],
            //           element['customerName'],
            //           element['address'],
            //           element['contactNumber'],
            //           element['location'],
            //           element['cid']);
            //     }).toList()),
            // Text(queryResult.toString())
            new Expanded(
                child: DatabaseController.customerCommercialInfo(context, uid)),
          ],
        ));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commercial',
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
