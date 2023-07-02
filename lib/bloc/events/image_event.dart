class ImageEvent {}

class UploadEvent extends ImageEvent{
  final String path;

  UploadEvent(this.path);
}

class ReadEvent extends ImageEvent{}

class DeleteEvent extends ImageEvent{
  final int index;

  DeleteEvent(this.index);
}