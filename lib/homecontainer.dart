import 'package:flutter/material.dart';
import 'package:localnewsapp/business/identification.dart';

import 'package:localnewsapp/explore.dart';
import 'package:localnewsapp/add.dart';
import 'package:localnewsapp/home.dart';
import 'package:localnewsapp/login.dart';

import 'package:localnewsapp/profile.dart';
import 'package:localnewsapp/pages/search_page.dart';

class HomeContainer extends StatelessWidget {
  final String title;
  const HomeContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
          length: Identification().isAdmin?4:3,
          child: Scaffold(
              appBar: AppBar(
                leading:const Icon(Icons.newspaper),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                title: Text(title),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {   
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                            );
                        }, icon: const Icon(Icons.exit_to_app)),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                height: 60.0,
                // color: Theme.of(context).colorScheme.secondary,
                child: TabBar(
                  //unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,

                  tabs: Identification().isAdmin?const [
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
                  ]:const[
                    Tab(
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      icon: Icon(Icons.explore),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
              children: Identification().isAdmin?
                [
                  Home(),
                  const Explore(),
                  const Add(),
                  const Profile(),
                ]:
                [
                  Home(),
                  const Explore(),
                  const Profile(),
                ]
                
              ))),
    );
  }
}
