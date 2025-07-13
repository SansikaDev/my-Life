class CoachModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final List<String> specializations; // e.g., ["Weight Loss", "Strength Training", "Yoga"]
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final List<String> certifications;
  final String? phoneNumber;
  final bool isAvailable;
  final double hourlyRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoachModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    required this.specializations,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.certifications,
    this.phoneNumber,
    required this.isAvailable,
    required this.hourlyRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) => CoachModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        email: json['email'],
        profileImage: json['profileImage'],
        bio: json['bio'],
        specializations: List<String>.from(json['specializations']),
        rating: json['rating']?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] ?? 0,
        experienceYears: json['experienceYears'] ?? 0,
        certifications: List<String>.from(json['certifications']),
        phoneNumber: json['phoneNumber'],
        isAvailable: json['isAvailable'] ?? true,
        hourlyRate: json['hourlyRate']?.toDouble() ?? 0.0,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'bio': bio,
        'specializations': specializations,
        'rating': rating,
        'reviewCount': reviewCount,
        'experienceYears': experienceYears,
        'certifications': certifications,
        'phoneNumber': phoneNumber,
        'isAvailable': isAvailable,
        'hourlyRate': hourlyRate,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
} 