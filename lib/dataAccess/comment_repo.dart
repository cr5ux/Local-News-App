import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/comment.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';
import 'package:localnewsapp/dataAccess/model/reply.dart';


class CommentRepo
{
    final db = FirebaseFirestore.instance;


//read
  Future<List<Comment>> getCommentByDocumentID(documentID) async
  {
        List<Comment> comment=[];
        try{
            final docCommentRef= db.collection("Comment").withConverter(fromFirestore: Comment.fromFirestore, toFirestore: (Comment comment, _)=>comment.toFirestore());  
            
            await docCommentRef.get().then(
                (docCommentSnap)
                {
            
                  for (var snap in docCommentSnap.docs)
                  {
                   
                    comment.add(snap.data());
                  }
                }
            
              );
            }
        catch(e)
        {
            rethrow;
        }

        return comment;
  
  }

  Future<List<Comment>> getCommentByUserID(userID) async
  {
        List<Comment> comment=[];
        try{
            final docCommentRef= db.collection("Comment").where("userID",isEqualTo:userID ).withConverter(fromFirestore: Comment.fromFirestore, toFirestore: (Comment comment, _)=>comment.toFirestore());  
            
            await docCommentRef.get().then(
                (docCommentSnap)
                {
            
                  for (var snap in docCommentSnap.docs)
                  {
                   
                    comment.add(snap.data());
                  }
                }
            
              );
            }
        catch(e)
        {
            rethrow;
        }

        return comment;
  
  }

  Future<Comment> getAComment(commentID) async
  {
       // ignore: prefer_typing_uninitialized_variables
        var comment;
        try{
            final commentRef= db.collection("Comment").doc(commentID).withConverter(fromFirestore: Comment.fromFirestore, toFirestore: (Comment comment, _)=>comment.toFirestore());  
            
            await commentRef.get().then(
                (commentSnap)
                {
                  comment=commentSnap.data();
                }
            
              );
            }
        catch(e)
        {
            rethrow;
        }

        return comment;
  
  }

  Future<List<Reply>> getACommentReply(commentID) async
  {
        List<Reply> commentReplies=[];
        try{
          
            final commentRef= db.collection("Comment").doc(commentID).collection("Reply").withConverter(fromFirestore: Reply.fromFirestore, toFirestore: (Reply reply, _)=>reply.toFirestore());  
            
            await commentRef.get().then(
                (commentSnap)
                {
            
                  for (var snap in commentSnap.docs)
                  {
                   
                    commentReplies.add(snap.data());
                  }
                }
            
              );
            }
        catch(e)
        {
            rethrow;
        }

        return commentReplies;
  
  }

  Future<List<LS>> getCommentLikes(commentID) async
  {
      List<LS> commentLikes=[];
      try{

          final commentRef= db.collection("Comment").doc(commentID).collection("Like").withConverter(fromFirestore: LS.fromFirestore, toFirestore: (LS ls, _)=>ls.toFirestore());  
          await commentRef.get().then(
              (commentSnap)
              {
          
                for (var snap in commentSnap.docs)
                {
                  
                  commentLikes.add(snap.data());
                }
              }
          
            );
          }
      catch(e)
      {
          rethrow;
      }

      return commentLikes;

  }


  


}