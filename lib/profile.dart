import 'package:flutter/material.dart';
import 'package:localnewsapp/settings.dart';

class Profile extends StatelessWidget{
  const Profile(
    {
      super.key,
    }
  );

   @override
  Widget build (BuildContext context)
  {
   return const SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
 
          Divider(),
          Padding(padding: EdgeInsets.all(30.0)),

          Settings()
        ],
        )
      
      ,
    );
  }
}