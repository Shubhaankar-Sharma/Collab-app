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

class PersonalTodo extends StatefulWidget {
  @override
  _PersonalTodoState createState() => _PersonalTodoState();
}

class _PersonalTodoState extends State<PersonalTodo> {

  Stream taskStream;

  DataBaseMethods databaseServices = new DataBaseMethods();


  TextEditingController taskEdittingControler = new TextEditingController();
@override
  void initState() {
  databaseServices.getTasks(Constants.myEmail).then((val){

    taskStream = val;
    setState(() {});
    super.initState();
  });
      }
  Widget taskList(){

    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot){
        return snapshot.hasData ?
        ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return TaskTile(
                snapshot.data.documents[index].data["isCompleted"],
                snapshot.data.documents[index].data["task"],
                snapshot.data.documents[index].documentID,
              );
            }) : Container();
      },
    );

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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7])),
          ),
          SingleChildScrollView(
            child: Container(

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 32),
                width: 600,
                child: Column(
                  children: [
                    Text("My Day", style: TextStyle(
                      fontSize: 24,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 30,),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskEdittingControler,
                            style: TextStyle(color:Colors.white),
                            decoration: InputDecoration(
                                hintText: "task",
                              hintStyle: TextStyle(color:Colors.white.withOpacity(0.6)),
                              fillColor: Colors.white.withOpacity(0.4),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                            ),

                            onChanged: (val){
                              // taskEdittingControler.text = val;
                              setState(() {

                              });
                            },
                          ),
                        ),
                        SizedBox(width: 6,),
                        taskEdittingControler.text.isNotEmpty ?
                        GestureDetector(
                            onTap: (){

                              Map<String, dynamic> taskMap = {
                                "task" : taskEdittingControler.text,
                                "isCompleted" : false
                              };

                              databaseServices.createTask(Constants.myEmail,taskMap);
                              taskEdittingControler.text = "";
                            },
                            child: Container(
                                padding: EdgeInsets
                                    .symmetric(horizontal: 12, vertical: 5),
                                child: Text("ADD",style: TextStyle(color: Colors.white),))) : Container()
                      ],),

                    taskList()
                  ],),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
class TaskTile extends StatefulWidget {
  final bool isCompleted;
  final String task;
  final String documentId;
  TaskTile(this.isCompleted, this.task, this.documentId);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){

              Map<String,dynamic> taskMap = {
                "isCompleted" : !widget.isCompleted
              };

              DataBaseMethods().updateTask(Constants.myEmail, taskMap, widget.documentId);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(30)
              ),
              child:
              widget.isCompleted ?
              Icon(Icons.check, color: Colors.green,) : Container(),
            ),
          ),

          SizedBox(width: 8,),
          Text(
            widget.task,
            style: TextStyle(
                color: widget.isCompleted ? Colors.white :
                Colors.white.withOpacity(0.9) ,
                fontSize: 20,
                decoration: widget.isCompleted ?
                TextDecoration.lineThrough :
                TextDecoration.none
            ),
          ),

          Spacer(),

          GestureDetector(
            onTap: (){
              DataBaseMethods().deleteTask(Constants.myEmail, widget.documentId);
            },
            child: Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Icon(
                  Icons.close, size: 18, color: Colors.white.withOpacity(0.7)
              ),
            ),
          )
        ],
      ),
    );
  }
}
