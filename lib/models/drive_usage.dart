class DriveUsage {
  const DriveUsage({this.allocated, this.used, this.lastUpdateTime});
  final int used;
  final int allocated;
  final DateTime lastUpdateTime;

  @override
  String toString() {
    return '{"used": $used, "allocated": $allocated,"lastUpdateTime":"${lastUpdateTime?.toIso8601String() ?? '1970-07-01'}"}';
  }

  factory DriveUsage.fromJson(Map<String, dynamic> json) {
    return DriveUsage(
        used: json['used'] as int,
        allocated: json['allocated'] as int,
        lastUpdateTime: DateTime.parse(json['lastUpdateTime'] ?? '1970-07-01'));
  }
}
