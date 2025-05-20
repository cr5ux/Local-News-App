import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class FilemanipulationRepo
{


//upload a file return the path 

Future<String> uploadFile(filedevicepath,documenttype,documentname) async
{

  final uploadFile = File(filedevicepath);

  final String fullPath = await Supabase.instance.client.storage.from('document').upload(
        documenttype=='Text'?'text/$documentname':'video/$documentname',
        uploadFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      return fullPath;

}

















}