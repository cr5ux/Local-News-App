import 'package:flutter/material.dart';
import 'package:localnewsapp/comment_activity_detail.dart';
import 'package:localnewsapp/constants/app_colors.dart';
import 'package:localnewsapp/document_activitiy_detail.dart';
import 'package:localnewsapp/singleton/identification.dart';
import 'package:localnewsapp/dataAccess/comment_repo.dart';
import 'package:localnewsapp/dataAccess/document_repo.dart';
import 'package:localnewsapp/dataAccess/model/comment.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';



class Activity extends StatelessWidget {
  
  final String userID=Identification().userID;


  final cR=CommentRepo();
  final dR=DocumentRepo();

  Activity({super.key});


  Future<List<Document>> getLikes() async {
      
     var likess=await dR.getDocumentLikesByAUser(userID);


     return likess;

  }
  Future<List<Document>> getView() async {
    
    var viewss=await dR.getDocumentViewByAUser(userID);
    

    return viewss;

  }
  Future<List<Document>> getShares() async {

    var sharess=await dR.getDocumentShareByAUser(userID);

    
    
    return sharess;

  }
  Future<List<Comment>>  getComment() async
  {
     var commentss=await cR.getCommentByUserID(userID);
    

      return commentss;


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
      body:FutureBuilder<List<dynamic>>(
          future: Future.wait([getView(),getComment(),getLikes(),getShares()]),
          initialData:const [ "Loading ....."], 
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot)
                {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData ) {
                    return const Center(child: Text('No articles available'));
                  }

                  return ListView (
                            children: [
                                ListTile(
                                  leading:const Icon(Icons.view_array_outlined,color: AppColors.primary,),
                                  title: const Text("Views"),
                                  subtitle: Text("${snapshot.data![0].length}"),
                                  trailing: const Icon(Icons.arrow_forward_ios_outlined,color: AppColors.primary,),
                                  
                                  onTap: (){
                                      
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentActivitiyDetail(documentsnapshot: snapshot.data![0],)));
                                  },
                                ),
                                ListTile(
                                  leading:const Icon(Icons.comment,color: AppColors.primary,),
                                  title: const Text("Comments"),
                                  subtitle: Text("${snapshot.data![1].length}"),
                                  trailing: const Icon(Icons.arrow_forward_ios_outlined,color: AppColors.primary,),
                                  onTap: (){
                                    
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentActivityDetail(commentsnapshot: snapshot.data![1])));
                                  },
                                ),
                                ListTile(
                                  leading:const Icon(Icons.heart_broken,color: AppColors.primary,),
                                  trailing: const Icon(Icons.arrow_forward_ios_outlined,color: AppColors.primary,),
                                  subtitle: Text("${snapshot.data![2].length}"),
                                  title: const Text("Likes"),
                                  onTap: (){
                                    
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentActivitiyDetail(documentsnapshot: snapshot.data![2],)));
                                  },
                                ),
                                ListTile(
                                  leading:const Icon(Icons.share,color: AppColors.primary,),
                                  title: const Text("Shares"),
                                  subtitle: Text("${snapshot.data![3].length}"),
                                  trailing: const Icon(Icons.arrow_forward_ios_outlined,color: AppColors.primary,),
                                  onTap: (){
                                    
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentActivitiyDetail(documentsnapshot: snapshot.data![3],)));
                                  },
                                )
                              ],
                            
                      );
                }
          
       ),
    );
     

}
}   
 