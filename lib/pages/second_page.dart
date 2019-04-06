import 'package:flutter/material.dart';
import 'package:crm/controllers/login_controller.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({this.auth,this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signedOut() async{
    try{
    await auth.signOut();
    onSignedOut();
    } catch (e){

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _signedOut();
            // Navigate back to first screen when tapped!
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}