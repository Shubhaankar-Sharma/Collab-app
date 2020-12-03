import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController MessageTextEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  Stream chatMessagesStream;
  Widget ChatMessageList(){
      return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context,snapshot){

          return snapshot.hasData ? ListView.builder(
            controller: _scrollController,
              reverse: true,

              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){

                return MessageTile(
                    snapshot.data.documents[snapshot.data.documents.length-1-index].data["message"],
                    snapshot.data.documents[snapshot.data.documents.length-1-index].data["sendBy"] == Constants.myName,
                    snapshot.data.documents[snapshot.data.documents.length-1-index].data["sendBy"]
                );


              }):Container(height: MediaQuery.of(context).size.height / 2,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),);
        },
      );
  }

  sendMessage(){
    dataBaseMethods.postConversationTeam(Constants.Teamroomid, {"message":MessageTextEditingController.text,"sendBy":Constants.myName,"SendByEmail":Constants.myEmail,"time":DateTime.now().millisecondsSinceEpoch,"team":Constants.Teamroomid.split('@')[0]});
    MessageTextEditingController.text = "";
  }

  @override
  void initState() {

    dataBaseMethods.getConversationTeam(Constants.Teamroomid).then((value){
      setState(() {
        chatMessagesStream =value;
      });

    });
    _fcm.subscribeToTopic(Constants.Teamroomid.split("@")[0]);
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


          children: <Widget>[
            Container(padding:MediaQuery.of(context).viewInsets.bottom!=0 ?EdgeInsets.only(bottom: 70):EdgeInsets.only(bottom: 0),height: MediaQuery.of(context).size.height/1.3,child: ChatMessageList()),

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
                            controller: MessageTextEditingController,

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

                                  if(MessageTextEditingController.text.length != 0 ){sendMessage();}
                                  else{print(MessageTextEditingController.text);}

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
  final bool isSendByme;
  final String sender;
  MessageTile(this.message,this.isSendByme,this.sender);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByme ? 0:8, right: isSendByme ? 8:0),

      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByme? Alignment.centerRight : Alignment.centerLeft,
      child: isSendByme ?Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          color: isSendByme ? Colors.greenAccent.withOpacity(0.2):Colors.white30.withOpacity(0.4),
          borderRadius: isSendByme ?
            BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23),
        ):BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23),
            )
        ),

          child: Text(
            message,style: TextStyle(color: Colors.white,fontSize: 17),
          )
      ):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(sender,style: TextStyle(color: Colors.white70),),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              decoration: BoxDecoration(
                  color: isSendByme ? Colors.greenAccent.withOpacity(0.2):Colors.white30.withOpacity(0.4),
                  borderRadius: isSendByme ?
                  BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  ):BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )
              ),

              child: Text(
                message,style: TextStyle(color: Colors.white,fontSize: 17),
              )
          ),
        ],
      ),
    );
  }
}
