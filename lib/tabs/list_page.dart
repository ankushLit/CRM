import 'package:crm/model/customer.dart';
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
    //print("from list page: "+uid);
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
        //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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



/*List getCustomers() {
  return [
    Customer(
        name: "Ankush Karkar",
        statusColor: "red",
        clientStatus: "Hot",
        phoneNumber: "9033449415",
        indicatorValue: 0.33,
        price: 20,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Maharsh Patel",
        statusColor: "red",
        clientStatus: "Hot",
        phoneNumber: "8128202814",
        indicatorValue: 0.33,
        price: 50,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Harshyam Jadeja",
        statusColor: "yellow",
        phoneNumber: "9879612070",
        clientStatus: "Medium",
        indicatorValue: 0.66,
        price: 30,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "ICKU Shah",
        statusColor: "yellow",
        phoneNumber: "9727972479",
        clientStatus: "Medium",
        indicatorValue: 0.66,
        price: 30,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Kalpit Modi",
        statusColor: "blue",
        clientStatus: "Cold",
        indicatorValue: 1.0,
        price: 50,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Ankur Karkar",
        statusColor: "blue",
        clientStatus: "Cold",
        indicatorValue: 1.0,
        price: 50,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Observation at Junctions",
        statusColor: "black",
        clientStatus: "Not Interested",
        indicatorValue: 0.33,
        price: 50,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Reverse parallel Parking",
        statusColor: "yellow",
        clientStatus: "Medium",
        indicatorValue: 0.66,
        price: 30,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Customer(
        name: "Self Driving Car",
        statusColor: "black",
        clientStatus: "Not Interested",
        indicatorValue: 1.0,
        price: 50,
        remark:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.  ")
  ];
}*/
