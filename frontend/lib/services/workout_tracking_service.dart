import 'dart:async';
import '../models/health_data_model.dart';
import 'health_sync_service.dart';

class WorkoutTrackingService {
  static final WorkoutTrackingService _instance = WorkoutTrackingService._internal();
  factory WorkoutTrackingService() => _instance;
  WorkoutTrackingService._internal();

  final HealthSyncService _healthSyncService = HealthSyncService();
  
  // Workout tracking state
  bool _isTracking = false;
  DateTime? _workoutStartTime;
  String? _currentWorkoutType;
  double _currentCalories = 0;
  double _currentDistance = 0;
  double _averageHeartRate = 0;
  double _maxHeartRate = 0;
  List<double> _heartRateReadings = [];
  
  // Stream controllers for real-time updates
  final StreamController<WorkoutSession> _workoutController = StreamController<WorkoutSession>.broadcast();
  final StreamController<Map<String, dynamic>> _metricsController = StreamController<Map<String, dynamic>>.broadcast();
  
  // Getters
  bool get isTracking => _isTracking;
  DateTime? get workoutStartTime => _workoutStartTime;
  String? get currentWorkoutType => _currentWorkoutType;
  double get currentCalories => _currentCalories;
  double get currentDistance => _currentDistance;
  double get averageHeartRate => _averageHeartRate;
  double get maxHeartRate => _maxHeartRate;
  
  // Streams
  Stream<WorkoutSession> get workoutStream => _workoutController.stream;
  Stream<Map<String, dynamic>> get metricsStream => _metricsController.stream;

  /// Start tracking a workout
  Future<bool> startWorkout({
    required String workoutType,
    String? notes,
  }) async {
    if (_isTracking) {
      print('Workout already in progress');
      return false;
    }

    try {
      // Initialize health sync if not already done
      bool healthInitialized = await _healthSyncService.initialize();
      if (!healthInitialized) {
        print('Failed to initialize health sync');
        return false;
      }

      // Reset tracking state
      _workoutStartTime = DateTime.now();
      _currentWorkoutType = workoutType;
      _currentCalories = 0;
      _currentDistance = 0;
      _averageHeartRate = 0;
      _maxHeartRate = 0;
      _heartRateReadings.clear();
      _isTracking = true;

      // Start periodic updates
      _startPeriodicUpdates();

      print('Workout tracking started: $workoutType');
      return true;
    } catch (e) {
      print('Error starting workout: $e');
      return false;
    }
  }

  /// Stop tracking the current workout
  Future<WorkoutSession?> stopWorkout() async {
    if (!_isTracking || _workoutStartTime == null) {
      print('No workout in progress');
      return null;
    }

    try {
      DateTime endTime = DateTime.now();
      double duration = endTime.difference(_workoutStartTime!).inMinutes.toDouble();
      
      // Calculate average heart rate
      if (_heartRateReadings.isNotEmpty) {
        _averageHeartRate = _heartRateReadings.reduce((a, b) => a + b) / _heartRateReadings.length;
      }

      // Create workout session
      WorkoutSession workoutSession = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _currentWorkoutType!,
        startTime: _workoutStartTime!,
        endTime: endTime,
        duration: duration,
        calories: _currentCalories,
        distance: _currentDistance > 0 ? _currentDistance : null,
        averageHeartRate: _averageHeartRate > 0 ? _averageHeartRate : null,
        maxHeartRate: _maxHeartRate > 0 ? _maxHeartRate : null,
        notes: null,
      );

      // Sync to health app
      await _healthSyncService.writeWorkout(
        startTime: _workoutStartTime!,
        endTime: endTime,
        workoutType: _currentWorkoutType!,
        calories: _currentCalories,
        distance: _currentDistance,
      );

      // Reset tracking state
      _isTracking = false;
      _workoutStartTime = null;
      _currentWorkoutType = null;
      _currentCalories = 0;
      _currentDistance = 0;
      _averageHeartRate = 0;
      _maxHeartRate = 0;
      _heartRateReadings.clear();

      // Stop periodic updates
      _stopPeriodicUpdates();

      // Emit final workout data
      _workoutController.add(workoutSession);

      print('Workout tracking stopped: ${workoutSession.type}');
      return workoutSession;
    } catch (e) {
      print('Error stopping workout: $e');
      return null;
    }
  }

  /// Pause the current workout
  void pauseWorkout() {
    if (_isTracking) {
      _isTracking = false;
      print('Workout paused');
    }
  }

  /// Resume the current workout
  void resumeWorkout() {
    if (!_isTracking && _workoutStartTime != null) {
      _isTracking = true;
      print('Workout resumed');
    }
  }

  /// Update workout metrics
  void updateMetrics({
    double? calories,
    double? distance,
    double? heartRate,
  }) {
    if (!_isTracking) return;

    if (calories != null) {
      _currentCalories = calories;
    }
    
    if (distance != null) {
      _currentDistance = distance;
    }
    
    if (heartRate != null) {
      _heartRateReadings.add(heartRate);
      if (heartRate > _maxHeartRate) {
        _maxHeartRate = heartRate;
      }
    }

    // Emit updated metrics
    _metricsController.add({
      'calories': _currentCalories,
      'distance': _currentDistance,
      'heartRate': heartRate,
      'duration': DateTime.now().difference(_workoutStartTime!).inMinutes,
    });
  }

  /// Start periodic updates for real-time tracking
  void _startPeriodicUpdates() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isTracking) {
        timer.cancel();
        return;
      }

      // Simulate calorie burn (in real app, this would come from sensors)
      if (_currentWorkoutType != null) {
        double caloriesPerMinute = _getCaloriesPerMinute(_currentWorkoutType!);
        _currentCalories += caloriesPerMinute * (5 / 60); // 5 seconds worth
      }

      // Emit current metrics
      _metricsController.add({
        'calories': _currentCalories,
        'distance': _currentDistance,
        'duration': DateTime.now().difference(_workoutStartTime!).inMinutes,
        'heartRate': _averageHeartRate,
      });
    });
  }

  /// Stop periodic updates
  void _stopPeriodicUpdates() {
    // Timer cancellation is handled in _startPeriodicUpdates
  }

  /// Get calories burned per minute for different workout types
  double _getCaloriesPerMinute(String workoutType) {
    switch (workoutType.toLowerCase()) {
      case 'running':
        return 12.0;
      case 'walking':
        return 4.0;
      case 'cycling':
        return 8.0;
      case 'swimming':
        return 10.0;
      case 'strength training':
        return 6.0;
      case 'yoga':
        return 3.0;
      case 'hiit':
        return 15.0;
      default:
        return 5.0;
    }
  }

  /// Get current workout progress
  Map<String, dynamic> getCurrentProgress() {
    if (!_isTracking || _workoutStartTime == null) {
      return {};
    }

    int duration = DateTime.now().difference(_workoutStartTime!).inMinutes;
    
    return {
      'type': _currentWorkoutType,
      'duration': duration,
      'calories': _currentCalories,
      'distance': _currentDistance,
      'averageHeartRate': _averageHeartRate,
      'maxHeartRate': _maxHeartRate,
    };
  }

  /// Get workout history
  Future<List<WorkoutSession>> getWorkoutHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      startDate ??= DateTime.now().subtract(const Duration(days: 30));
      endDate ??= DateTime.now();

      // For now, return empty list as we need to implement proper workout history
      // This would typically fetch from a local database or API
      return [];
    } catch (e) {
      print('Error getting workout history: $e');
      return [];
    }
  }

  /// Get workout statistics
  Future<Map<String, dynamic>> getWorkoutStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<WorkoutSession> sessions = await getWorkoutHistory(startDate: startDate, endDate: endDate);
      
      if (sessions.isEmpty) {
        return {
          'totalWorkouts': 0,
          'totalDuration': 0,
          'totalCalories': 0,
          'totalDistance': 0,
          'averageDuration': 0,
          'averageCalories': 0,
        };
      }

      double totalDuration = sessions.fold(0, (sum, session) => sum + session.duration);
      double totalCalories = sessions.fold(0, (sum, session) => sum + session.calories);
      double totalDistance = sessions.fold(0, (sum, session) => sum + (session.distance ?? 0));

      return {
        'totalWorkouts': sessions.length,
        'totalDuration': totalDuration,
        'totalCalories': totalCalories,
        'totalDistance': totalDistance,
        'averageDuration': totalDuration / sessions.length,
        'averageCalories': totalCalories / sessions.length,
      };
    } catch (e) {
      print('Error getting workout stats: $e');
      return {};
    }
  }

  /// Dispose resources
  void dispose() {
    _workoutController.close();
    _metricsController.close();
  }
} 