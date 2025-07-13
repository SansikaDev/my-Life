class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String category; // strength, cardio, flexibility, etc.
  final String difficulty; // beginner, intermediate, advanced
  final String? imageUrl;
  final String? videoUrl;
  final List<String> muscleGroups; // chest, back, legs, etc.
  final List<String> equipment; // dumbbells, barbell, bodyweight, etc.
  final int? duration; // in seconds
  final int? sets;
  final int? reps;
  final double? weight; // in kg
  final String? instructions;
  final List<String>? tips;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    this.imageUrl,
    this.videoUrl,
    required this.muscleGroups,
    required this.equipment,
    this.duration,
    this.sets,
    this.reps,
    this.weight,
    this.instructions,
    this.tips,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        difficulty: json['difficulty'],
        imageUrl: json['imageUrl'],
        videoUrl: json['videoUrl'],
        muscleGroups: List<String>.from(json['muscleGroups']),
        equipment: List<String>.from(json['equipment']),
        duration: json['duration'],
        sets: json['sets'],
        reps: json['reps'],
        weight: json['weight']?.toDouble(),
        instructions: json['instructions'],
        tips: json['tips'] != null ? List<String>.from(json['tips']) : null,
        isFavorite: json['isFavorite'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'difficulty': difficulty,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'muscleGroups': muscleGroups,
        'equipment': equipment,
        'duration': duration,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'instructions': instructions,
        'tips': tips,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? difficulty,
    String? imageUrl,
    String? videoUrl,
    List<String>? muscleGroups,
    List<String>? equipment,
    int? duration,
    int? sets,
    int? reps,
    double? weight,
    String? instructions,
    List<String>? tips,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      equipment: equipment ?? this.equipment,
      duration: duration ?? this.duration,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      instructions: instructions ?? this.instructions,
      tips: tips ?? this.tips,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 