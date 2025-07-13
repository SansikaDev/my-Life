import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../constants/app_theme.dart';
import '../services/workout_tracking_service.dart';
import '../models/health_data_model.dart';

class WorkoutTrackingScreen extends ConsumerStatefulWidget {
  const WorkoutTrackingScreen({super.key});

  @override
  ConsumerState<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends ConsumerState<WorkoutTrackingScreen>
    with TickerProviderStateMixin {
  final WorkoutTrackingService _trackingService = WorkoutTrackingService();
  
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Tracking state
  bool _isTracking = false;
  String _selectedWorkoutType = 'Running';
  Map<String, dynamic> _currentMetrics = {};
  StreamSubscription<Map<String, dynamic>>? _metricsSubscription;
  
  // Workout types
  final List<String> _workoutTypes = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
    'Strength Training',
    'Yoga',
    'HIIT',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupMetricsListener();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _setupMetricsListener() {
    _metricsSubscription = _trackingService.metricsStream.listen((metrics) {
      setState(() {
        _currentMetrics = metrics;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _metricsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startWorkout() async {
    bool success = await _trackingService.startWorkout(
      workoutType: _selectedWorkoutType,
    );
    
    if (success) {
      setState(() {
        _isTracking = true;
      });
      _pulseController.repeat(reverse: true);
      _slideController.forward();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start workout tracking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopWorkout() async {
    WorkoutSession? session = await _trackingService.stopWorkout();
    
    if (session != null) {
      setState(() {
        _isTracking = false;
      });
      _pulseController.stop();
      _pulseController.reset();
      
      // Show workout summary
      _showWorkoutSummary(session);
    }
  }

  void _showWorkoutSummary(WorkoutSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Workout Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${session.type}'),
            Text('Duration: ${session.duration.toStringAsFixed(0)} minutes'),
            Text('Calories: ${session.calories.toStringAsFixed(0)} kcal'),
            if (session.distance != null)
              Text('Distance: ${(session.distance! / 1000).toStringAsFixed(2)} km'),
            if (session.averageHeartRate != null)
              Text('Avg Heart Rate: ${session.averageHeartRate!.toStringAsFixed(0)} bpm'),
            const SizedBox(height: 16),
            Text(
              'Your workout has been synced to your health app!',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title:         Text(
          'Workout Tracking',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildWorkoutTypeSelector(),
              const SizedBox(height: 30),
              _buildTrackingCard(),
              const SizedBox(height: 30),
              _buildMetricsDisplay(),
              const SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Workout Type',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _workoutTypes.map((type) {
              bool isSelected = _selectedWorkoutType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWorkoutType = type;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: _isTracking ? AppTheme.primaryGradient : AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isTracking ? Icons.fitness_center : Icons.play_arrow,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isTracking ? 'Workout in Progress' : 'Ready to Start',
            style: AppTheme.heading2.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isTracking ? _selectedWorkoutType : 'Select a workout type above',
            style: AppTheme.body1.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsDisplay() {
    if (!_isTracking) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Metrics',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Duration',
                  '${_currentMetrics['duration']?.toStringAsFixed(0) ?? '0'} min',
                  Icons.timer,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildMetricCard(
                  'Calories',
                  '${_currentMetrics['calories']?.toStringAsFixed(0) ?? '0'} kcal',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Distance',
                  '${(_currentMetrics['distance'] ?? 0).toStringAsFixed(2)} km',
                  Icons.straighten,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildMetricCard(
                  'Heart Rate',
                  '${_currentMetrics['heartRate']?.toStringAsFixed(0) ?? '--'} bpm',
                  Icons.favorite,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isTracking ? null : _startWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Start Workout',
              style: AppTheme.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: _isTracking ? _stopWorkout : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Stop Workout',
              style: AppTheme.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 