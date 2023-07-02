import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_app/bloc/bloc/images_bloc.dart';
import 'package:firebase_app/bloc/events/image_event.dart';
import 'package:firebase_app/bloc/states/image_state.dart';
import 'package:firebase_app/utils/context_extension.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  late ImagePicker _imagePicker;
  XFile? _pickedImage;
  double? _progressValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: BlocListener<ImagesBloc,ImageState>(
        listenWhen: (previous, current) => current is ProcessState && current.processType == ProcessType.upload,
        listener: (context,state){
          state as ProcessState;
          if(state.success) setState(() =>_pickedImage = null);
          _changeProgress(progress : state.success ? 1 : 0);
          context.showSnackBar(message: state.message, error: !state.success);
        },
        child: Column(
          children: [
            LinearProgressIndicator(
              color: Colors.green,
              minHeight: 6,
              value: _progressValue,
            ),
            _pickedImage != null
                ? Expanded(child: Image.file(File(_pickedImage!.path)))
                : Expanded(
              child: IconButton(
                onPressed: ()=> _pickImage(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.camera_alt_outlined,
                  size: 50,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: ()=> _performUpload(),
              label: const Text('UPLOAD'),
              icon: const Icon(Icons.cloud_upload),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async{
    XFile? imageFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if(imageFile != null){
      setState((){
        _pickedImage = imageFile;
      });
    }
  }

  void _performUpload(){
    if(_checkData()){
      _uploadImage();
    }
  }

  bool _checkData(){
    if(_pickedImage != null){
      return true;
    }
    context.showSnackBar(message: 'Pick image to upload', error: true);
    return false;
  }

  void _uploadImage() async{
    _changeProgress();
    BlocProvider.of<ImagesBloc>(context).add(UploadEvent(_pickedImage!.path));
  }

  void _changeProgress({double? progress}){
    setState(()=> _progressValue = progress);
  }
}
