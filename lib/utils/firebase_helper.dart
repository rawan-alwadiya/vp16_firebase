import 'package:flutter/material.dart';
import 'package:firebase_app/models/fb_response.dart';

mixin FirebaseHelper {
  FbResponse getResponse({bool error = false}) => FbResponse(
    error ? 'Operation failed' : 'Operation completed successfully',!error);

}