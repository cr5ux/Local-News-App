import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/comment.dart';




// ignore: must_be_immutable
class CommentActivityDetail extends StatefulWidget {
  
  List<Comment> commentsnapshot=List.empty();


 CommentActivityDetail({super.key, required this.commentsnapshot});
  
  @override
  State<CommentActivityDetail> createState() => _CommentActivityDetailState();
}

class _CommentActivityDetailState extends State<CommentActivityDetail> {

  late List<Comment> _commentsnapshot ;

  @override
  void initState() {

    
    super.initState();
   _commentsnapshot=widget.commentsnapshot;
 
  }


  @override
  Widget build(BuildContext context) {
 
 final dR=DocumentRepo();
     return Scaffold(
        appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
          ),
          body:  _commentsnapshot .isEmpty? const Center(child: Text("No items Available", style: TextStyle(fontSize:22,color: Colors.black, fontStyle: FontStyle.normal),),):
              ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount:_commentsnapshot.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                        future: dR.getADocumentByID(_commentsnapshot[index].documentID), 
                        builder: (context, snapshot)
                          {
                                return ListTile(
                                    leading:const Icon(Icons.comment),
                                    title: Text(_commentsnapshot[index].message),
                                    subtitle: Text(snapshot.data!.title),
                                    trailing: Text(_commentsnapshot[index].registrationDate),
                                  
                                  
                                );
                            },
                        
                   );
                 
                },
           ), 
      );  
   
  }
}