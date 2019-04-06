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
      //onTap: onPressed,
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
//            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(),
      ),
    )
    );


    /*return InkWell(
   onTap: () {onPressed();},
//      onTap: onPressed,
      child: new Card(
      color: Colors.white,
      elevation: 14.0,
      //shadowColor: Color(0x802196F3),
//      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: new Color(0xfff1c40f),
                borderRadius: BorderRadius.circular(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Image(image: new AssetImage('assets/icons/'+icon+'.png')),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    heading,
                    style: TextStyle(
                      color: new Color(0xfff1c40f),
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );*/
  }


}