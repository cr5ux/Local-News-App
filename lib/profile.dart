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
      
          UserAccountsDrawerHeader(
         
                    accountName: Text("user"),
                    accountEmail: Text("ab@gmail.com"),
                    currentAccountPicture:Icon(Icons.person,size: 150,),
                
                    arrowColor: Colors.black,
                    
                    decoration: BoxDecoration(
                      color: Colors.black45,

                    ),
          ),
          
        
          Divider(),
          Padding(padding: EdgeInsets.all(30.0)),

          Settings()
        ],
        )
      
      ,
    );
  }
}