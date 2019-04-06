import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crm/components/customer_card.dart';
import 'package:uuid/uuid.dart';
import 'package:crm/components/card_blocks.dart';
import 'package:toast/toast.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crm/components/remarks_card.dart';
import 'package:crm/model/customer.dart';


class DatabaseController {
  static Future<String> getCurrentUser() async{
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  static dynamic customerInfo(BuildContext context,String uid)  {
    return StreamBuilder(
        stream: Firestore.instance.collection('customers').where('uid',isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading.. Please Wait');
          }
          return new ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomerCard(
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['status'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['customerName'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['address'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['contactNumber'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['location'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['cid']);
            },
          );
        });
  }
  static dynamic insertNotifications(String date,String cid,String name,BuildContext context, FlutterLocalNotificationsPlugin f,DateTime d) async {

    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid= user.uid;
    int count;
    Firestore.instance
        .collection('Notifications')
        .document(cid).get().then((c){
          if(c.exists){
            count=c.data['notificationCounter']+1;
          }
          else {
              count=1;
            }
        });
    var random = new Random();
    int rnd=random.nextInt(99999);
    var fi=Firestore.instance
        .collection('Notifications')
        .document(cid);
    fi.get().then((docSnap){
      if(docSnap.exists) {
        if (docSnap.data['status'] == 'incomplete') {
          Toast.show("You have not followed up last time!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          print('You have not followed up last time!');
        }
        else{
          notif(f, d, name,rnd);
          Firestore.instance
              .collection('Notifications')
              .document(cid)
              .setData({
            "notificationCounter":count,
            "name": name,
            "status": 'incomplete',
            "uid":uid,
            "cid": cid
          });
          Firestore.instance
              .collection('Notifications')
              .document(cid)
              .collection('customerSpecific')
              .document((count).toString())
              .setData({
            "lnid":rnd,
            "date": date,
            "remarks":''
          });
        }
      }
        else{

          notif(f, d, name,rnd);
          Firestore.instance
              .collection('Notifications')
              .document(cid)
              .setData({
            "notificationCounter":1,
            "name": name,
            "status": 'incomplete',
            "uid":uid,
            "cid": cid
          });
          Firestore.instance
              .collection('Notifications')
              .document(cid)
              .collection('customerSpecific')
              .document((count).toString())
              .setData({
            "lnid":rnd,
            "date": date,
            "remarks":''
          });
        }
    });
  }
    static dynamic notificationInfo(BuildContext context,String uid) {
      return StreamBuilder(
          stream:Firestore.instance.collection('Notifications').where('uid',isEqualTo: uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading.. Please Wait');
            }
            return new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return CardBlocks(
                    snapshot.data.documents[index]['status'],
                    snapshot.data.documents[index]['name'],
                    snapshot.data.documents[index]['cid'],
                 /*   (){
                      print(index);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type AlertDialog
                      return AlertDialog(
                        title: new Text("Follow up Status"),
                        content: new Text("Mark as completed"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          new FlatButton(
                            child: new Text("Complete"),
                            onPressed: () {
                              int i=index+1;
                              print('index: '+(i).toString());
                              Firestore.instance
                                  .collection('Notifications')
                              .document(i.toString())
                              .updateData({
                                "name": snapshot.data.documents[index]['name'],
                                "status": 'complete'
                              });
                              Navigator.of(context).pop();
                            },
                          ),
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
                }*/
                    );
              },
            );
          });
    }

    static void notif(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,DateTime date,String customerName,int x)async{
      FlutterLocalNotificationsPlugin f=flutterLocalNotificationsPlugin;
      var android=new AndroidNotificationDetails('channel id',
          'karkar',
          'CHANNEL DESCRIPTION',
          importance: Importance.Max,priority: Priority.High,
          channelAction: AndroidNotificationChannelAction.CreateIfNotExists);
      var ios= new IOSNotificationDetails();
      var notificationDetails=new NotificationDetails(android, ios);
//        var scheduledNotificationDateTime =
//        new DateTime.now().add(new Duration(seconds: 5));
      print(date);
      await f.schedule(
          x,
          'Reminder:',
          'follow up: '+ customerName,
          date,
          notificationDetails
      );
    }
    static void addCustomerSave(String name,String phoneNumber,String email,String address,String clientStatus)async{
      FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      FirebaseUser user = await _firebaseAuth.currentUser();
      String uid= user.uid;
      print("Client Name: "+ name);
      print("Phone: Number: "+ phoneNumber);
      print("Email: "+ email);
      print("Add: "+ address);
      print("status: "+clientStatus);
      var uuid = new Uuid();
      String nid=uuid.v1();
      var snap=Firestore.instance.collection('customers').getDocuments().then((s){
        print(s.documents.length);
      });
      Firestore.instance.collection('customers').document().setData({
        'uid':uid,
        'cid':nid,
        'address':address,
        'customerName':name,
        'contactNumber':phoneNumber,
        'email':email,
        'status':clientStatus.toLowerCase()
      });
    }
  static dynamic remarkInfo(BuildContext context,String cid,String name,TextEditingController c) {
    print(cid);
    return StreamBuilder(
        stream:Firestore.instance.collection('Notifications').document(cid).collection('customerSpecific').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading.. Please Wait');
          }
          return new ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            reverse: false,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return RemarksCard(
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['date'],
                  snapshot.data.documents[snapshot.data.documents.length-index-1]['remarks'],
                      (){
                    print(index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type AlertDialog
                        return AlertDialog(
                          title: new Text("Add Remark"),
                          content: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            children:<Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                            decoration: new InputDecoration(hintText: "add remark",
                            border: OutlineInputBorder()),
                            controller: c,
                          )
                          ),
                            ]
                          ),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text("Complete"),
                              onPressed: () {
                                int i=snapshot.data.documents.length-index;
                                print('index: '+(i).toString());
                                Firestore.instance
                                    .collection('Notifications')
                                    .document(cid)
                                    .updateData({
                                  "status": 'complete'
                                });
                                /*Firestore.instance
                                    .collection('Notifications')
                                    .document(cid)
                                    .collection('customerSpecific')
                                    .document(i.toString())
                                    .get().then((c){
                                      if(c.exists){
                                        String lnid=c.data['lnid'];

                                      }
                                });*/

                                if(c.text!="") {
                                  Firestore.instance
                                      .collection('Notifications')
                                      .document(cid)
                                      .collection('customerSpecific')
                                      .document(i.toString())
                                      .updateData({
                                    "remarks": c.text
                                  });
                                  Navigator.of(context).pop();
                                }
                                else{
                                    Navigator.of(context).pop();
                                    Toast.show('Review cannot be blank', context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                }
                              },
                            ),
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
              );
            },
          );
        });
  }

    }
