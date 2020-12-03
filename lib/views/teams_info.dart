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
import 'package:productivityapp/views/createTeams.dart';
import 'package:productivityapp/views/search_add_members.dart';


class Teams_info_page extends StatefulWidget {
  @override
  _Teams_info_pageState createState() => _Teams_info_pageState();
}

class _Teams_info_pageState extends State<Teams_info_page> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  DocumentSnapshot documentSnapshot;
  List users;




  @override
  void initState() {

    getTeamsUsers();
    super.initState();
  }
  getTeamsUsers() async{
    dataBaseMethods.getTeamUsersList(Constants.Teamroomid)
        .then((val){
          setState(() {
            documentSnapshot = val;
            users = List.from(documentSnapshot['users']);
            print(documentSnapshot);
            print(users);
          });

    });

  }
  Widget TeamsUserList(){

    return users != null ? Expanded(
      child: ListView.builder(

        itemCount: users.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return UsersListTile(
            userEmail: users[index],
          );
        },


      ),

    ):SizedBox();


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

        child:  Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[


            FadeAnimation(
              1.5, Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Text(
                    "Team Info",
                    style:  TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 34,
                      color: const Color(0x7cdbf1ff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            ),
            FadeAnimation(
              1.5, Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Text(
                    "Name",
                    style:  TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 28,
                      color: const Color(0x7cdbf1ff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            ),
            FadeAnimation(
              1.5, Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: Text(
                    Constants.TeamName,
                    style:  TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 24,
                      color: const Color(0x7cdbf1ff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            ),
            FadeAnimation(
              1.5, Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Text(
                    "Members",
                    style:  TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 28,
                      color: const Color(0x7cdbf1ff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            ),
             TeamsUserList(),
            SizedBox(height: 20,)


          ],
        ),
      ),



    );
  }
}

class UsersListTile extends StatelessWidget {

  final String userEmail;

  UsersListTile({ this.userEmail});

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(1.3,
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100),

          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(userEmail,
                    style: TextStyle(fontSize: 15.0, color: Colors.white),)

                ],
              ),
              Spacer(),

            ],
          ),
        ),
      ),
    );
  }
}