import 'package:flutter/material.dart';
import 'package:crm/style/theme.dart' as Theme;
import 'package:crm/controllers/database_controller.dart';
import 'package:crm/components/alert_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/components/customer_card.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  List customers;
  String uid;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void getUserId() async {
    String temp = await DatabaseController.getCurrentUser();
    setState(() {
      uid = temp;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _initiateSearch(String val) {
    //   if (val.length == 0) {
    //     setState(() {
    //       queryResult = [];
    //       tempSearchStore = [];
    //     });
    //   }
    //   String capValue = val.substring(0, 1).toUpperCase() + val.substring(1);
    //   if (queryResult.length == 0 && val.length == 1) {
    //     DatabaseController.searchResults(val).then((QuerySnapshot docs) {
    //       for (var i = 0; i < docs.documents.length; i++) {
    //         // print(docs.documents[i].data);
    //         setState(() {
    //           queryResult.insert(i, docs.documents[i].data);
    //         });
    //       }
    //       print(queryResult);
    //     });
    //     print(queryResult);
    //   } else {
    //     tempSearchStore = [];
    //     print(queryResult);
    //     queryResult.forEach((element) {
    //       print(element);
    //       if (element['customerName'].startsWith(capValue)) {
    //         setState(() {
    //           tempSearchStore.add(element);
    //         });
    //       }
    //     });
    //   }
    //print(queryResult);
    // }

    void _openAddEntryDialog() {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) {
            return new AddEntryDialog(
              whereFrom: false,
            );
          },
          fullscreenDialog: true));
    }

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
                child:
                    DatabaseController.customerResidentialInfo(context, uid)),
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
