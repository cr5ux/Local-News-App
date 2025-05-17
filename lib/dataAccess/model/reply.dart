
import 'package:cloud_firestore/cloud_firestore.dart';


class Reply
{
    final String replyID;
    final String message;
    final String date;
    final String userID;

    Reply({required this.replyID, required this.message, required this.date,required this.userID});
    

    factory Reply.fromFirestore(
        DocumentSnapshot<Map<String, dynamic>> snapshot,
        SnapshotOptions? options,
    )
    {
        final data = snapshot.data();
        return Reply(
            replyID: snapshot.id,
            message: data?['message'],
            date : data?['date'],
            userID:data?['userID']

          );

    }


  Map<String, dynamic> toFirestore()
  {
    return {
        "id":replyID,
        "message":message,
        "date":date,
        "userID":userID
    };


  }

}