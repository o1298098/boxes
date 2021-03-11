import 'dimensions.dart';

class LowMetadata {
  String tag;
  Dimensions dimensions;
  DateTime timeTaken;
  int duration;

  LowMetadata({
    this.tag,
    this.dimensions,
    this.timeTaken,
    this.duration,
  });

  factory LowMetadata.fromJson(Map<String, dynamic> json) {
    return LowMetadata(
      tag: json['.tag'] as String,
      dimensions: json['dimensions'] == null
          ? null
          : Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
      timeTaken: json['time_taken'] == null
          ? null
          : DateTime.parse(json['time_taken'] as String),
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '.tag': tag,
      'dimensions': dimensions?.toJson(),
      'time_taken': timeTaken?.toIso8601String(),
      'duration': duration,
    };
  }
}
