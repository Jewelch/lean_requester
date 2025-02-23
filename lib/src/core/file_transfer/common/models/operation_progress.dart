class OperationProgress {
  final int transferred;
  final int total;
  final double progress;

  const OperationProgress({
    required this.transferred,
    required this.total,
    required this.progress,
  });

  double get percentage => (transferred / total);
  String get formattedPercentage => '${((transferred / total) * 100).toStringAsFixed(0)}%';
  String get formattedSize => '${(total / 1024 / 1024).toStringAsFixed(1)} MB';
  String get formattedProgress => '${(transferred / 1024 / 1024).toStringAsFixed(1)} MB / $formattedSize';
}
