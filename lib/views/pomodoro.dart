import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  double percent  = 0;
  static int TimeInMinute = 25;
  int TimeinSec = TimeInMinute*60;
  Timer timer;

  _StartTimer(){
    TimeInMinute = 25;
    int Time = TimeInMinute*60;
    double SecPercent = (Time/100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(Time > 0){
          Time--;
          if(Time%60 == 0){
            TimeInMinute--;

          }if (Time%SecPercent == 0){
            if (percent<1) {
              percent += 0.01;
            }else{
              percent = 1;

            }
          }
        }else{
          percent = 0;
          TimeInMinute = 25;
          timer.cancel();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
              appBar: AppBar(

                elevation: 0,
                iconTheme: IconThemeData(color: Colors.blueGrey),
                      leading: IconButton(
                                    onPressed: () {

                                            Navigator.pop(context);
                                      },
                      icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
                      
                      ),
                      toolbarOpacity: 1,

                ),
      
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                   colors: [Color(0xff1542bf),Color(0xff51a8ff)],
                   begin: FractionalOffset(0.5,1) 
                  )
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 18.0),
                          child: Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              
                            ),
                          ),
                        ),
                    Expanded(
                      child: CircularPercentIndicator(
                        percent: percent,
                        animation:true,
                        animateFromLastPercent: true,
                        radius: 250.0,
                        lineWidth: 10.0,
                        progressColor: Colors.white,
                        center: Text(
                          "$TimeInMinute",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80.0,
                          ),
                        ),


                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: Container(
                        width:double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(30.0),topLeft: Radius.circular(30.0))
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top:30.0,left:20.0 ,right:20.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child:Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Work Timer",
                                            style: TextStyle(
                                              fontSize: 28.0,
                                            ),

                                          ),
                                          SizedBox(height: 10.0,),
                                          Text(
                                              "25",
                                                style: TextStyle(
                                                    fontSize: 60.0
                                                ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Pause Time",
                                            style: TextStyle(
                                              fontSize: 28.0,
                                            ),

                                          ),
                                          SizedBox(height: 10.0,),
                                          Text(
                                            "5",
                                            style: TextStyle(
                                                fontSize: 60.0
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 28.0),
                                child: RaisedButton(
                                  onPressed: _StartTimer,
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Start Working",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),



      ),
    );
  }
}