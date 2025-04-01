class UploadFileModel {
  final String fileName;
  final String filePath;
  final int fileSize;
  double progress;
  String remainingTime;
  FileUploadStatus status;

  UploadFileModel({
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.progress,
    required this.remainingTime,
    required this.status,
  });
}

// Status enum for file upload
enum FileUploadStatus {
  pending,
  uploading,
  completed,
  failed,
}