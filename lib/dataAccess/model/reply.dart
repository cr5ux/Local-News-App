
import 'package:localnewsapp/dataAccess/model/ls.dart';

class Reply
{
    final String id;
    final String message;
    final DateTime date;
    final List<LS> like;
    final String usersID;

    Reply({required this.id, required this.message, required this.date, required this.like ,required this.usersID});

}