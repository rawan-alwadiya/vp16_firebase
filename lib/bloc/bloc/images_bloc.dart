import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_app/bloc/events/image_event.dart';
import 'package:firebase_app/bloc/states/image_state.dart';
import 'package:firebase_app/firebase/fb_storage_controller.dart';
import 'package:firebase_app/models/fb_response.dart';

class ImagesBloc extends Bloc<ImageEvent, ImageState> {
  ImagesBloc(super.initialState) {
//   // on<E extends Event>((event, emitter) => {})
    on<UploadEvent>(_onUploadEvent);
    on<ReadEvent>(_onReadEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  List<Reference> _references = <Reference>[];
  final FbStorageController _storageController = FbStorageController();

// void _onEvent(Event event, Emitter<State> emit) async{}
  void _onUploadEvent(UploadEvent event, Emitter<ImageState> emit) async {
    TaskSnapshot uploadTask =
        await _storageController.upload(event.path).whenComplete(() {});
    if (uploadTask.state == TaskState.success) {
      _references.add(uploadTask.ref);
      emit(ReadState(_references));
      emit(ProcessState('Upload successfully', true, ProcessType.upload));
    } else if (uploadTask.state == TaskState.error) {
      emit(ProcessState('Uploading failed!', false, ProcessType.upload));
    }
  }

  void _onReadEvent(ReadEvent event, Emitter<ImageState> emit) async {
    emit(LoadingState());
    _references = await _storageController.read();
    emit(ReadState(_references));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<ImageState> emit) async {
    FbResponse fbResponse =
        await _storageController.delete(_references[event.index].fullPath);
    if (fbResponse.success) {
      _references.removeAt(event.index);
      emit(ReadState(_references));
    }
    emit(ProcessState(
        fbResponse.message, fbResponse.success, ProcessType.delete));
  }
}
