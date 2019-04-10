import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crm/style/theme.dart' as Theme;
import 'package:crm/components/bubble_indication_painter.dart';
import 'package:crm/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _validatePassword = false;
  bool _validateEmail = false;
  bool _validateResetEmail = false;
  bool _validateSignupEmail = false;
  bool _validateSignupName = false;
  bool _validateSignupPassword = false;
  bool _validateSignupConfirmPassword = false;
  bool _validationLoginComplete = false;
  bool _validationSignupComplete = false;
  bool _passwordEqual = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  final FocusNode myFocusNodeResetPassword = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  final TextEditingController loginEmailController = new TextEditingController();
  final TextEditingController loginPasswordController = new TextEditingController();
  final TextEditingController resetPasswordController= new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  final TextEditingController signupEmailController = new TextEditingController();
  final TextEditingController signupNameController = new TextEditingController();
  final TextEditingController signupPasswordController = new TextEditingController();
  final TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  String _email;
  String _password;
  String _signupEmail;
  String _signupPassword;
  String _signupName;

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    resetPasswordController.dispose();
    signupEmailController.dispose();
    signupConfirmPasswordController.dispose();
    signupPasswordController.dispose();
    signupNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 175.0),
                  child: new Image(
                      width: 250.0,
                      height: 111.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/eldora_logo.png')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignUp(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText:
                                _validateEmail ? 'Please Enter Email' : null,
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText: _validatePassword
                                ? 'Please Enter Password'
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Theme.Colors.loginGradientEnd,
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (loginEmailController.text.isEmpty) {
                          _validateEmail = true;
                          _validationLoginComplete = false;
                        } else {
                          _validateEmail = false;
                          _validationLoginComplete = true;
                          _email = loginEmailController.text;
                        }
                        if (loginPasswordController.text.isEmpty) {
                          _validatePassword = true;
                          _validationLoginComplete = false;
                        } else {
                          _validatePassword = false;
                          _validationLoginComplete = true;
                          _password = loginPasswordController.text;
                        }
                      });
                      if (_validationLoginComplete) {
                        login();
                      }
                      //Navigator.pushNamed(context, '/second');
                    }),
//                    onPressed: () =>
//                        showInSnackBar("Login button pressed")),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  print('did come');
                  _showDialog();
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 390.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText: _validateSignupName
                                ? 'Please Enter Email'
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText: _validateSignupEmail
                                ? 'Please Enter Email'
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText: _validateSignupPassword
                                ? 'Please Enter Password'
                                : null,
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            labelText: _validateSignupConfirmPassword
                                ? 'Please Enter Password'
                                : _passwordEqual
                                    ? null
                                    : 'Password does not Match',
                            labelStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 14.0,
                                color: Color(0xffff0000)),
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmation",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 370.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Theme.Colors.loginGradientEnd,
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (signupEmailController.text.isEmpty) {
                        _validateSignupEmail = true;
                        _validationSignupComplete = false;
                      } else {
                        _validateSignupEmail = false;
                        _validationSignupComplete = true;
                        _signupEmail = signupEmailController.text;
                      }
                      if (signupNameController.text.isEmpty) {
                        _validateSignupName = true;
                        _validationSignupComplete = false;
                      } else {
                        _validateSignupName = false;
                        _validationSignupComplete = true;
                        _signupName = signupNameController.text;
                      }
                      if (signupPasswordController.text ==
                          signupConfirmPasswordController.text) {
                        if (signupPasswordController.text.isEmpty) {
                          _validateSignupPassword = true;
                          _validationSignupComplete = false;
                        } else {
                          _validateSignupPassword = false;
                          _validationSignupComplete = true;
                        }
                        if (signupConfirmPasswordController.text.isEmpty) {
                          _validateSignupConfirmPassword = true;
                          _validationSignupComplete = false;
                        } else {
                          _validateSignupConfirmPassword = false;
                          _validationSignupComplete = true;
                          _signupPassword =
                              signupConfirmPasswordController.text;
                        }
                      } else {
                        _passwordEqual = false;
                        _validationSignupComplete = false;
                      }
                      if (_validationSignupComplete) {
                        register();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void login() async {
    try {
      String userId = await widget.auth.userLogin(context, _email, _password);
      print(userId);
      if (userId == 'User Not Verified') {
        _signedOut();
        showInSnackBar(userId);
      } else {
        widget.onSignedIn();
      }
    } on PlatformException catch (e) {
      showInSnackBar(e.message);
    }
  }
  void _resetPassword() async{
    print('ohh yeah');
    if(!resetPasswordController.text.isEmpty) {
      try {
        await widget.auth.sendResetPasswordEmail(resetPasswordController.text);
      } on PlatformException catch (e) {
        showInSnackBar(e.message);
      }
    }
    else
      {
        showInSnackBar('Please Enter Email');
      }
  }
  void _signedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {}
  }

  void register() async {
    try {
      String userId = await widget.auth
          .moveToRegister(context, _signupEmail, _signupName, _signupPassword);
      showInSnackBar(userId);
    } on PlatformException catch (e) {
      showInSnackBar(e.message);
    }
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: TextField(
            focusNode: myFocusNodeResetPassword,
            controller: resetPasswordController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              labelText:
              _validateResetEmail ? 'Please Enter Email' : null,
              labelStyle: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 14.0,
                  color: Color(0xffff0000)),
              border: InputBorder.none,
              icon: Icon(
                FontAwesomeIcons.envelope,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: "Email Address",
              hintStyle: TextStyle(
                  fontFamily: "WorkSansSemiBold", fontSize: 17.0),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Send"),
              onPressed: () {
                _resetPassword();
                Navigator.of(context).pop();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
