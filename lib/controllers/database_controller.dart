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

class DatabaseController {
  static Future<String> getCurrentUser() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  static Future<List<String>> getCustomerDetailsToEdit(String cid) async {
    List<String> details = new List();
    await Firestore.instance
        .collection('customers')
        .where('cid', isEqualTo: cid)
        .snapshots()
        .first
        .then((doc) {
      doc.documents.forEach((d) {
        details.add(d.data['customerName']);
        details.add(d.data['email']);
        details.add(d.data['address']);
        details.add(d.data['contactNumber']);
        details.add(d.data['status']);
        details.add(d.data['addressLine2']);
      });
      print(details);
    });
    return details;
  }

  static dynamic customerInfo(BuildContext context, String uid) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('customers')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: 
            Text('Loading.. Please Wait')
            ,);
          }
          return new ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomerCard(
                  snapshot.data.documents[snapshot.data.documents.length - index - 1]
                      ['status'],
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['customerName'],
                  snapshot.data.documents[snapshot.data.documents.length - index - 1]
                          ['address'] +
                      ', ' +
                      snapshot.data
                              .documents[snapshot.data.documents.length - index - 1]
                          ['addressLine2'],
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['contactNumber'],
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['location'],
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['cid']);
            },
          );
        });
  }

  static dynamic insertNotifications(
      String date,
      String cid,
      String name,
      BuildContext context,
      FlutterLocalNotificationsPlugin f,
      DateTime d) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    int count;
    Firestore.instance
        .collection('Notifications')
        .document(cid)
        .get()
        .then((c) {
      if (c.exists) {
        count = c.data['notificationCounter'] + 1;
      } else {
        count = 1;
      }
    });
    var random = new Random();
    int rnd = random.nextInt(99999);
    var fi = Firestore.instance.collection('Notifications').document(cid);
    fi.get().then((docSnap) {
      if (docSnap.exists) {
        if (docSnap.data['status'] == 'incomplete') {
          Toast.show("You have not followed up last time!", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          print('You have not followed up last time!');
        } else {
          notif(f, d, name, rnd);
          Firestore.instance.collection('Notifications').document(cid).setData({
            "notificationCounter": count,
            "name": name,
            "status": 'incomplete',
            "uid": uid,
            "cid": cid
          });
          Firestore.instance
              .collection('Notifications')
              .document(cid)
              .collection('customerSpecific')
              .document((count).toString())
              .setData({"lnid": rnd, "date": date, "remarks": ''});
        }
      } else {
        notif(f, d, name, rnd);
        Firestore.instance.collection('Notifications').document(cid).setData({
          "notificationCounter": 1,
          "name": name,
          "status": 'incomplete',
          "uid": uid,
          "cid": cid
        });
        Firestore.instance
            .collection('Notifications')
            .document(cid)
            .collection('customerSpecific')
            .document((count).toString())
            .setData({"lnid": rnd, "date": date, "remarks": ''});
      }
    });
  }

  static dynamic notificationInfo(BuildContext context, String uid) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Notifications')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: 
            Text('Loading.. Please Wait')
            ,);
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
              );
            },
          );
        });
  }

  static void notif(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      DateTime date,
      String customerName,
      int x) async {
    FlutterLocalNotificationsPlugin f = flutterLocalNotificationsPlugin;
    var android = new AndroidNotificationDetails(
        'channel id', 'karkar', 'CHANNEL DESCRIPTION',
        importance: Importance.Max,
        priority: Priority.High,
        channelAction: AndroidNotificationChannelAction.CreateIfNotExists);
    var ios = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(android, ios);
    print(date);
    await f.schedule(x, 'Reminder:', 'follow up: ' + customerName, date,
        notificationDetails);
  }

  static void editCustomerSave(String name, String phoneNumber, String email,
      String address, String clientStatus, String al2, String cid) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    print("Client Name: " + name);
    print("Phone: Number: " + phoneNumber);
    print("Email: " + email);
    print("Add: " + address);
    print("status: " + clientStatus);
    /* var snap=Firestore.instance.collection('customers').getDocuments().then((s){
      print(s.documents.length);
    });*/ //get length of documents.
    var x = await Firestore.instance
        .collection('customers')
        .where('cid', isEqualTo: cid)
        .getDocuments()
        .then((qs) {
      qs.documents.forEach((doc) {
        Firestore.instance
            .collection('customers')
            .document(doc.documentID)
            .updateData({
          'uid': uid,
          'address': address,
          'addressLine2': al2,
          'customerName': name,
          'contactNumber': phoneNumber,
          'email': email,
          'status': clientStatus.toLowerCase()
        });
      });
    });
  }

  static List queryResult = new List();
  static List tempSearchStore = new List();

  static Future<Widget> searchCust(String val) async {
    print(val.length);
    if (val.length == 0) {
      queryResult = [];
      tempSearchStore = [];
      return Container();
    }
    String capValue = val.substring(0, 1).toUpperCase() + val.substring(1);
    if (queryResult.length == 0 && val.length == 1) {
      await DatabaseController.searchResults(val).then((QuerySnapshot docs) {
        for (var i = 0; i < docs.documents.length; i++) {
          // print(docs.documents[i].data);
          queryResult.add(docs.documents[i].data);
        }
        //print(queryResult);
      });
      //print(queryResult);
    } else {
      tempSearchStore = [];
      // print(queryResult);
      queryResult.forEach((element) {
        // print(element);
        if (element['customerName'].startsWith(capValue)) {
          tempSearchStore.add(element);
        }
      });
    }
    return new ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: tempSearchStore.map((element) {
          print(element);
          return CustomerCard(
              element['status'],
              element['customerName'],
              element['address'],
              element['contactNumber'],
              element['location'],
              element['cid']);
        }).toList());
  }

  static searchResults(String val) {
    print(val);
    return Firestore.instance
        .collection('customers')
        .where('searchKey', isEqualTo: val.toUpperCase())
        .getDocuments();
  }

  static void addCustomerSave(String name, String phoneNumber, String email,
      String address, String clientStatus, String al2) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    String searchKey = name.substring(0, 1);
    print("Client Name: " + name);
    print("Phone: Number: " + phoneNumber);
    print("Email: " + email);
    print("Add: " + address);
    print("Search key " + searchKey);
    print("status: " + clientStatus);
    var uuid = new Uuid();
    String nid = uuid.v1();
    Firestore.instance.collection('customers').document().setData({
      'uid': uid,
      'cid': nid,
      'address': address,
      'addressLine2': al2,
      'customerName': name.substring(0, 1).toUpperCase() + name.substring(1),
      'contactNumber': phoneNumber,
      'email': email,
      'searchKey': searchKey.toUpperCase(),
      'status': clientStatus.toLowerCase()
    });
  }

  static dynamic remarkInfo(
      BuildContext context, String cid, String name, TextEditingController c) {
    print(cid);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Notifications')
            .document(cid)
            .collection('customerSpecific')
            .snapshots(),
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
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['date'],
                  snapshot.data
                          .documents[snapshot.data.documents.length - index - 1]
                      ['remarks'], () {
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
                          children: <Widget>[
                            Expanded(
                                child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                              decoration: new InputDecoration(
                                  hintText: "add remark",
                                  border: OutlineInputBorder()),
                              controller: c,
                            )),
                          ]),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Complete"),
                          onPressed: () {
                            int i = snapshot.data.documents.length - index;
                            print('index: ' + (i).toString());
                            Firestore.instance
                                .collection('Notifications')
                                .document(cid)
                                .updateData({"status": 'complete'});
                            if (c.text != "") {
                              Firestore.instance
                                  .collection('Notifications')
                                  .document(cid)
                                  .collection('customerSpecific')
                                  .document(i.toString())
                                  .updateData({"remarks": c.text});
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                              Toast.show('Review cannot be blank', context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.CENTER);
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
              });
            },
          );
        });
  }
}
