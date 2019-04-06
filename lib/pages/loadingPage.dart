import 'package:flutter/material.dart';
import 'package:crm/pages/login_page.dart';
import 'package:crm/controllers/login_controller.dart';
import 'package:crm/pages/dash_board.dart';
class LoadingPage extends StatefulWidget {
  LoadingPage({this.auth});
  final BaseAuth auth;

  @override
  _LoadingPageState createState() => new _LoadingPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _LoadingPageState extends State<LoadingPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
          onSignedOut: _signedOut,
        );
      case AuthStatus.signedIn:
        return new DashBoard(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
