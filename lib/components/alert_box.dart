import 'package:flutter/material.dart';
import 'package:crm/model/customer.dart';
import 'package:crm/controllers/database_controller.dart';

class AddEntryDialog extends StatefulWidget {
  final Customer customer=new Customer();
  final bool whereFrom;
  final String cid;
  AddEntryDialog({this.whereFrom,this.cid});
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {

  @override
  void initState() {
    print(widget.whereFrom);
    _currentStatus='Hot';
    check();
    //widget.customer.clientStatus=_currentStatus;
    super.initState();
  }
  String _currentStatus;
  String _name;
  String _email;
  String _address;
  String _phoneNumber;
  String _addressLine2;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _addressLine2Controller=new TextEditingController();
  final TextEditingController _phoneNumberController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;


  void check() async {
    List<String> data=new List();
    if(widget.whereFrom){
      data=await DatabaseController.getCustomerDetailsToEdit(widget.cid);
      setState(() {
        _name=data[0];
        _email=data[1];
        _address=data[2];
        _phoneNumber=data[3];
        _currentStatus=data[4].substring(0,1).toUpperCase()+data[4].substring(1);
        _addressLine2=data[5];
      });
      _emailController.text=_email;
      _addressController.text=_address;
      _addressLine2Controller.text=_addressLine2;
      _nameController.text=_name;
      _phoneNumberController.text=_phoneNumber;
    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _addressLine2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text(widget.whereFrom ? 'Edit Details':'New Customer'),
        backgroundColor: Color(0xFFF2CB1D),
        actions: [
          new FlatButton(
              onPressed: () {
                _validateInputs();
                //widget.customer.clientStatus=_currentStatus;
                //widget.customer.address+='`'+line2.text;
                if(widget.whereFrom){
                  print(widget.cid);
                  DatabaseController.editCustomerSave(
                      _name,
                      _phoneNumber,
                      _email,
                      _address,
                      _currentStatus,
                      _addressLine2,widget.cid
                  );
                }
                else {
                  DatabaseController.addCustomerSave(
                      _name, _phoneNumber, _email, _address, _currentStatus,
                      _addressLine2);
                }
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
          new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextFormField(
                    controller: _nameController,
                    decoration: new InputDecoration(
                      labelText: "Name",
                    ),
                    validator: assignName,
                    onSaved: (s){
                      setState(() {
                        _name=s;
                      });
                    },
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.phone),
                  title: new TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: new InputDecoration(
                      hintText: "Phone",
                    ),
                    validator: assignPhoneNumber,
                    onSaved: (s){
                      setState(() {
                        _phoneNumber=s;
                      });
                    },
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.email),
                  title: new TextFormField(
                    controller: _emailController,
                    decoration: new InputDecoration(
                      labelText: "Email",
                    ),
                    validator: assignEmail,
                    onSaved: (s){
                      setState(() {
                        _email=s;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
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
                          new Radio(value: 'Hot', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.red),
                          new Text('Hot'),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Radio(value: 'Medium', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.yellow ),
                          new Text('Medium'),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Radio(value: 'Cold', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.blue ),
                          new Text('Cold'),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Radio(value: 'Disinterested', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.black ),
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
                    title: new TextFormField(
                      controller: _addressController,
                      decoration: new InputDecoration(
                        labelText: "Line 1",
                        border: OutlineInputBorder(),
                      ),
                      validator: assignAddressLineOne,
                      onSaved: (s){
                        setState(() {
                          _address=s;
                        });
                      },
                    )
                ),
                new ListTile(
                  //leading: const Icon(Icons.add_location),
                    title: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Line 2 (optional)",
                        border: OutlineInputBorder(),
                      ),
                      controller: _addressLine2Controller,
                      onSaved: (s){
                        setState(() {
                          _addressLine2=s;
                        });
                      },
//                onChanged: assignAddressLineTwo,
                    )
                )
              ],
            ),
          ),
//          new ListTile(
//            leading: const Icon(Icons.person),
//            title: new TextField(
//              decoration: new InputDecoration(
//                hintText: "Name",
//              ),
//              onChanged: assignName,
//            ),
//          ),
//          new ListTile(
//            leading: const Icon(Icons.phone),
//            title: new TextField(
//              keyboardType: TextInputType.numberWithOptions(),
//              decoration: new InputDecoration(
//                hintText: "Phone",
//              ),
//              onChanged: assignPhoneNumber,
//            ),
//          ),
//          new ListTile(
//            leading: const Icon(Icons.email),
//            title: new TextField(
//              decoration: new InputDecoration(
//                hintText: "Email",
//              ),
//              onChanged: assignEmail,
//            ),
//          ),
//          const Divider(
//            height: 3.0,
//          ),
//          new ListTile(
//            leading: new Image(image: new AssetImage('assets/icons/'+_currentStatus.toLowerCase()+'.png')),
//            title: const Text('Status'),
//            //subtitle: const Text('status'),
//          ),
//          new ListTile(
//           //leading: new Image(image: new AssetImage('assets/icons/'+_currentStatus.toLowerCase()+'.png')),
//            title:new Column(
//              children: <Widget>[
//                new Row(
//                  children: <Widget>[
//                    new Radio(value: 'Hot', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.red),
//                    new Text('Hot'),
//                  ],
//                ),
//                new Row(
//                  children: <Widget>[
//                    new Radio(value: 'Medium', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.yellow ),
//                    new Text('Medium'),
//                  ],
//                ),
//                new Row(
//                  children: <Widget>[
//                    new Radio(value: 'Cold', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.blue ),
//                    new Text('Cold'),
//                  ],
//                ),
//                new Row(
//                  children: <Widget>[
//                    new Radio(value: 'Disinterested', groupValue: _currentStatus, onChanged: (String s)=>getStatus(s),activeColor: Colors.black ),
//                    new Text('Not Interested'),
//                  ],
//                ),
//              ],
//            )
//            /*new DropdownButton(
//                    value: _currentStatus,
//                    items: _dropDownMenuItems,
//                    onChanged: changedDropDownItem
//            )*/,
//           // subtitle: const Text('status'),
//          ),
//          new ListTile(
//            leading: const Icon(Icons.add_location),
//            title: const Text('Address'),
//            //subtitle: const Text('status'),
//          ),
//          new ListTile(
//            //leading: const Icon(Icons.add_location),
//            title: new TextField(
//                  decoration: new InputDecoration(
//                      hintText: "Line 1",
//                      border: OutlineInputBorder(),
//                  ),
//              onChanged: assignAddressLineOne,
//            )
//          ),
//          new ListTile(
//              //leading: const Icon(Icons.add_location),
//              title: new TextField(
//                  decoration: new InputDecoration(
//                    hintText: "Line 2 (optional)",
//                    border: OutlineInputBorder(),
//                  ),
//                  controller: line2,
////                onChanged: assignAddressLineTwo,
//              )
//          )
        ],
      ),
    )
      )
    );
  }
  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();
    } else {
      setState(() => _autoValidate = true);
    }
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
  String assignName(String s){
    if(s.length<3){
      return 'Name must be atleast 3 characters';
    }
    else{
      return null;
    }
    }
  String assignPhoneNumber(String s){
    if(s.length <10 || s.length>10){
      return 'Invalid mobile number';
    }
    else{
      return null;
    }
  }
  String assignEmail(String value){
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';

  }

  String assignAddressLineOne(String s){
    if(s.isEmpty){
      return 'Address line one cannot be empty';
    }
    else{
      return null;
    }
  }

}