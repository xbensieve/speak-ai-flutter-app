class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String fullName;
  final DateTime birthday;
  final String gender;
  final DateTime? premiumExpiredTime; // Made nullable
  final double point;
  final String levelName;
  final bool isPremium;
  final bool isVerified;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.premiumExpiredTime,
    required this.point,
    required this.levelName,
    required this.isPremium,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      birthday: DateTime.tryParse(json['birthday'] ?? '') ?? DateTime(1970),
      gender: json['gender'] ?? '',
      premiumExpiredTime:
          json['premiumExpiredTime'] != null
              ? DateTime.tryParse(json['premiumExpiredTime'])
              : null,
      point: (json['point'] ?? 0).toDouble(),
      levelName: json['levelName'] ?? '',
      isPremium: json['isPremium'] ?? false,
      isVerified: json['isVerified'] ?? false,
    );
  }
}
