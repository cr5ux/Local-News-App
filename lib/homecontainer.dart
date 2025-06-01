import 'package:flutter/material.dart';

import 'package:localnewsapp/business/identification.dart';

import 'package:localnewsapp/explore.dart';
import 'package:localnewsapp/add.dart';
import 'package:localnewsapp/home.dart';
import 'package:localnewsapp/login.dart';

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
              leading: const Icon(Icons.newspaper),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text("name".tr()),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    context.setLocale(context.locale.languageCode == 'en'
                        ? const Locale('am')
                        : const Locale('en'));
                  },
                  icon: const Icon(
                    Icons.language_outlined,
                    color: Colors.white,
                  ),
                ),
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
                    },
                    icon: const Icon(Icons.exit_to_app)),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              height: 60.0,
              // color: Theme.of(context).colorScheme.secondary,
              child: TabBar(
                //unselectedLabelColor: Colors.white,
                labelColor: Colors.black,

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
