import 'dart:async';
import 'dart:io';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthSyncService {
  static final HealthSyncService _instance = HealthSyncService._internal();
  factory HealthSyncService() => _instance;
  HealthSyncService._internal();

  bool _isInitialized = false;
  late Health _health;

  // Health data types we want to read
  final List<HealthDataType> _readDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.WORKOUT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.DISTANCE_CYCLING,
    HealthDataType.DISTANCE_SWIMMING,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_IN_BED,
  ];

  // Health data types we want to write
  final List<HealthDataType> _writeDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
  ];

  /// Initialize health sync service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _health = Health();
      
      // Request permissions
      bool hasPermissions = await _requestPermissions();
      if (!hasPermissions) {
        print('Health permissions not granted');
        return false;
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Error initializing health sync: $e');
      return false;
    }
  }

  /// Request health permissions
  Future<bool> _requestPermissions() async {
    try {
      // Request health permissions - using a simpler approach
      bool hasPermissions = await _health.requestAuthorization(_readDataTypes);

      // Also request location permission for workout tracking
      if (Platform.isAndroid) {
        await Permission.location.request();
      }

      return hasPermissions;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  /// Get steps count for a specific date range
  Future<int> getStepsCount(DateTime startDate, DateTime endDate) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return 0;
    }

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.STEPS],
      );

      int totalSteps = 0;
      for (HealthDataPoint dataPoint in healthData) {
        if (dataPoint.value is NumericHealthValue) {
          totalSteps += (dataPoint.value as NumericHealthValue).numericValue.toInt();
        }
      }

      return totalSteps;
    } catch (e) {
      print('Error getting steps count: $e');
      return 0;
    }
  }

  /// Get heart rate data for a specific date range
  Future<List<HealthDataPoint>> getHeartRateData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return [];
    }

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.HEART_RATE],
      );

      return healthData;
    } catch (e) {
      print('Error getting heart rate data: $e');
      return [];
    }
  }

  /// Get workout data for a specific date range
  Future<List<HealthDataPoint>> getWorkoutData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return [];
    }

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.WORKOUT],
      );

      return healthData;
    } catch (e) {
      print('Error getting workout data: $e');
      return [];
    }
  }

  /// Get weight data
  Future<double?> getLatestWeight() async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return null;
    }

    try {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(const Duration(days: 30));

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: now,
        types: [HealthDataType.WEIGHT],
      );

      if (healthData.isNotEmpty) {
        // Get the most recent weight measurement
        healthData.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
        if (healthData.first.value is NumericHealthValue) {
          return (healthData.first.value as NumericHealthValue).numericValue.toDouble();
        }
      }

      return null;
    } catch (e) {
      print('Error getting weight data: $e');
      return null;
    }
  }

  /// Get sleep data for a specific date range
  Future<List<HealthDataPoint>> getSleepData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return [];
    }

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.SLEEP_ASLEEP, HealthDataType.SLEEP_IN_BED],
      );

      return healthData;
    } catch (e) {
      print('Error getting sleep data: $e');
      return [];
    }
  }

  /// Write workout data to health app (not supported in health package v13+)
  Future<bool> writeWorkout({
    required DateTime startTime,
    required DateTime endTime,
    required String workoutType,
    required double calories,
    required double distance,
  }) async {
    // Not supported in health package v13+ (writing is not implemented)
    print('Workout data would be written to health app (not supported in health package v13+)');
    return false;
  }

  /// Write steps data to health app (not supported in health package v13+)
  Future<bool> writeSteps(int steps, DateTime date) async {
    // Not supported in health package v13+ (writing is not implemented)
    print('Steps data would be written: $steps steps on ${date.toString()} (not supported in health package v13+)');
    return false;
  }

  /// Get daily activity summary
  Future<Map<String, dynamic>> getDailyActivitySummary(DateTime date) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) return {};
    }

    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = startDate.add(const Duration(days: 1));

      // Get steps
      int steps = await getStepsCount(startDate, endDate);

      // Get calories burned
      List<HealthDataPoint> caloriesData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );

      double caloriesBurned = 0;
      for (HealthDataPoint dataPoint in caloriesData) {
        if (dataPoint.value is NumericHealthValue) {
          caloriesBurned += (dataPoint.value as NumericHealthValue).numericValue.toDouble();
        }
      }

      // Get distance
      List<HealthDataPoint> distanceData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [HealthDataType.DISTANCE_WALKING_RUNNING],
      );

      double distance = 0;
      for (HealthDataPoint dataPoint in distanceData) {
        if (dataPoint.value is NumericHealthValue) {
          distance += (dataPoint.value as NumericHealthValue).numericValue.toDouble();
        }
      }

      // Get workouts
      List<HealthDataPoint> workoutData = await getWorkoutData(startDate, endDate);

      return {
        'steps': steps,
        'caloriesBurned': caloriesBurned,
        'distance': distance,
        'workouts': workoutData.length,
        'date': date.toIso8601String(),
      };
    } catch (e) {
      print('Error getting daily activity summary: $e');
      return {};
    }
  }

  /// Get weekly activity summary
  Future<List<Map<String, dynamic>>> getWeeklyActivitySummary() async {
    List<Map<String, dynamic>> weeklyData = [];

    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      Map<String, dynamic> dailyData = await getDailyActivitySummary(date);
      weeklyData.add(dailyData);
    }

    return weeklyData;
  }

  /// Check if health sync is available
  Future<bool> isHealthSyncAvailable() async {
    try {
      _health = Health();
      // Try to initialize and see if it works
      bool initialized = await initialize();
      return initialized;
    } catch (e) {
      return false;
    }
  }

  /// Get health app name
  String getHealthAppName() {
    if (Platform.isIOS) {
      return 'Apple Health';
    } else if (Platform.isAndroid) {
      return 'Google Fit';
    }
    return 'Health App';
  }
} 