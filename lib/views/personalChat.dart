import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivityapp/helper/authenticate.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/createTeams.dart';
import 'package:productivityapp/views/search_add_members.dart';
import 'package:productivityapp/views/teams_dashboard_screen.dart';
import 'package:productivityapp/widgets/widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'constants_color.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot> chats;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  TextEditingController messageEditingController = new TextEditingController();
  
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            reverse: true,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[snapshot.data.documents.length -1 - index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[snapshot.data.documents.length -1 -index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "SendByEmail":Constants.myEmail,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        "chatRoom":widget.chatRoomId,
      };

      DataBaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DataBaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    _fcm.subscribeToTopic(widget.chatRoomId);
    
    super.initState();
  }

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
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7])),
        child: Stack(
          children:  <Widget>[

            Container(padding:MediaQuery.of(context).viewInsets.bottom!=0 ?EdgeInsets.only(bottom: 70):EdgeInsets.only(bottom: 0),height: MediaQuery.of(context).size.height/1.3,child: chatMessages(),),
        Container(

          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
            child: Container(

              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),

                  borderRadius: BorderRadius.all(Radius.circular(100))
              ),

              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),

              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: messageEditingController,

                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type a Message",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){

                         addMessage();

                        },
                        child: Icon(Icons.send,color: Colors.white,),
                      ),
                    ),

                  ),

                ],

              ),
            ),
          ),//textBar
        ),

          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 8,
          right: sendByMe ? 8 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
          color: sendByMe ? Colors.greenAccent.withOpacity(0.2):Colors.white30.withOpacity(0.4),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white,fontSize: 17),),
      ),
    );
  }
}
