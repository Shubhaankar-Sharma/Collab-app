
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/teams.dart';
import 'package:productivityapp/widgets/widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'constants_color.dart';

import 'animation/animated_button.dart';
class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController TeamTextEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  createTeamandcreateChatandcreateTodo() {
    if (formKey.currentState.validate()) {
      setState(() {

      });
      List<String> users = [Constants.myEmail];
      dataBaseMethods.createTeamAndChatRoom(
          TeamTextEditingController.text + "_" + Constants.myEmail, {
        "Teamroomid": TeamTextEditingController.text + "_" + Constants.myEmail,
        "TeamName": TeamTextEditingController.text,
        "users": users
      });
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder:(context) => Teams()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,

      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7])),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(1, Text("Create Team", style:TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 34,
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                        textAlign: TextAlign.left)),
                      SizedBox(height: 20,),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(1.2, makeInput(label: "Team Name",EditingController: TeamTextEditingController,widget_str: "Please Enter a Team Name")),

                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          createTeamandcreateChatandcreateTodo();

                          },
                        color: Colors.white.withOpacity(0.3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Create Team", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          color: Colors.white.withOpacity(0.8)
                        ),),
                      ),
                    ),
                  )),

                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: bottomNavBar(context,Navwhite_pressed,NavpressedColor,Navwhite_pressed),
    );

  }
  Widget makeInput({label, obscureText = false,EditingController,widget_str}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8)
        ),),
        SizedBox(height: 5,),
        TextFormField(
          validator: (val){return val.isEmpty ? widget_str: null ;},
          controller: EditingController,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(

            fillColor: Colors.white.withOpacity(0.4),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(50)
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}
