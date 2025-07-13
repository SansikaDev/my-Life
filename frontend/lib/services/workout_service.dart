import '../models/workout_plan_model.dart';
import '../models/purchase_model.dart';
import '../models/coach_model.dart';
import '../models/exercise_model.dart';

class WorkoutService {
  // Dummy workout plans created by coaches
  static final List<WorkoutPlanModel> _workoutPlans = [
    WorkoutPlanModel(
      id: '1',
      name: 'Beginner Weight Loss Program',
      description: 'Perfect for beginners looking to lose weight and build healthy habits.',
      coachId: 'coach1',
      coachName: 'Sarah Wilson',
      coachImage: null,
      category: 'Weight Loss',
      difficulty: 'Beginner',
      duration: 4, // weeks
      workoutsPerWeek: 3,
      price: 29.99,
      isPremium: true,
      imageUrl: null,
      videoUrl: null,
      workouts: _createDummyWorkouts('Beginner Weight Loss'),
      tags: ['No Equipment', 'Home Workout', 'Beginner Friendly'],
      rating: 4.8,
      reviewCount: 156,
      purchaseCount: 342,
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    WorkoutPlanModel(
      id: '2',
      name: 'Advanced Strength Training',
      description: 'Build muscle and strength with this comprehensive program.',
      coachId: 'coach2',
      coachName: 'Mike Johnson',
      coachImage: null,
      category: 'Muscle Gain',
      difficulty: 'Advanced',
      duration: 8, // weeks
      workoutsPerWeek: 4,
      price: 49.99,
      isPremium: true,
      imageUrl: null,
      videoUrl: null,
      workouts: _createDummyWorkouts('Advanced Strength'),
      tags: ['Gym Required', 'Strength Training', 'Advanced'],
      rating: 4.9,
      reviewCount: 89,
      purchaseCount: 234,
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
    ),
    WorkoutPlanModel(
      id: '3',
      name: 'Quick Home Cardio',
      description: 'Fast-paced cardio workouts you can do anywhere.',
      coachId: 'coach3',
      coachName: 'John Doe',
      coachImage: null,
      category: 'Cardio',
      difficulty: 'Intermediate',
      duration: 2, // weeks
      workoutsPerWeek: 5,
      price: 0.0, // Free
      isPremium: false,
      imageUrl: null,
      videoUrl: null,
      workouts: _createDummyWorkouts('Quick Cardio'),
      tags: ['No Equipment', 'Quick Workouts', 'Cardio'],
      rating: 4.6,
      reviewCount: 203,
      purchaseCount: 567,
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Dummy coaches
  static final List<CoachModel> _coaches = [
    CoachModel(
      id: 'coach1',
      name: 'Sarah Wilson',
      email: 'sarah@fitvibe.com',
      profileImage: null,
      bio: 'Certified personal trainer with 8 years of experience in weight loss and nutrition.',
      specializations: ['Weight Loss', 'Nutrition', 'HIIT'],
      rating: 4.9,
      reviewCount: 234,
      experienceYears: 8,
      certifications: ['NASM CPT', 'Precision Nutrition', 'ACE Fitness'],
      phoneNumber: '+1-555-0123',
      isAvailable: true,
      hourlyRate: 75.0,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    ),
    CoachModel(
      id: 'coach2',
      name: 'Mike Johnson',
      email: 'mike@fitvibe.com',
      profileImage: null,
      bio: 'Former professional athlete turned strength and conditioning coach.',
      specializations: ['Strength Training', 'Athletic Performance', 'Muscle Building'],
      rating: 4.8,
      reviewCount: 189,
      experienceYears: 12,
      certifications: ['CSCS', 'USA Weightlifting', 'CrossFit L2'],
      phoneNumber: '+1-555-0124',
      isAvailable: true,
      hourlyRate: 95.0,
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      updatedAt: DateTime.now(),
    ),
    CoachModel(
      id: 'coach3',
      name: 'John Doe',
      email: 'john@fitvibe.com',
      profileImage: null,
      bio: 'Yoga and functional fitness expert helping people move better.',
      specializations: ['Yoga', 'Functional Fitness', 'Mobility'],
      rating: 4.7,
      reviewCount: 156,
      experienceYears: 6,
      certifications: ['RYT-200', 'Functional Movement Screen', 'TRX'],
      phoneNumber: '+1-555-0125',
      isAvailable: true,
      hourlyRate: 65.0,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Dummy exercises
  static final List<ExerciseModel> _exercises = [
    ExerciseModel(
      id: 'ex1',
      name: 'Push-ups',
      description: 'Classic bodyweight exercise for chest, shoulders, and triceps.',
      category: 'Strength',
      difficulty: 'Beginner',
      imageUrl: null,
      videoUrl: null,
      muscleGroups: ['Chest', 'Shoulders', 'Triceps'],
      equipment: ['Bodyweight'],
      duration: null,
      sets: 3,
      reps: 10,
      weight: null,
      instructions: 'Start in plank position, lower body until chest nearly touches ground, then push back up.',
      tips: ['Keep core tight', 'Maintain straight body line'],
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ExerciseModel(
      id: 'ex2',
      name: 'Squats',
      description: 'Fundamental lower body exercise for legs and glutes.',
      category: 'Strength',
      difficulty: 'Beginner',
      imageUrl: null,
      videoUrl: null,
      muscleGroups: ['Quadriceps', 'Glutes', 'Hamstrings'],
      equipment: ['Bodyweight'],
      duration: null,
      sets: 3,
      reps: 15,
      weight: null,
      instructions: 'Stand with feet shoulder-width apart, lower body as if sitting back, then return to standing.',
      tips: ['Keep knees behind toes', 'Push through heels'],
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ExerciseModel(
      id: 'ex3',
      name: 'Burpees',
      description: 'Full-body cardio exercise combining squat, push-up, and jump.',
      category: 'Cardio',
      difficulty: 'Intermediate',
      imageUrl: null,
      videoUrl: null,
      muscleGroups: ['Full Body'],
      equipment: ['Bodyweight'],
      duration: 30,
      sets: null,
      reps: null,
      weight: null,
      instructions: 'Squat down, place hands on ground, jump feet back to plank, do push-up, jump feet forward, jump up.',
      tips: ['Maintain good form', 'Start slow and build speed'],
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  // Get all workout plans
  static List<WorkoutPlanModel> getAllWorkoutPlans() {
    return _workoutPlans;
  }

  // Get free workout plans
  static List<WorkoutPlanModel> getFreeWorkoutPlans() {
    return _workoutPlans.where((plan) => !plan.isPremium).toList();
  }

  // Get premium workout plans
  static List<WorkoutPlanModel> getPremiumWorkoutPlans() {
    return _workoutPlans.where((plan) => plan.isPremium).toList();
  }

  // Get workout plans by category
  static List<WorkoutPlanModel> getWorkoutPlansByCategory(String category) {
    return _workoutPlans.where((plan) => plan.category == category).toList();
  }

  // Get workout plans by difficulty
  static List<WorkoutPlanModel> getWorkoutPlansByDifficulty(String difficulty) {
    return _workoutPlans.where((plan) => plan.difficulty == difficulty).toList();
  }

  // Get workout plan by ID
  static WorkoutPlanModel? getWorkoutPlanById(String id) {
    try {
      return _workoutPlans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all coaches
  static List<CoachModel> getAllCoaches() {
    return _coaches;
  }

  // Get available coaches
  static List<CoachModel> getAvailableCoaches() {
    return _coaches.where((coach) => coach.isAvailable).toList();
  }

  // Get coach by ID
  static CoachModel? getCoachById(String id) {
    try {
      return _coaches.firstWhere((coach) => coach.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all exercises
  static List<ExerciseModel> getAllExercises() {
    return _exercises;
  }

  // Get exercises by category
  static List<ExerciseModel> getExercisesByCategory(String category) {
    return _exercises.where((exercise) => exercise.category == category).toList();
  }

  // Get exercises by difficulty
  static List<ExerciseModel> getExercisesByDifficulty(String difficulty) {
    return _exercises.where((exercise) => exercise.difficulty == difficulty).toList();
  }

  // Purchase workout plan
  static Future<Map<String, dynamic>> purchaseWorkoutPlan(String planId, String userId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      final plan = getWorkoutPlanById(planId);
      if (plan == null) {
        return {
          'success': false,
          'message': 'Workout plan not found.',
        };
      }

      // Create purchase record
      final purchase = PurchaseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        itemId: planId,
        itemType: 'workout_plan',
        itemName: plan.name,
        amount: plan.price,
        currency: 'USD',
        status: 'completed',
        paymentMethod: 'credit_card',
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      );

      return {
        'success': true,
        'message': 'Workout plan purchased successfully!',
        'purchase': purchase,
        'plan': plan,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during purchase.',
      };
    }
  }

  // Book coach
  static Future<Map<String, dynamic>> bookCoach({
    required String coachId,
    required String userId,
    required String bookingType,
    required int sessions,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      final coach = getCoachById(coachId);
      if (coach == null) {
        return {
          'success': false,
          'message': 'Coach not found.',
        };
      }

      final totalAmount = coach.hourlyRate * sessions;

      // Create booking record
      final booking = CoachBookingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        coachId: coachId,
        coachName: coach.name,
        coachImage: coach.profileImage,
        bookingType: bookingType,
        sessions: sessions,
        pricePerSession: coach.hourlyRate,
        totalAmount: totalAmount,
        currency: 'USD',
        status: 'pending',
        bookingDate: DateTime.now(),
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(Duration(days: 30 * sessions)),
        sessionsList: List.generate(sessions, (index) => SessionModel(
          id: 'session_${index + 1}',
          scheduledDate: DateTime.now().add(Duration(days: (index + 1) * 7)),
          duration: 60,
          status: 'scheduled',
        )),
      );

      return {
        'success': true,
        'message': 'Coach booked successfully!',
        'booking': booking,
        'coach': coach,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during booking.',
      };
    }
  }

  // Create dummy workouts for workout plans
  static List<WorkoutModel> _createDummyWorkouts(String planType) {
    if (planType == 'Beginner Weight Loss') {
      return [
        WorkoutModel(
          id: 'w1',
          name: 'Day 1: Cardio Kickstart',
          description: 'Light cardio to get your heart rate up and burn calories.',
          dayNumber: 1,
          estimatedDuration: 30,
          exercises: [
            WorkoutExerciseModel(
              exerciseId: 'ex3',
              exerciseName: 'Burpees',
              sets: null,
              reps: null,
              duration: 30,
              restTime: 30,
            ),
            WorkoutExerciseModel(
              exerciseId: 'ex2',
              exerciseName: 'Squats',
              sets: 3,
              reps: 15,
              restTime: 60,
            ),
          ],
        ),
        WorkoutModel(
          id: 'w2',
          name: 'Day 2: Upper Body Focus',
          description: 'Target your upper body with bodyweight exercises.',
          dayNumber: 2,
          estimatedDuration: 25,
          exercises: [
            WorkoutExerciseModel(
              exerciseId: 'ex1',
              exerciseName: 'Push-ups',
              sets: 3,
              reps: 10,
              restTime: 60,
            ),
          ],
        ),
      ];
    } else if (planType == 'Advanced Strength') {
      return [
        WorkoutModel(
          id: 'w3',
          name: 'Day 1: Chest and Triceps',
          description: 'Build upper body strength with compound movements.',
          dayNumber: 1,
          estimatedDuration: 45,
          exercises: [
            WorkoutExerciseModel(
              exerciseId: 'ex1',
              exerciseName: 'Push-ups',
              sets: 4,
              reps: 15,
              restTime: 90,
            ),
          ],
        ),
      ];
    } else {
      return [
        WorkoutModel(
          id: 'w4',
          name: 'Quick Cardio Blast',
          description: 'Fast-paced cardio workout to boost your metabolism.',
          dayNumber: 1,
          estimatedDuration: 20,
          exercises: [
            WorkoutExerciseModel(
              exerciseId: 'ex3',
              exerciseName: 'Burpees',
              sets: null,
              reps: null,
              duration: 20,
              restTime: 10,
            ),
          ],
        ),
      ];
    }
  }
} 