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
import 'package:charts_flutter/flutter.dart' as charts;


class TeamStats extends StatefulWidget {
  @override
  _TeamStatsState createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot snapshot;
  List<charts.Series<UserStats,String>> _seriesBarData;
  List<UserStats> myData;
  _generateData(myData){

    _seriesBarData = List<charts.Series<UserStats, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (UserStats userstats,_)=> userstats.user,
        measureFn: (UserStats userstats,_)=> userstats.percentage,

        id:"Productivity",
        data: myData,
        labelAccessorFn: (UserStats row,_)=>"${row.user}"
      )
    );
  }



  @override
  Widget build(BuildContext context) {
   // print(snapshot.documents.asMap());

    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: _buildBody(context),


    );
  }
Widget _buildBody(context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("team")
          .document(Constants.Teamroomid)
          .collection("tasks_users_data")
          .snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        else{
          List<UserStats> userstats = snapshot.data.documents.map((e) => UserStats.fromMap(e.data)).toList();
          return _buildChart(context,userstats);
        }
      },
    );
}
Widget _buildChart(BuildContext context,List<UserStats> userstats){
    myData = userstats;
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(0.1),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Productivity",
                style:  TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 34,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: charts.BarChart(_seriesBarData,
                animate: true,
                  animationDuration: Duration(seconds: 2),

                ),
              )
            ],
          ),
        ),
      ),
    );
}
}

class UserStats{
  final String user;
  final double percentage;

  UserStats(this.user,this.percentage);

  UserStats.fromMap(Map<String,dynamic> map)
  :assert(map["user"]!=null),

    user = map["user"],

    percentage = map["assigned"]!=0?map["completed"]/(map["assigned"])*100:0.0;
  String toString() => "Record<$user:$percentage>";


}