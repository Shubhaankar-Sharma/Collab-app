import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivityapp/helper/authenticate.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/pages/index.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/personal_todo.dart';
import 'package:productivityapp/views/pomodoro.dart';
import 'package:productivityapp/views/teams.dart';
import 'package:productivityapp/views/login.dart';
import 'package:productivityapp/widgets/widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'constants_color.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  BuildContext _scaffoldContext;
  @override
  void initState() {
    getUserInfo();
    super.initState();
    _fcm.configure(
      //onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
        //showDialog(
          //context: context,
          //builder: (context) => AlertDialog(
            //content: ListTile(
              //title: Text(message['notification']['title']),
              //subtitle: Text(message['notification']['body']),
            //),
            //actions: <Widget>[
              //FlatButton(
                //child: Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
              //),
            //],
          //),
        //);
      //},
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional

      },
    );
    _saveDeviceToken();
    //print(_fcm.getToken().then((value) => print(value)));
  }
  getUserInfo()async{

    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {

    });
  }
  _saveDeviceToken() async {
    // Get the current user
    String uid = Constants.myEmail;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(Constants.myEmail)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
      });
    }
  }

  //AuthMethods authMethods = new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: gradientEndColor,



//TODO: body was wrapped with safe area if anything goes wrong wrap it again
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradientStartColor, gradientEndColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.7])),

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[

              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(left: 18,top: 18),
                child: FadeAnimation(1.3,
                  Text(
                    "Dashboard",
                    style:  TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 34,
                      color: const Color(0x7cdbf1ff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              FadeAnimation(
                1.3,Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 60),
                  child: Center(
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 40),
                      children: <Widget>[
                        SizedBox(

                          width:155.0,
                          height: 160.0,
                          child: Card(

                            color: Colors.white.withOpacity(0.3),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),

                            ),

                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                GestureDetector(
                                  onTap:(){Navigator.push(context,MaterialPageRoute(
                                      builder:(context) => PersonalTodo()),
                                  );},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 30,),
                                        Image.asset("assets/todo.png",width: 54.0,),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text(
                                          "Things to do",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){Navigator.pushReplacement(context,MaterialPageRoute(
                              builder:(context) => Teams()),
                          );},
                          child: SizedBox(
                            width:160.0,
                            height: 160.0,
                            child: Card(

                              color: Colors.white.withOpacity(0.3),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child:Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Image.asset("assets/group.png",width: 64.0,),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text(
                                          "Your Teams",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0

                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: (){Navigator.push(context,MaterialPageRoute(
                              builder:(context) => PomodoroTimer()),
                          );},
                           child: SizedBox(
                            width:155.0,
                            height: 160.0,
                            child: Card(

                              color: Colors.white.withOpacity(0.3),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child:Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 20,),
                                        Image.asset("assets/timer.png",width: 64.0,),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Center(
                                          child: Text(
                                            "Timer",
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(0.6),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){Navigator.push(context,MaterialPageRoute(
                              builder:(context) => IndexPage(),));},
                          child: SizedBox(
                            width:160.0,
                            height: 160.0,
                            child: Card(

                              color: Colors.white.withOpacity(0.3),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child:Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height:20,),
                                        Image.asset("assets/video-call.png",width: 64.0,),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Text(
                                          "Video Call",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0
                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child:Container()
              ),

            ],
          ),
        ),
        bottomNavigationBar: bottomNavBar(context,NavpressedColor,Navwhite_pressed,Navwhite_pressed)
    );
  }
}