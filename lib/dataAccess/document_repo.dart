import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';
import 'package:localnewsapp/dataAccess/model/ls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentRepo {
  final db = FirebaseFirestore.instance;

//read
Future<List<Document>> getAllDocuments() async {

    List<Document> docs = [];
    try {
      // Define the query with a converter
      final docRef = db
          .collection("Document")
          .where("isActive",
              isEqualTo: true) // Note: "true" should be a boolean, not a string
          .withConverter(
            fromFirestore: Document.fromFirestore,
            toFirestore: (Document doc, _) => doc.toFirestore(),
          );

      // Fetch the documents
      await docRef.get().then((docSnap) {
        // Loop through each document snapshot and print its data
        for (var snap in docSnap.docs) {
          final docData = snap.data();
          docs.add(docData);
        }
      });
    } catch (e) {
      rethrow;
    }

    return docs;
  }

Future<Document> getADocumentByID(documentID) async {
    // ignore: prefer_typing_uninitialized_variables
    var doc;
    try {
      final docRef = db.collection("Document").doc(documentID).withConverter(
          fromFirestore: Document.fromFirestore,
          toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.get().then((docSnap) {
        doc = docSnap.data();
      });
    } catch (e) {
      rethrow;
    }

    return doc;
  }

  Future<List<Document>> getDocumentByDocumentType(documentType) async {
    List<Document> docs = [];
    try {
      final docRef = db
          .collection("Document")
          .where("documentType", isEqualTo: documentType)
          .withConverter(
              fromFirestore: Document.fromFirestore,
              toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docs.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docs;
  }

Future<List<Document>> getDocumentByTags(String tag) async {
    List<Document> docs = [];
    try {
      final docRef = db
          .collection("Document")
          .where("tags", arrayContains: tag)
          .withConverter(
              fromFirestore: Document.fromFirestore,
              toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docs.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docs;
  }

Future<List<LS>> getDocumentLikes(documentID) async {
    List<LS> docLikes = [];
    try {
      final docLikeRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Like")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      await docLikeRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docLikes.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docLikes;
  }

Future<List<LS>> getDocumentShare(documentID) async {
    List<LS> docShare = [];
    try {
      final docShareRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Share")
          .where("isActive", isEqualTo: "true")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      await docShareRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docShare.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docShare;
  }

  Future<List<LS>> getDocumentView(documentID) async {
    List<LS> docView = [];
    try {
      final docViewRef = db
          .collection("Document")
          .doc(documentID)
          .collection("View")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      await docViewRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docView.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docView;
  }

  Future<List<Document>> getDocumentLikesByAUser(userID) async {
    List<Document> allDocs = await getAllDocuments();

    List<Document> docLikes = [];
    try {
      for (Document i in allDocs) {
        final docLikeRef = db
            .collection("Document")
            .doc(i.documentID)
            .collection("Like")
            .where("userID", isEqualTo: userID)
            .withConverter(
                fromFirestore: LS.fromFirestore,
                toFirestore: (LS ls, _) => ls.toFirestore());

        await docLikeRef.get().then((docSnap) {
          if (docSnap.docs.isNotEmpty) {
            for (var snap in docSnap.docs) {
              final data = snap.data();
              i = i.copyWith(registrationDate: data.date);
            }

            docLikes.add(i);
          }
        });
      }
    } catch (e) {
      rethrow;
    }

    return docLikes;
  }

Future<List<Document>> getDocumentShareByAUser(userID) async {
    List<Document> allDocs = await getAllDocuments();

    List<Document> docShare = [];
    try {
      for (var i in allDocs) {
        final docShareRef = db
            .collection("Document")
            .doc(i.documentID)
            .collection("Share")
            .where("userID", isEqualTo: userID)
            .withConverter(
                fromFirestore: LS.fromFirestore,
                toFirestore: (LS ls, _) => ls.toFirestore());

        await docShareRef.get().then((docSnap) {
          if (docSnap.docs.isNotEmpty) {
            for (var snap in docSnap.docs) {
              final data = snap.data();
              i = i.copyWith(registrationDate: data.date);
            }
            docShare.add(i);
          }
        });
      }
    } catch (e) {
      rethrow;
    }

    return docShare;
  }

Future<List<Document>> getDocumentViewByAUser(userID) async {
    List<Document> allDocs = await getAllDocuments();

    List<Document> docView = [];

    try {
      for (var i in allDocs) {
        final docViewRef = db
            .collection("Document")
            .doc(i.documentID)
            .collection("View")
            .where("userID", isEqualTo: userID)
            .withConverter(
                fromFirestore: LS.fromFirestore,
                toFirestore: (LS ls, _) => ls.toFirestore());

        await docViewRef.get().then((docSnap) {
          if (docSnap.docs.isNotEmpty) {
            for (var snap in docSnap.docs) {
              final data = snap.data();
              i = i.copyWith(registrationDate: data.date);
            }
            docView.add(i);
          }
        });
      }
    } catch (e) {
      rethrow;
    }

    return docView;
  }

Future<List<Document>> getDocumentByAuthorID(userID) async {
    List<Document> docs = [];
    try {
      final docRef = db
          .collection("Document")
          .where("authorID", isEqualTo: userID)
          .where("isActive", isEqualTo: "true")
          .withConverter(
              fromFirestore: Document.fromFirestore,
              toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docs.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docs;
  }

Future<List<Document>> getDocumentByRegistrationDate(date) async {
    List<Document> docs = [];
    try {
      final docRef = db
          .collection("Document")
          .where("registrationDate", isEqualTo: date)
          .where("isActive", isEqualTo: "true")
          .withConverter(
              fromFirestore: Document.fromFirestore,
              toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          docs.add(snap.data());
        }
      });
    } catch (e) {
      rethrow;
    }

    return docs;
  }















//add

Future<String> addDocument(document,imageBytes,imageExtension) async {

    String message = "";
    try {
      final docRef = db.collection("Document").withConverter( fromFirestore: Document.fromFirestore,toFirestore: (Document doc, _) => doc.toFirestore());

      var m = await docRef.add(document);

      final imagePath='${m.id}.$imageExtension';
      final result=await addImageToSupabase(imagePath, imageBytes);

       if(result.contains('failure'))
       {
           await docRef.doc(m.id).delete();

           

            return "$result, upload failed";
       }


      message = result;

      return message;
    } catch (e) {
      return e.toString();
    }
  }



Future<dynamic> addImageToSupabase(imagePath,imageBytes) async
{
   
    String imageUrl;
    try {
          await Supabase.instance.client.storage.from('document/document_Cover_Image').uploadBinary(imagePath,imageBytes,
                  fileOptions: const FileOptions(
                    upsert: true, // Overwrite if file with same name exists
                    contentType: 'image/*', // Accepts various image types
                  ),
                );

          imageUrl = Supabase.instance.client.storage.from('document/document_Cover_Image').getPublicUrl(imagePath);
      } catch (e) {
        
        return "failure ${e.toString()}";
        
      }

        
    
      
    return imageUrl;

}



Future<String> addAShare(documentID, ls) async {
    String message = "";
    try {
      final docRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Share")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      var m = await docRef.add(ls);

      message = "$m registration sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }

Future<String> addALike(documentID, ls) async {
    String message = "";
    try {
      final docRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Like")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      var m = await docRef.add(ls);

      message = "$m registration sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }

Future<String> addAView(documentID, ls) async {
    String message = "";
    try {
      final docRef = db
          .collection("Document")
          .doc(documentID)
          .collection("View")
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      var m = await docRef.add(ls);

      message = "$m registration sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }
















//update

Future<String> updateDocumentActive(documentID, isActive) async {
    String message = "";
    try {
      final docRef = db.collection("Document").doc(documentID).withConverter(
          fromFirestore: Document.fromFirestore,
          toFirestore: (Document doc, _) => doc.toFirestore());

      await docRef.update({"isActive": isActive});

      message = "update sucessful";

      return message;
    } catch (e) {
      rethrow;
    }
  }

Future<String> updateDocumentLike(documentID, userID) async {
    String message = "";
    String? lsid = "";
    try {
      final docRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Like")
          .where("userID", isEqualTo: userID)
          .limit(1)
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      await docRef.get().then((docSnap) {
        for (var snap in docSnap.docs) {
          lsid = snap.data().id;
        }
      });

      await db
          .collection("Document")
          .doc(documentID)
          .collection("Like")
          .doc(lsid)
          .delete()
          .then((val) => message = "deletion successful");

      return message;
    } catch (e) {
      rethrow;
    }
  }

  // Check if a specific user has liked a document
Future<bool> hasUserLikedDocument(String documentID, String userID) async {
    try {
      final docLikeRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Like")
          .where("userID", isEqualTo: userID)
          .withConverter(
              fromFirestore: LS.fromFirestore,
              toFirestore: (LS ls, _) => ls.toFirestore());

      final snapshot = await docLikeRef.get();
      return snapshot
          .docs.isNotEmpty; // If any document exists, the user has liked it
    } catch (e) {
      return false; // Assume not liked in case of error
    }
  }

























  // Add bookmark methods
Future<List<Document>> getDocumentBookmarksByAUser(userID) async {
    List<Document> allDocs = await getAllDocuments();
    List<Document> bookmarkedDocs = [];

    try {
      for (Document doc in allDocs) {
        final bookmarkRef = db
            .collection("Document")
            .doc(doc.documentID)
            .collection("Bookmark")
            .where("userID", isEqualTo: userID)
            .withConverter(
                fromFirestore: LS.fromFirestore,
                toFirestore: (LS ls, _) => ls.toFirestore());

        await bookmarkRef.get().then((docSnap) {
          if (docSnap.docs.isNotEmpty) {
            for (var snap in docSnap.docs) {
              final data = snap.data();
              doc = doc.copyWith(registrationDate: data.date);
            }
            bookmarkedDocs.add(doc);
          }
        });
      }
    } catch (e) {
      rethrow;
    }

    return bookmarkedDocs;
  }














  Future<void> addABookmark(String documentID, LS bookmark) async {
    try {
      await db
          .collection("Document")
          .doc(documentID)
          .collection("Bookmark")
          .add(bookmark.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeBookmark(String documentID, String userID) async {
    try {
      final bookmarkRef = db
          .collection("Document")
          .doc(documentID)
          .collection("Bookmark")
          .where("userID", isEqualTo: userID);

      final querySnapshot = await bookmarkRef.get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
