import 'package:flutter/material.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/constants_color.dart';
import 'package:productivityapp/views/personalChat_dashboard.dart';
import 'package:productivityapp/views/teams.dart';
import 'package:productivityapp/views/User_profile.dart';
Widget appBarMain(BuildContext context){
  return AppBar(
    title: Text("Productivity"),
  );
}

Widget bottomNavBar(BuildContext context,Color button1,Color button2,Color button3){

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(36.0),
      ),
      color: navigationColor,
    ),
    padding: const EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Image.asset('assets/menu_icon.png',color: button1,),
          onPressed: () {Navigator.pushReplacement(context,MaterialPageRoute(
            builder:(context) => Dashboard(),));},

        ),
        IconButton(
          icon: Image.asset('assets/navbar_team.png',color: button2,),
          onPressed: () {Navigator.pushReplacement(context,MaterialPageRoute(
            builder:(context) => Teams(),));},
        ),
        IconButton(
          icon: Image.asset('assets/message.png',),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(
              builder:(context) => ChatRoom(),));
          },
        ),
        IconButton(
          icon: Image.asset('assets/profile_icon.png',color: button3,),
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(
              builder:(context) => Profile(),));
          },
        ),


      ],
    ),
  );
}