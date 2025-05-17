import 'package:flutter/material.dart';
//import 'package:localnewsapp/dataAccess/document_repo.dart';
//import 'package:localnewsapp/dataAccess/users_repo.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  getAllUsers()
  {
      
        //final uR= UsersRepo();
        /*
          // uR.getAllUsers();
          // uR.getAUserByID("9kwEiPS2NbyEZfUN57kF") as Iterable;
          // uR.getAUserByEmail("armatemsamuel@gmail.com");
          // uR.getAUserByPhonenumber("+251925364879");
          // uR.getUserPreferenceTags("9kwEiPS2NbyEZfUN57kF");
          // uR.getUserForbiddenTags("9kwEiPS2NbyEZfUN57kF");
          // uR.getAUserLogin("9kwEiPS2NbyEZfUN57kF");
        
          //change the data for the next trial //uR.addUser(new Users(fullName: "Senait Mekonnen Yelma", birthday: "6/7/1990", address: ["Ethiopia","Amhara","Gonder"], phonenumber: "+251785963214", preferenceTags: ["Politics"], forbiddenTags: ["Sports"], email: "senaitM@gmail.com", password: "963524178"));
          // uR.addForbiddenTags("9kwEiPS2NbyEZfUN57kF", ["Cooking","Politics"]);
          // uR.addPreferenceTags("9kwEiPS2NbyEZfUN57kF", ["Sport","Medical"]);
      */


      
        //final dR= DocumentRepo();
      /*
          // dR.addDocument(Document(documentName: "Document One", title: "Live and Lives", documentPath: "/doc/name/path", language: "Amharic", indexTermsAM: ["ቃል አንድ", "ቃል ሁለት","ቃል ሶስት"], indexTermsEN: ["Term1", "Term2","Term3"], registrationDate: "17/5/2025", isActive:true , authorID: "9kwEiPS2NbyEZfUN57kF", tags: ["#sport","#arsenal"], documentType: "Text"));
          // dR.addAView("jtyjvG4rrWwuP1YV0vTD", LS(userID: "9kwEiPS2NbyEZfUN57kF", date: "17/5/2025"));
          // dR.addALike("jtyjvG4rrWwuP1YV0vTD", LS(userID: "9kwEiPS2NbyEZfUN57kF", date: "17/5/2025"));
          // dR.addAShare("jtyjvG4rrWwuP1YV0vTD", LS(userID: "9kwEiPS2NbyEZfUN57kF", date: "17/5/2025"));
          
          // dR.getAllDocuments();
          // dR.getADocumentByID("jtyjvG4rrWwuP1YV0vTD");
          // dR.getDocumentByDocumentType("Text");
          // dR.getDocumentByAuthorID("9kwEiPS2NbyEZfUN57kF");
          // dR.getDocumentByRegistrationDate("17/5/2025");
          // dR.getDocumentByTags("#sport");
          // dR.getDocumentLikes("jtyjvG4rrWwuP1YV0vTD");
          // dR.getDocumentLikesByAUser("9kwEiPS2NbyEZfUN57kF");
          // dR.getDocumentShare("jtyjvG4rrWwuP1YV0vTD");
          // dR.getDocumentShareByAUser("9kwEiPS2NbyEZfUN57kF");
          // dR.getDocumentView("jtyjvG4rrWwuP1YV0vTD");
          // dR.getDocumentViewByAUser("9kwEiPS2NbyEZfUN57kF");

      */
  }

  @override
  Widget build (BuildContext context)
  {
  

   return Center(
      child: Column(
        children: [
            const Text("Home", style: TextStyle(fontSize: 24)),
            const Padding(padding: EdgeInsets.all(15)),
            ElevatedButton(

              onPressed: getAllUsers,
              child: const Text("Press")
            ),
        ],
      )
      
    );
              

  }
}