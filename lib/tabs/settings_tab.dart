import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:crm/controllers/login_controller.dart';
import 'package:crm/components/card_blocks.dart';

class SettingsTab extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  SettingsTab({Key key,this.auth,this.onSignedOut}) : super(key: key);
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  void _signedOut() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e){
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StaggeredGridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          children: <Widget>[
            /*CardBlocks(icon:Icons.email,
                heading:'Customers',
                color:0xfff1c40f),
            CardBlocks(icon:Icons.clear,
                heading:'Sign Out',
                color:0xfff1c40f,
              onPressed: _signedOut,),*/

          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 130.0),
            StaggeredTile.extent(1, 130.0)
          ],
        ));
  }
}
