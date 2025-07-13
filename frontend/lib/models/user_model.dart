class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? height; // in cm
  final double? weight; // in kg
  final String? fitnessGoal; // weight loss, muscle gain, maintenance, etc.
  final String? activityLevel; // sedentary, lightly active, moderately active, very active
  final List<String>? interests; // running, yoga, strength training, etc.
  final String? coachId; // assigned coach
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.weight,
    this.fitnessGoal,
    this.activityLevel,
    this.interests,
    this.coachId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] ?? json['id'],
        email: json['email'],
        name: json['name'],
        profileImage: json['profileImage'],
        phoneNumber: json['phoneNumber'],
        dateOfBirth: json['dateOfBirth'] != null 
            ? DateTime.parse(json['dateOfBirth']) 
            : null,
        gender: json['gender'],
        height: json['height']?.toDouble(),
        weight: json['weight']?.toDouble(),
        fitnessGoal: json['fitnessGoal'],
        activityLevel: json['activityLevel'],
        interests: json['interests'] != null 
            ? List<String>.from(json['interests']) 
            : null,
        coachId: json['coachId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'profileImage': profileImage,
        'phoneNumber': phoneNumber,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'height': height,
        'weight': weight,
        'fitnessGoal': fitnessGoal,
        'activityLevel': activityLevel,
        'interests': interests,
        'coachId': coachId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? fitnessGoal,
    String? activityLevel,
    List<String>? interests,
    String? coachId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      interests: interests ?? this.interests,
      coachId: coachId ?? this.coachId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calculate BMI
  double? get bmi {
    if (height != null && weight != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }

  // Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal weight';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }
}