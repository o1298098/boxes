import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class Dimensions {
	final int height;
	final int width;

	const Dimensions({this.height, this.width});

	@override
	String toString() {
		return 'Dimensions(height: $height, width: $width)';
	}

	factory Dimensions.fromJson(Map<String, dynamic> json) {
		return Dimensions(
			height: json['height'] as int,
			width: json['width'] as int,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'height': height,
			'width': width,
		};
	}	

Dimensions copyWith({
		int height,
		int width,
	}) {
		return Dimensions(
			height: height ?? this.height,
			width: width ?? this.width,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is Dimensions &&
			identical(o.height, height) &&
			identical(o.width, width);

	@override
	int get hashCode => hashValues(height, width);
}
