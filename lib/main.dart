import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';


void main() => runApp(new MyHomePage());



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var mymap = {};
  var title = '';
  var body = {};
  var mytoken = '';
  
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    
    firebaseMessaging.configure(
      onLaunch: (Map<String , dynamic> msg){
        print("onLaunch called ${(msg)}");
      },
      onResume: (Map<String , dynamic> msg){
        print("onResume called ${(msg)}");
      },
      onMessage:  (Map<String , dynamic> msg){
        print("onResume called ${(msg)}");
        mymap = msg;
        showNotification(msg);
      }
    );
    
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true , alert: true ,badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting){
          print("onIosSettingsRegistered");
    });
    firebaseMessaging.getToken().then((token){
      update(token);
    });
    
  }



  showNotification(Map<String , dynamic> msg) async{
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android,iOS);
    
    msg.forEach((k,v){
      title = k;
      body = v;
      setState(() {
        
      });
    });
    
    await flutterLocalNotificationsPlugin.show(0, "${msg.keys}", "${msg.values}", platform);
    
  }
  
  
  update(String token ){
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token":token});
    mytoken = token;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: new Text('Messeging App'),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
                new Text(
                  '$mytoken',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: (){},
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          ),
        ),
      );
  }
}
