class VideoMediaMetadata {
  int width;
  int height;
  String durationMillis;

  VideoMediaMetadata({
    this.width,
    this.height,
    this.durationMillis,
  });

  factory VideoMediaMetadata.fromJson(Map<String, dynamic> json) {
    return VideoMediaMetadata(
      width: json['width'] as int,
      height: json['height'] as int,
      durationMillis: json['durationMillis'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'durationMillis': durationMillis,
    };
  }
}
