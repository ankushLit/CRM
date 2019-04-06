import 'package:flutter/material.dart';
import 'package:crm/model/customer.dart';
import 'package:crm/controllers/database_controller.dart';

class AddEntryDialog extends StatefulWidget {
  final Customer customer=new Customer();
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {

  @override
  void initState() {
    _currentStatus='Hot';
    //widget.customer.clientStatus=_currentStatus;
    super.initState();
  }
final TextEditingController line2=new TextEditingController();
  String _currentStatus;
  String _name;
  String _email;
  String _address;
  String _phoneNumber;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: const Text('New Customer'),
        actions: [
          new FlatButton(
              onPressed: () {
                //widget.customer.clientStatus=_currentStatus;
                //widget.customer.address+='`'+line2.text;
                setState(() {
                  _address+=', '+line2.text;
                });
                DatabaseController.addCustomerSave(_name,_phoneNumber,_email,_address,_currentStatus);
                Navigator.pop(context,true);
              },
              child: new Text('SAVE',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
        child: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Name",
              ),
              onChanged: assignName,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Phone",
              ),
              onChanged: assignPhoneNumber,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Email",
              ),
              onChanged: assignEmail,
            ),
          ),
          const Divider(
            height: 3.0,
          ),
          new ListTile(
            leading: new Image(image: new AssetImage('assets/icons/'+_currentStatus.toLowerCase()+'.png')),
            title: const Text('Status'),
            //subtitle: const Text('status'),
          ),
          new ListTile(
           //leading: new Image(image: new AssetImage('assets/icons/'+_currentStatus.toLowerCase()+'.png')),
            title:new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Radio(value: 'Hot', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s) ),
                    new Text('Hot'),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Radio(value: 'Medium', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s) ),
                    new Text('Medium'),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Radio(value: 'Cold', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s) ),
                    new Text('Cold'),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Radio(value: 'Disinterested', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s) ),
                    new Text('Not Interested'),
                  ],
                ),
              ],
            )
            /*new DropdownButton(
                    value: _currentStatus,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem
            )*/,
           // subtitle: const Text('status'),
          ),
          new ListTile(
            leading: const Icon(Icons.add_location),
            title: const Text('Address'),
            //subtitle: const Text('status'),
          ),
          new ListTile(
            //leading: const Icon(Icons.add_location),
            title: new TextField(
                  decoration: new InputDecoration(
                      hintText: "Line 1",
                      border: OutlineInputBorder(),
                  ),
              onChanged: assignAddressLineOne,
            )
          ),
          new ListTile(
              //leading: const Icon(Icons.add_location),
              title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Line 2 (optional)",
                    border: OutlineInputBorder(),
                  ),
                  controller: line2,
//                onChanged: assignAddressLineTwo,
              )
          )
        ],
      ),
    )
      )
    );
  }
  void getStatus(String status){
    setState(() {
      if(status=='Hot'){
        _currentStatus='Hot';
      } else if(status=='Cold'){
        _currentStatus='Cold';
      } else if(status=='Medium'){
        _currentStatus='Medium';
      }
      else{
        _currentStatus='Disinterested';
      }
    });
    //widget.customer.clientStatus=_currentStatus;
    print(_currentStatus);
  }
  void assignName(String s){
    setState(() {
      _name=s;
    });
    }
  void assignPhoneNumber(String s){
    setState(() {
      _phoneNumber=s;
    });
  }
  void assignEmail(String s){
    setState(() {
      _email=s;
    });
  }

  void assignAddressLineOne(String s){
    setState(() {
      _address=s;
    });
  }

}