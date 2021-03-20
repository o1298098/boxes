import 'dart:convert' show json;

class DriveUsage {
  const DriveUsage({this.allocated, this.used, this.lastUpdateTime});
  final int used;
  final int allocated;
  final DateTime lastUpdateTime;

  @override
  String toString() {
    return '{"used": $used, "allocated": $allocated,"lastUpdateTime":"${lastUpdateTime?.toIso8601String() ?? '1970-07-01'}"}';
  }

  factory DriveUsage.fromJson(dynamic map) {
    final Map<String, dynamic> _json = map is String ? json.decode(map) : map;
    return DriveUsage(
        used: _json['used'] as int,
        allocated: _json['allocated'] as int,
        lastUpdateTime:
            DateTime.parse(_json['lastUpdateTime'] ?? '1970-07-01'));
  }
}
