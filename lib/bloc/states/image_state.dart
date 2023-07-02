import 'package:firebase_storage/firebase_storage.dart';

enum ProcessType{upload,delete}

class ImageState {}

class LoadingState extends ImageState {}

class ProcessState extends ImageState{
  final String message;
  final bool success;
  final ProcessType processType;

  ProcessState(this.message, this.success, this.processType);
}

class ReadState extends ImageState{
  final List<Reference> references;

  ReadState(this.references);
}