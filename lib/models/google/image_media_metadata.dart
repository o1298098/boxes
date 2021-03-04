class ImageMediaMetadata {
  int width;
  int height;
  int rotation;

  ImageMediaMetadata({
    this.width,
    this.height,
    this.rotation,
  });

  factory ImageMediaMetadata.fromJson(Map<String, dynamic> json) {
    return ImageMediaMetadata(
      width: json['width'] as int,
      height: json['height'] as int,
      rotation: json['rotation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'rotation': rotation,
    };
  }
}
