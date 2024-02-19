import 'package:watch_out/models/watch_out_object.dart';

class User extends WatchOutObject {
  final String email;
  final String profilePhotoUrl;
  final String gender;
  final String name;
  final String phone;

  const User({
    required String id,
    required this.email,
    required this.name,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.profilePhotoUrl = "",
    this.gender = "",
    this.phone = "",
  }) : super(
          id: id,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
        );

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePhotoUrl,
    String? gender,
    String? phone,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  User.fromMap(Map<String, dynamic> map)
      : email = map["email"],
        profilePhotoUrl = map["profile_photo_url"],
        name = map["name"],
        gender = map["gender"],
        phone = map["phone"],
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "profile_photo_url": profilePhotoUrl,
      "name": name,
      "gender": gender,
      "phone": phone,
      ...super.toMap(),
    };
  }
}
