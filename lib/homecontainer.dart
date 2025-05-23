
import 'package:flutter/material.dart';

import 'package:localnewsapp/explore.dart';
import 'package:localnewsapp/add.dart';
import 'package:localnewsapp/home.dart';

import 'package:localnewsapp/popupmenu.dart';
import 'package:localnewsapp/profile.dart';




class HomeContainer extends StatelessWidget
{
  final String title;
  const HomeContainer(
    {
      super.key,
      required this.title
    }
  );
  
  @override
  Widget build (BuildContext context)
  {
    
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
             
            //   colorScheme:ColorScheme.fromSeed(
            //     seedColor: Colors.green,

            //     primary: Colors.blueGrey.shade700,
            //     onPrimary: Colors.white,

            //     secondary: Colors.blueGrey,
            //     onSecondary: Colors.blueGrey.shade50,


            //     onError: Colors.red,


            //     onBackground: Colors.blueGrey.shade50

                

            //   ),
              
            //    useMaterial3: true,
            // ),
            home: DefaultTabController(
                 length: 4,
                 child:Scaffold(
                         appBar: AppBar(
                                leading: const Popupmenu(),
                                backgroundColor:Colors.black,
                                foregroundColor:Colors.white,
                                title:Text(title),
                                actions: <Widget>[
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),

                                ],
                        ),
                        bottomNavigationBar:const BottomAppBar(
                                        height: 60.0,
                                        // color: Theme.of(context).colorScheme.secondary,
                                        child: TabBar(
                                           //unselectedLabelColor: Colors.white,
                                           labelColor:Colors.black,
                                      
                                          tabs: [
                                            
                                            Tab(
                                              icon: Icon(Icons.home),
                                            
                                            ),
                                            Tab(
                                              icon: Icon(Icons.explore),
                                            
                                            ),
                                            Tab(
                                              icon: Icon(Icons.add),
                                          
                                            ),
                                            Tab(
                                              icon: Icon(Icons.person),
                                          
                                              ),
                                           
                                          ],
                                        ),
                          ), 
                          body:TabBarView(
                                  children: [
                                    Home(),
                                    const Explore(),
                                    const Add(),
                                    const Profile(),
                                    
                                  ],
                          
                          ) 
                          
                    )
              ),
    );
  }

}
