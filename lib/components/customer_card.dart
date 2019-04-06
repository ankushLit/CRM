import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crm/model/customer.dart';
import 'package:crm/pages/detail_page.dart';
import 'package:crm/animations/scale_animation.dart';

class CustomerCard extends StatelessWidget{

  CustomerCard(this.status, this.customerName, this.address, this.contactNumber,
      this.location,this.cid);
  final String status;
  final String customerName;
  final String address;
  final String contactNumber;
  final String location;
  final String cid;
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile() => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.black26))),
        child: new Image(image: new AssetImage('assets/icons/'+status+'.png')),
      ),
      title: Text(
        customerName,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
//              Expanded(
//                  flex: 1,
//                  child: Container(
//                    // tag: 'hero',
//                    child: LinearProgressIndicator(
//                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
//                        value: lesson.indicatorValue,
//                        valueColor: AlwaysStoppedAnimation(Colors.green)),
//                  )), Commented ProgressBar
          Expanded(
//                flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text('Client Status: '+status,
                    style: TextStyle(color: Colors.black))),
          )
        ],
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(status,
                    customerName,
                    address,
                    contactNumber,
                    location,
                cid)
        )
        );
        },
    );

    return ScaleAnimation(child:Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .9)),
//            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(),
      ),
    )
    );
  }

}