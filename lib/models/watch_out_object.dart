class WatchOutObject {
  final String id;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const WatchOutObject({
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  WatchOutObject.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        createdAt = intToDateTime(map["created_at"]),
        modifiedAt = intToDateTime(map["modified_at"]);

  static DateTime intToDateTime(int? millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch == null) {
      return DateTime(2022);
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  static DateTime? intToDateTimeNullable(int? millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "created_at": createdAt.millisecondsSinceEpoch,
      "modified_at": modifiedAt.millisecondsSinceEpoch,
    };
  }
}
