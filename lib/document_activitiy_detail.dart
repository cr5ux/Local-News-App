import 'package:flutter/material.dart';
import 'package:localnewsapp/constants/app_colors.dart';
 
import 'package:localnewsapp/dataAccess/model/document.dart';


// ignore: must_be_immutable
class DocumentActivitiyDetail extends StatefulWidget {
  
  List<Document> documentsnapshot=List.empty();

 DocumentActivitiyDetail({super.key, required this.documentsnapshot});//, this.commentsnapshot});
  
  @override
  State<DocumentActivitiyDetail> createState() => _DocumentActivitiyDetailState();
}

class _DocumentActivitiyDetailState extends State<DocumentActivitiyDetail> {

  late List<Document> _documentsnapshot ;
  
  @override
  void initState() {
    super.initState();
   _documentsnapshot=widget.documentsnapshot;
  
  }


  @override
  Widget build(BuildContext context) {
 
     return Scaffold(
             appBar: AppBar(
                backgroundColor: AppColors.primary,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                
              ),
              body: _documentsnapshot.isEmpty? const Center(child: Text("No items Available", style: TextStyle(fontSize:22,color: Colors.black, fontStyle: FontStyle.normal),),):ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount:_documentsnapshot.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                              leading:const Icon(Icons.view_agenda_outlined,color: AppColors.primary,),
                              title: Text(_documentsnapshot[index].title),
                              subtitle: Text(_documentsnapshot[index].language),
                              trailing: Text(_documentsnapshot[index].registrationDate),

                            
                          );
                    },
                  ),
     );
   
  }
}