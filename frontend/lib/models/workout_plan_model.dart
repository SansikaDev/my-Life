class WorkoutPlanModel {
  final String id;
  final String name;
  final String description;
  final String coachId;
  final String coachName;
  final String? coachImage;
  final String category; // weight loss, muscle gain, strength, cardio, etc.
  final String difficulty; // beginner, intermediate, advanced
  final int duration; // in weeks
  final int workoutsPerWeek;
  final double price; // in USD
  final bool isPremium; // paid plan
  final String? imageUrl;
  final String? videoUrl;
  final List<WorkoutModel> workouts;
  final List<String> tags; // e.g., ["No Equipment", "Home Workout", "Quick"]
  final double rating;
  final int reviewCount;
  final int purchaseCount;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coachId,
    required this.coachName,
    this.coachImage,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.workoutsPerWeek,
    required this.price,
    required this.isPremium,
    this.imageUrl,
    this.videoUrl,
    required this.workouts,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.purchaseCount,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) => WorkoutPlanModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        description: json['description'],
        coachId: json['coachId'],
        coachName: json['coachName'],
        coachImage: json['coachImage'],
        category: json['category'],
        difficulty: json['difficulty'],
        duration: json['duration'],
        workoutsPerWeek: json['workoutsPerWeek'],
        price: json['price']?.toDouble() ?? 0.0,
        isPremium: json['isPremium'] ?? false,
        imageUrl: json['imageUrl'],
        videoUrl: json['videoUrl'],
        workouts: (json['workouts'] as List)
            .map((workout) => WorkoutModel.fromJson(workout))
            .toList(),
        tags: List<String>.from(json['tags']),
        rating: json['rating']?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] ?? 0,
        purchaseCount: json['purchaseCount'] ?? 0,
        isPublished: json['isPublished'] ?? true,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'coachId': coachId,
        'coachName': coachName,
        'coachImage': coachImage,
        'category': category,
        'difficulty': difficulty,
        'duration': duration,
        'workoutsPerWeek': workoutsPerWeek,
        'price': price,
        'isPremium': isPremium,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'workouts': workouts.map((workout) => workout.toJson()).toList(),
        'tags': tags,
        'rating': rating,
        'reviewCount': reviewCount,
        'purchaseCount': purchaseCount,
        'isPublished': isPublished,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class WorkoutModel {
  final String id;
  final String name;
  final String description;
  final int dayNumber; // which day of the plan
  final int estimatedDuration; // in minutes
  final List<WorkoutExerciseModel> exercises;
  final String? instructions;
  final String? imageUrl;
  final String? videoUrl;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dayNumber,
    required this.estimatedDuration,
    required this.exercises,
    this.instructions,
    this.imageUrl,
    this.videoUrl,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        description: json['description'],
        dayNumber: json['dayNumber'],
        estimatedDuration: json['estimatedDuration'],
        exercises: (json['exercises'] as List)
            .map((exercise) => WorkoutExerciseModel.fromJson(exercise))
            .toList(),
        instructions: json['instructions'],
        imageUrl: json['imageUrl'],
        videoUrl: json['videoUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'dayNumber': dayNumber,
        'estimatedDuration': estimatedDuration,
        'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
        'instructions': instructions,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
      };
}

class WorkoutExerciseModel {
  final String exerciseId;
  final String exerciseName;
  final String? imageUrl;
  final String? videoUrl;
  final int? sets;
  final int? reps;
  final int? duration; // in seconds
  final double? weight; // in kg
  final int restTime; // in seconds
  final String? notes;

  WorkoutExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
    this.imageUrl,
    this.videoUrl,
    this.sets,
    this.reps,
    this.duration,
    this.weight,
    required this.restTime,
    this.notes,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) => WorkoutExerciseModel(
        exerciseId: json['exerciseId'],
        exerciseName: json['exerciseName'],
        imageUrl: json['imageUrl'],
        videoUrl: json['videoUrl'],
        sets: json['sets'],
        reps: json['reps'],
        duration: json['duration'],
        weight: json['weight']?.toDouble(),
        restTime: json['restTime'] ?? 60,
        notes: json['notes'],
      );

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'sets': sets,
        'reps': reps,
        'duration': duration,
        'weight': weight,
        'restTime': restTime,
        'notes': notes,
      };
} 