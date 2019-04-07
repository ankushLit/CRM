import 'package:flutter/material.dart';
import 'package:crm/pages/detail_page.dart';
class DetailsBottomSheet{

  static void openBottomSheet(context,status,
      customerName,
      address,
      contactNumber,
      location,
      cid){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return DetailPage(status,
              customerName,
              address,
              contactNumber,
              location,
              cid);

          /*Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );*/
        }
    );
  }
}