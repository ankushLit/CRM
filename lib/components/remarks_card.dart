import 'package:flutter/material.dart';
import 'package:crm/animations/scale_animation.dart';

class RemarksCard extends StatelessWidget{
  final Function onPressed;
  final String heading;
  final String remarks;
  RemarksCard(this.heading,this.remarks,this.onPressed);

  @override
  Widget build(BuildContext context) {
    print(heading);
    List<String> date=heading.split(" ");
    ListTile makeListTile() => ListTile(
      onTap: onPressed,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          'Date: '+date[0],
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
                  child: Text('Time: '+date[1].substring(0,5)+'\nClient remarks: '+remarks,
                      style: TextStyle(color: Colors.black))),
            ),
          ],
        ),
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