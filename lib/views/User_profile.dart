import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:productivityapp/helper/authenticate.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/pages/index.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/pomodoro.dart';
import 'package:productivityapp/views/teams.dart';
import 'package:productivityapp/views/login.dart';
import 'package:productivityapp/widgets/widget.dart';

import 'constants_color.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthMethods authMethods = new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      body: Column(

        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [gradientStartColor, gradientEndColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.3, 0.7])),

                    child: Container(
                      width: double.infinity,

                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            SizedBox(
                              height: 100.0,
                            ),
                            FadeAnimation(1.3,
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 18, 18, 18),
                                child: Text(
                                  "Profile",
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
                            SizedBox(height:50),
                            FadeAnimation(1.3,
                              Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                  child: Text(
                                    Constants.myName,
                                    style:  TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 24,
                                      color: const Color(0x7cdbf1ff),
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                            FadeAnimation(1.3,
                              Padding(
                                padding: const EdgeInsets.only(top:78.0),
                                child: Container(

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                    child: Text(
                                     Constants.myEmail,
                                      style:  TextStyle(
                                        fontFamily: 'Avenir',
                                        fontSize: 22,
                                        color: const Color(0x7cdbf1ff),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 60,),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FadeAnimation(
                                1.2,
                                GestureDetector(
                                  onTap: (){
                                    authMethods.signOut();
                                    Navigator.pushReplacement(context,MaterialPageRoute(
                                      builder:(context) => Authenticate(),));
                                    HelperFunctions.saveUserLoggedInSharedPreference(false);
                                  },
                                  child: Container(

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: Container(
                                      child:

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                            child: Text(
                                              "Log Out",
                                              style:  TextStyle(
                                                fontFamily: 'Avenir',
                                                fontSize: 24,
                                                color: const Color(0x7cdbf1ff),
                                                fontWeight: FontWeight.w300,
                                                      ),
                                              textAlign: TextAlign.left,
                                                  ),
                                          ),
                                            ),
                                      ),
                                ),
                           ),
                            ),
                          SizedBox(height:50),

                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),


        ],
      ),
      bottomNavigationBar: bottomNavBar(context, Navwhite_pressed, Navwhite_pressed, NavpressedColor),
    );
  }
}
