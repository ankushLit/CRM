import 'package:flutter/material.dart';
import 'package:crm/animations/scale_animation.dart';
import 'package:crm/pages/remarks_information_page.dart';

class CardBlocks extends StatelessWidget{
  final String icon;
  final String heading;
  final String cid;
  CardBlocks(this.icon,this.heading,this.cid);

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
          child: new Image(image: new AssetImage('assets/icons/'+'complete'+'.png')),
        ),
        title: Text(
          heading,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Text('Client Status: '+icon,
                      style: TextStyle(color: Colors.black))),
            )
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
      onTap: () {
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => RemarksPage(heading,cid)
          ));
          });
    return ScaleAnimation(child:Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .9)),
        child: makeListTile(),
      ),
    )
    );
  }


}