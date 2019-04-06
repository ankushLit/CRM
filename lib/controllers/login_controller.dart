import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

abstract class BaseAuth {
  Future<String> userLogin(
      BuildContext context, String loginEmail, String loginPassword);
  Future<String> moveToRegister(BuildContext context, String signUpEmail,
      String name, String signupPassword);
  Future<String> sendResetPasswordEmail(String resetEmail);
  Future<String> currentUser();
  Future<void> signOut();
  Future<String> getName();
//  Future<void> getToken();
}

class LoginController implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//  final FirebaseMessaging _messaging=FirebaseMessaging();

  Future<String> userLogin(
      BuildContext context, String loginEmail, String loginPassword) async {
    bool verified = false;
    FirebaseUser user = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: loginEmail.trim(), password: loginPassword)
        .then((FirebaseUser u) {
      if (u.isEmailVerified) {
        verified = true;
      }
    });
    if (verified) {
      return 'Verified';
    } else {
      return 'User Not Verified';
    }
  }

  Future<String> moveToRegister(BuildContext context, String signUpEmail,
      String name, String signupPassword) async {
    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
    userUpdateInfo.displayName=name;
    FirebaseUser user = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: signUpEmail, password: signupPassword)
        .then((FirebaseUser u) {
      u.sendEmailVerification();
      u.updateProfile(userUpdateInfo);
    });
    if (user == null) {
      return 'Verification Email sent';
    } else {
      return user.uid;
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<String> getName()async{
    var user=await _firebaseAuth.currentUser();
    return user.displayName;
  }
  Future<String> sendResetPasswordEmail(String resetEmail) async {
    await _firebaseAuth.sendPasswordResetEmail(email: resetEmail);
    return 'Recovery Email Sent to: \n $resetEmail';
  }
  /*Future<void> getToken(){
    _messaging.getToken().then((token){
      print(token);
    });
  }*/
}
