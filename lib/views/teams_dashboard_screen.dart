import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivityapp/helper/authenticate.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/constants_color.dart';
import 'package:productivityapp/views/conversation_screen.dart';
import 'package:productivityapp/views/createTeams.dart';
import 'package:productivityapp/views/search_add_members.dart';
import 'package:productivityapp/views/team_statistics.dart';
import 'package:productivityapp/views/teamsTodo.dart';
import 'package:productivityapp/views/teams_info.dart';
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:productivityapp/pages/call.dart';

class Teams_detailed_view extends StatefulWidget {
  @override
  _Teams_detailed_viewState createState() => _Teams_detailed_viewState();
}

class _Teams_detailed_viewState extends State<Teams_detailed_view> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      appBar: AppBar(backgroundColor: gradientStartColor,elevation: 0,iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),

        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder:(context) => Teams_info_page()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.info,color: Colors.white,),
            ),
          )
        ],
       // title: Text(Constants.TeamName,style: TextStyle(fontSize: 20,color: Colors.black),),
      ),

      body:Container(
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
                  Constants.TeamName,
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
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(
                                    builder:(context) => TeamsTodo()),
                                );
                              },
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
                                      "Tasks",
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
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => ConversationScreen()),
                        );
                      },
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
                                    Image.asset("assets/message.png",width: 64.0,),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      "Chat",
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
                      onTap: (){
                        onJoin();
                        DataBaseMethods().start_videoCall(Constants.Teamroomid, Constants.myName);
                        _fcm.subscribeToTopic(Constants.Teamroomid.split("@")[0]+"videoCall");
                        },
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
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => TeamStats()),
                        );
                      },
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
                                    Image.asset("assets/statistics.png",width: 64.0,),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      "Team Statistics",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0

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
      floatingActionButton: FadeAnimation(
        1.3,
        FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.white.withOpacity(0.3),
          elevation: 0,

          onPressed: (){

            Navigator.push(context, MaterialPageRoute(
                builder:(context) => SearchScreen_addMembers()),
            );
          },
        ),
      ),
    );
  }
  Future<void> onJoin() async {
    // update input validation


    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given Meeting Id
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: Constants.Teamroomid,
          role: ClientRole.Broadcaster,
        ),
      ),
    );

  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }


}

