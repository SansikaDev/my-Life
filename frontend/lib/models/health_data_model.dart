class HealthDataModel {
  final int steps;
  final double caloriesBurned;
  final double distance;
  final int workouts;
  final double? weight;
  final double? heartRate;
  final double? sleepHours;
  final DateTime date;
  final String source;

  HealthDataModel({
    required this.steps,
    required this.caloriesBurned,
    required this.distance,
    required this.workouts,
    this.weight,
    this.heartRate,
    this.sleepHours,
    required this.date,
    required this.source,
  });

  factory HealthDataModel.fromMap(Map<String, dynamic> map) {
    return HealthDataModel(
      steps: map['steps'] ?? 0,
      caloriesBurned: (map['caloriesBurned'] ?? 0).toDouble(),
      distance: (map['distance'] ?? 0).toDouble(),
      workouts: map['workouts'] ?? 0,
      weight: map['weight']?.toDouble(),
      heartRate: map['heartRate']?.toDouble(),
      sleepHours: map['sleepHours']?.toDouble(),
      date: DateTime.parse(map['date']),
      source: map['source'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'distance': distance,
      'workouts': workouts,
      'weight': weight,
      'heartRate': heartRate,
      'sleepHours': sleepHours,
      'date': date.toIso8601String(),
      'source': source,
    };
  }

  HealthDataModel copyWith({
    int? steps,
    double? caloriesBurned,
    double? distance,
    int? workouts,
    double? weight,
    double? heartRate,
    double? sleepHours,
    DateTime? date,
    String? source,
  }) {
    return HealthDataModel(
      steps: steps ?? this.steps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      distance: distance ?? this.distance,
      workouts: workouts ?? this.workouts,
      weight: weight ?? this.weight,
      heartRate: heartRate ?? this.heartRate,
      sleepHours: sleepHours ?? this.sleepHours,
      date: date ?? this.date,
      source: source ?? this.source,
    );
  }
}

class WorkoutSession {
  final String id;
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final double duration; // in minutes
  final double calories;
  final double? distance;
  final double? averageHeartRate;
  final double? maxHeartRate;
  final String? notes;

  WorkoutSession({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.calories,
    this.distance,
    this.averageHeartRate,
    this.maxHeartRate,
    this.notes,
  });

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'],
      type: map['type'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      duration: (map['duration'] ?? 0).toDouble(),
      calories: (map['calories'] ?? 0).toDouble(),
      distance: map['distance']?.toDouble(),
      averageHeartRate: map['averageHeartRate']?.toDouble(),
      maxHeartRate: map['maxHeartRate']?.toDouble(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'calories': calories,
      'distance': distance,
      'averageHeartRate': averageHeartRate,
      'maxHeartRate': maxHeartRate,
      'notes': notes,
    };
  }
}

class HealthGoal {
  final String id;
  final String type; // 'steps', 'calories', 'workouts', 'weight'
  final double target;
  final String unit;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  HealthGoal({
    required this.id,
    required this.type,
    required this.target,
    required this.unit,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory HealthGoal.fromMap(Map<String, dynamic> map) {
    return HealthGoal(
      id: map['id'],
      type: map['type'],
      target: (map['target'] ?? 0).toDouble(),
      unit: map['unit'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'target': target,
      'unit': unit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class HealthMetrics {
  final double? bmi;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final double? waterPercentage;
  final double? boneDensity;
  final DateTime measurementDate;

  HealthMetrics({
    this.bmi,
    this.bodyFatPercentage,
    this.muscleMass,
    this.waterPercentage,
    this.boneDensity,
    required this.measurementDate,
  });

  factory HealthMetrics.fromMap(Map<String, dynamic> map) {
    return HealthMetrics(
      bmi: map['bmi']?.toDouble(),
      bodyFatPercentage: map['bodyFatPercentage']?.toDouble(),
      muscleMass: map['muscleMass']?.toDouble(),
      waterPercentage: map['waterPercentage']?.toDouble(),
      boneDensity: map['boneDensity']?.toDouble(),
      measurementDate: DateTime.parse(map['measurementDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'waterPercentage': waterPercentage,
      'boneDensity': boneDensity,
      'measurementDate': measurementDate.toIso8601String(),
    };
  }
} 