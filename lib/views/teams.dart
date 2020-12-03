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
import 'package:productivityapp/views/createTeams.dart';
import 'package:productivityapp/views/search_add_members.dart';
import 'package:productivityapp/views/teams_dashboard_screen.dart';
import 'package:productivityapp/widgets/widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'constants_color.dart';


class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot teamsSnapshot;
  @override
  void initState() {
    getUserInfo();
    getTeams();
    super.initState();
  }


  getUserInfo()async{

    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {

    });
  }

  getTeams()async{
    dataBaseMethods.getUserTeamsByEmail(Constants.myEmail)
        .then((val){
          setState(() {
           print(val);
            teamsSnapshot = val;
          });
    });
  }
  Widget TeamsList(){
    return teamsSnapshot.documents.length != 0 ? Swiper(


      itemBuilder: (BuildContext context,int index){
            return TeamsTile(
              TeamName: teamsSnapshot.documents[index].data["TeamName"],
              Teamroomid : teamsSnapshot.documents[index].data["Teamroomid"]
            );
        },
      itemCount: teamsSnapshot.documents.length,
      pagination: new SwiperPagination(),
      controller: new SwiperController(),
      itemWidth: 300.0,
      itemHeight: MediaQuery.of(context).size.height/2,
      layout: SwiperLayout.STACK,
      loop: true,
      index: 0,



    ):
    FadeAnimation(
      1.4,SizedBox(height: MediaQuery.of(context).size.height/2,child: Align(alignment:Alignment.bottomCenter,child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Text("Create a Team",style:  TextStyle(
            fontFamily: 'Avenir',
            fontSize: 34,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),),
          Icon(Icons.subdirectory_arrow_right,color:const Color(0x7cdbf1ff) ,size: 34,),
        ],
      )),),
    );

  }


  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: gradientEndColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7])),

        child:  Column(

          mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 100,),

              FadeAnimation(
                1.5, Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[


                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        child: Text(
                          "Your Teams",
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
              FadeAnimation(1.0, TeamsList()),
              Expanded(child: Container(),)
            ],
          ),
        ),

      floatingActionButton: FadeAnimation(
        1.3,
         FloatingActionButton(
          child: Icon(Icons.create),
          backgroundColor: Colors.white.withOpacity(0.3),
          elevation: 0,
          
          onPressed: (){

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder:(context) => CreateTeam()),
              );
          },
        ),
      ),
      bottomNavigationBar: bottomNavBar(context,Navwhite_pressed,NavpressedColor,Navwhite_pressed),



    );
  }
}
class TeamsTile extends StatelessWidget {
  final String TeamName;
  final String Teamroomid;
  TeamsTile({this.TeamName,this.Teamroomid});
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              Constants.TeamName = TeamName;
              Constants.Teamroomid = Teamroomid;
              //print(Constants.Teamroomid+'\n'+Constants.TeamName);
              Navigator.push(context, MaterialPageRoute(
                  builder:(context) => Teams_detailed_view()),
              );
            },
            child: SizedBox(
              width:140.0,
              height: 140.0,
              child: Card(

                color:  Colors.white.withOpacity(1),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child:Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(

                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                          ),
                          Image.asset("assets/group.png",width: 74.0,),
                          SizedBox(
                            height: 60.0,
                          ),
                          Text(
                            TeamName,
                            style: TextStyle(
                                color: Colors.black.withOpacity(1),
                              fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                fontFamily: 'Avenir',
                            ),
                          ),

                        ],
                      ),
                    )
                ),
              ),
            ),
          ),
        ),


    );
  }
}

