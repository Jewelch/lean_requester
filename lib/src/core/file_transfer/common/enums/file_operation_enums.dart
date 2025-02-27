enum FileOperationState {
  notStarted,
  processing,
  completed,
  failed,
}

enum FileOperationError {
  downloadFailed,
  fileNotFound,
  unexpectedError,
}
