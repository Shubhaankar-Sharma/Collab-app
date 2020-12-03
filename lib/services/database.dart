import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{
  getUserByUsername(String username) async{
    return await Firestore.instance.collection("users")
        .where("name" ,isEqualTo: username )
        .getDocuments();
  }
  getUserByUserEmail(String Email) async{
    return await Firestore.instance.collection("users")
        .where("email" ,isEqualTo: Email )
        .getDocuments();
  }
  getUserTeamsByEmail(String Email) async{
    return await Firestore.instance.collection("team")
        .where("users",arrayContains: Email)
        .getDocuments();
  }
  getTeamUsersList(String teams_id)async{
    DocumentReference docRef =  Firestore.instance.collection("team").document(teams_id);
    DocumentSnapshot documentSnapshot = await docRef.get();
    return documentSnapshot;


  }
  uploadUserInfo(userMap){

    Firestore.instance.collection("users").document(userMap["email"]).setData(userMap);


  }

  createTeamAndChatRoom(String team_id , teamMap){
    Firestore.instance.collection("team")
        .document(team_id).setData(teamMap).catchError((e){
      print(e.toString());
    });
  }
  addUsertoTeamAndChatRoom(String team_id,team_memberslist)async{
    DocumentReference docRef =  Firestore.instance.collection("team").document(team_id);
    
    docRef.updateData({
      'users':FieldValue.arrayUnion(team_memberslist)
    });
  }

  postConversationTeam(String team_id,messageMap){
    Firestore.instance.collection("team")
        .document(team_id)
        .collection("chats")
        .add(messageMap).catchError((onError){print(onError);});
  }
  getConversationTeam(String team_id)async{
    return await Firestore.instance.collection("team")
        .document(team_id)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  updateTask(String userId, Map taskMap, String documentId){
    Firestore.instance.collection("users")
        .document(userId)
        .collection("tasks")
        .document(documentId)
        .setData(taskMap, merge: true);
  }
  updateTeamTask(String teamId, Map taskMap, String documentId){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks")
        .document(documentId)
        .setData(taskMap, merge: true);
  }


  createTask(String userId, Map taskMap){
    Firestore.instance.collection("users")
        .document(userId)
        .collection("tasks")
        .add(taskMap);
  }
  createTeamTask(String teamId, Map taskMap){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks")
        .add(taskMap);
  }


  getTasks(String userId) async {
    return await Firestore.instance.collection("users")
        .document(userId)
        .collection("tasks")
        .snapshots();
  }
  getTeamTasks(String teamId) async {
    return await Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks")
        .snapshots();
  }


  deleteTask(String userId,String documentId){
    Firestore.instance.collection("users")
        .document(userId)
        .collection("tasks")
        .document(documentId)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }
  deleteTeamTask(String teamId,String documentId){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks")
        .document(documentId)
        .delete()
        .catchError((e){
      print(e.toString());
    });
  }
  incrementAssignedTasks(String teamId,String User_email)async{

    DocumentReference snapRef = Firestore.instance.collection("team")
        .document(teamId).collection("tasks_users_data")
        .document(User_email);
    DocumentSnapshot snapShot = await snapRef.get();
    if( !snapShot.exists){
      Firestore.instance.collection("team")
          .document(teamId)
          .collection("tasks_users_data")
          .document(User_email)
          .setData({"assigned":FieldValue.increment(1),"user":User_email.split("@")[0],"completed":0});

    }else{
      Firestore.instance.collection("team")
          .document(teamId)
          .collection("tasks_users_data")
          .document(User_email)
          .updateData({"assigned":FieldValue.increment(1)});

    }

  }
  reduceAssignedTasks(String teamId,String User_email){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks_users_data")
        .document(User_email)
        .updateData({"assigned":FieldValue.increment(-1)});
  }
  incrementCompletedTasks(String teamId,String User_email){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks_users_data")
        .document(User_email)
        .updateData({"completed":FieldValue.increment(1)});

  }
  reduceCompletedTasks(String teamId,String User_email){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks_users_data")
        .document(User_email)
        .updateData({"completed":FieldValue.increment(-1)});
  }

getAllUserStats(String teamId){
    return Firestore.instance.collection("team")
        .document(teamId)
        .collection("tasks_users_data")
        .snapshots();
}

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
  start_videoCall(String teamId,String Name){
    Firestore.instance.collection("team")
        .document(teamId)
        .collection("VideoCall")
        .add({"team":teamId,"user":Name});
  }

}
