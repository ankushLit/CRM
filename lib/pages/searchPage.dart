import 'package:flutter/material.dart';
import 'package:crm/controllers/database_controller.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String value = "";
  @override
  Widget build(BuildContext context) {
    var searchTextFeild = Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 0.0, left: 25.0, right: 25.0),
      child: TextField(
        autofocus: true,
        onChanged: (val) {
          setState(() {
            value = val;
          });
        },
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontFamily: "WorkSansSemiBold",
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "search",
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
        ),
      ),
    );

    var makeBody = Column(
      children: <Widget>[
        searchTextFeild,
        Expanded(
          child: FutureBuilder(
            future: DatabaseController.searchCust(value),
            initialData: Container(),
            builder: (BuildContext ctx, AsyncSnapshot<Widget> list) {
              return list.data;
            },
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFF2CB1D),
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: makeBody,
    );
  }
}
