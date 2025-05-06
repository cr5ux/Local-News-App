
import 'package:localnewsapp/add.dart';
import 'package:localnewsapp/login.dart';
import 'package:localnewsapp/profile.dart';
import 'package:localnewsapp/settings.dart';
import 'package:flutter/material.dart';



class Popupmenu extends StatelessWidget {

  const Popupmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuWidget();
    
  }
}

// ignore: camel_case_types
//ignore:immutable
class PopupMenuWidget extends StatelessWidget implements PreferredSizeWidget
{
  PopupMenuWidget({super.key});
  
  final List<Todo> menuList =[
    Todo(title: 'Profile'  , icon:const Icon(Icons.fastfood), path:const Profile()),
    Todo(title: 'Contacts'  , icon:const Icon(Icons.add_alarm ), path:const Add()),
    Todo(title: 'Settings'  , icon:const Icon(Icons.flight), path:const Settings()),
    Todo(title: 'Sign out'  , icon:const Icon(Icons.exit_to_app ), path:const Login())

  ];


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:preferredSize.height,
      width: double.infinity,
      child: Center(
                    child:PopupMenuButton<Todo>(
                        icon: const Icon(Icons.menu),
                        onSelected: (
                              (valueSelected)
                              {
                                   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Value Selected: ${valueSelected.title}')));
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>valueSelected.path));

                              }
                            ),
                        itemBuilder: (BuildContext context){
                            return menuList.map(
                                (Todo todomenuItem)
                                {
                                      return PopupMenuItem<Todo>(
                                            value:todomenuItem,
                                            child:Row(
                                                    children:[
                                                      Icon(todomenuItem.icon.icon),
                                                      const Padding(padding: EdgeInsets.all(16.0)),
                                                      Text(todomenuItem.title)
                                                    ]
                                            ),
                                        );
                                },

                            ).toList();
                        },
                    ) ,
             ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(250.0);
}

class Todo{
  final String title;
  final Icon icon;
  final Widget path;

  Todo({required this.title, required this.icon,required this.path });


}
