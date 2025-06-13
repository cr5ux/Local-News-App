import 'package:flutter/material.dart';

import 'package:localnewsapp/singleton/identification.dart';
import 'package:localnewsapp/constants/app_colors.dart';

import 'package:localnewsapp/explore.dart';
import 'package:localnewsapp/add.dart';
import 'package:localnewsapp/home.dart';

import 'package:localnewsapp/profile.dart';
import 'package:localnewsapp/pages/search_page.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeContainer extends StatelessWidget {
  final String title;
  const HomeContainer({super.key, required this.title});
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: Identification().isAdmin ? 4 : 3,
        child: Scaffold(
            appBar: AppBar(
              leading: Image.asset('assets/logow.png',height: 20,width: 20),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: Text("name".tr()),
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
                
                    TextButton(
                      onPressed: () {
                        context.setLocale(context.locale.languageCode == 'en'
                            ? const Locale('am')
                            : const Locale('en'));
                      },
                      child: Text(
                        context.locale.languageCode == 'en' ? 'አማ' : 'En',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              height: 60.0,
              
              // color: Theme.of(context).colorScheme.secondary,
              child: TabBar(
                //unselectedLabelColor: Colors.white,
                labelColor:  AppColors.secondary,
                unselectedLabelColor:  AppColors.primary,
                tabs: Identification().isAdmin
                    ? const [
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
                      ]
                    : const [
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
                children: Identification().isAdmin
                    ? [
                        const Home(),
                        const Explore(),
                        const Add(),
                        const Profile(),
                      ]
                    : [
                        const Home(),
                        const Explore(),
                        const Profile(),
                      ])));
  }
}
