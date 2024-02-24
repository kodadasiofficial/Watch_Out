import 'package:watch_out/models/watch_out_object.dart';

class Report extends WatchOutObject {
  final double latitude;
  final double longitude;
  final String reporterName;
  final String reporterProfilePhoto;
  final String reporterMail;
  final String reportType;
  final String report;
  final String reportHead;
  final String description;
  final int like;
  final int dislike;

  const Report({
    required String id,
    required this.latitude,
    required this.longitude,
    required this.reporterName,
    required this.reporterProfilePhoto,
    required this.reporterMail,
    required this.reportType,
    required this.report,
    required this.reportHead,
    required this.description,
    required this.like,
    required this.dislike,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
        );

  Report copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? reporterName,
    String? reporterProfilePhoto,
    String? reporterMail,
    String? reportType,
    String? report,
    String? reportHead,
    String? description,
    int? like,
    int? dislike,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Report(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reporterName: reporterName ?? this.reporterName,
      reporterProfilePhoto: reporterProfilePhoto ?? this.reporterProfilePhoto,
      reporterMail: reporterMail ?? this.reporterMail,
      reportType: reportType ?? this.reportType,
      reportHead: reportHead ?? this.reportHead,
      report: report ?? this.report,
      description: description ?? this.description,
      like: like ?? this.like,
      dislike: dislike ?? this.dislike,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Report.fromMap(Map<String, dynamic> map)
      : latitude = map["latitude"].toDouble(),
        longitude = map["longitude"].toDouble(),
        reporterName = map["reporter_name"],
        reporterProfilePhoto = map["reporter_profile_photo"],
        reporterMail = map["reporter_mail"],
        reportType = map["report_type"],
        report = map["report"],
        reportHead = map["report_head"],
        description = map["description"],
        like = map["like"],
        dislike = map["dislike"],
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "reporter_name": reporterName,
      "reporter_profile_photo": reporterProfilePhoto,
      "reporter_mail": reporterMail,
      "report_type": reportType,
      "report": report,
      "report_head": reportHead,
      "description": description,
      "like": like,
      "dislike": dislike,
      ...super.toMap(),
    };
  }
}
