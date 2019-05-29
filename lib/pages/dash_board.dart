import 'package:flutter/material.dart';
import 'package:crm/tabs/notifications_tab.dart';
import 'package:crm/tabs/settings_tab.dart';
import 'package:crm/tabs/list_page.dart';
import 'package:crm/controllers/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about_us.dart';
import 'searchPage.dart';

class DashBoard extends StatefulWidget {
  _DashBoardState createState() => _DashBoardState();

  DashBoard({Key key, this.auth, this.onSignedOut}) : super(key: key);
  final VoidCallback onSignedOut;
  final BaseAuth auth;
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  void _signedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void _aboutUs() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
  }

  /* void addname() async{
    UserUpdateInfo i=new UserUpdateInfo();
    i.displayName='Harshyam';
    var user =await FirebaseAuth.instance.currentUser();
    user.updateProfile(i);
  }*/
  @override
  void initState() {
//    addname();
    print('this is auth ' + widget.auth.toString());
    firstTab = ListPage(key: tabOneKey);
    secondTab = NotificationTab(key: tabTwoKey);
    thirdTab = SettingsTab(
        key: tabThreeKey, auth: widget.auth, onSignedOut: widget.onSignedOut);
    tabs = [firstTab, secondTab, thirdTab];
    currentTab = firstTab;
    setName();
    super.initState();
  }

  final Key tabOneKey = PageStorageKey('tabOne');
  final Key tabTwoKey = PageStorageKey('tabTwo');
  final Key tabThreeKey = PageStorageKey('tabThree');
  int _selectedIndex = 0;
  final PageStorageBucket persistentStateBucket = PageStorageBucket();
  Widget currentTab;
  ListPage firstTab;
  NotificationTab secondTab;
  SettingsTab thirdTab;
  List<Widget> tabs;
  String userName;

  void setName() async {
    String temp = await widget.auth.getName();
    setState(() {
      userName = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
          )
        ],
        backgroundColor: Color(0xFFF2CB1D),
      ),
      drawer: new Drawer(
        child: new Column(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(
              userName == null ? "Frelit" : userName,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            accountEmail: null,
            decoration: new BoxDecoration(
              color: Color(0xFFF2CB1D),
            ),
          ),
          new ListTile(
            title: new Text("Sign Out"),
            leading: new Icon(Icons.clear),
            onTap: _signedOut,
          ),
          new ListTile(
            title: new Text("About Us"),
            leading: new Icon(Icons.info),
            onTap: _aboutUs,
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account), title: Text('Customers')),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), title: Text('Notifications')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Color(0xFF2B4876),
        onTap: _onItemTapped,
      ),
      body: PageStorage(bucket: persistentStateBucket, child: currentTab),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      currentTab = tabs[index];
    });
  }
}
