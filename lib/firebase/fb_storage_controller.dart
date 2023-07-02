import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app/models/fb_response.dart';
import 'package:firebase_app/utils/firebase_helper.dart';

class FbStorageController with FirebaseHelper {

  final FirebaseStorage _storage = FirebaseStorage.instance;

  ///Functions
///1) upload
///2) read
///3) delete

  UploadTask upload(String path){
    return _storage
        .ref('image_${DateTime.now()
        .millisecondsSinceEpoch}').putFile(File(path));
  }

  Future<List<Reference>> read() async{
    ListResult result = await _storage.ref().listAll();
    if(result.items.isNotEmpty){
      return result.items;
    }
    return [];
  }

  Future<FbResponse> delete(String path){
    return _storage
        .ref(path)
        .delete()
        .then((value) => getResponse())
        .catchError((_) => getResponse(error: true));
  }
}