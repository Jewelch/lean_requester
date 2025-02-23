enum FileOperationState {
  notStarted,
  downloading,
  completed,
  failed,
}

enum FileOperationError {
  downloadFailed,
  fileNotFound,
  unexpectedError,
}
