
import 'package:cloud_firestore/cloud_firestore.dart';

class LS 
{
  final String? id;
  final String userID;
  final String date;

  LS({this.id,required this.userID, required this.date});


  factory LS.fromFirestore(
        DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  )
  {
      final data = snapshot.data();
      return LS(
          id: snapshot.id,
          userID:data?['userID'] ,
          date : data?['date']

        );

  }


  Map<String, dynamic> toFirestore()
  {
    return {
        if(id !=null)"id":id,
        "userID":userID,
        "date":date
    };


  }


}