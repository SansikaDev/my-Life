import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../services/health_sync_service.dart';
import '../constants/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthSyncScreen extends ConsumerStatefulWidget {
  const HealthSyncScreen({super.key});

  @override
  ConsumerState<HealthSyncScreen> createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends ConsumerState<HealthSyncScreen>
    with TickerProviderStateMixin {
  final HealthSyncService _healthSyncService = HealthSyncService();
  bool _isLoading = true;
  bool _isHealthAvailable = false;
  
  // Health data
  int _todaySteps = 0;
  double _todayCalories = 0;
  double _todayDistance = 0;
  int _todayWorkouts = 0;
  double? _latestWeight;
  List<HealthDataPoint> _heartRateData = [];
  List<Map<String, dynamic>> _weeklyData = [];
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeHealthSync();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
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

  Future<void> _initializeHealthSync() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if health sync is available
      bool isAvailable = await _healthSyncService.isHealthSyncAvailable();
      
      if (isAvailable) {
        // Initialize health sync
        bool initialized = await _healthSyncService.initialize();
        
        if (initialized) {
          await _loadHealthData();
        }
      }

      setState(() {
        _isHealthAvailable = isAvailable;
        _isLoading = false;
      });

      // Start animations
      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isHealthAvailable = false;
      });
    }
  }

  Future<void> _loadHealthData() async {
    try {
      // Load today's data
      DateTime today = DateTime.now();
      Map<String, dynamic> todayData = await _healthSyncService.getDailyActivitySummary(today);
      
      // Load weekly data
      List<Map<String, dynamic>> weeklyData = await _healthSyncService.getWeeklyActivitySummary();
      
      // Load heart rate data
      DateTime startDate = today.subtract(const Duration(days: 7));
      List<HealthDataPoint> heartRateData = await _healthSyncService.getHeartRateData(startDate, today);
      
      // Load weight data
      double? weight = await _healthSyncService.getLatestWeight();

      setState(() {
        _todaySteps = todayData['steps'] ?? 0;
        _todayCalories = todayData['caloriesBurned'] ?? 0;
        _todayDistance = todayData['distance'] ?? 0;
        _todayWorkouts = todayData['workouts'] ?? 0;
        _weeklyData = weeklyData;
        _heartRateData = heartRateData;
        _latestWeight = weight;
      });
    } catch (e) {
      print('Error loading health data: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title:         Text(
          'Health Sync',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadHealthData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            )
          : !_isHealthAvailable
              ? _buildHealthNotAvailable()
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildHealthContent(),
                  ),
                ),
    );
  }

  Widget _buildHealthNotAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
                      Text(
              'Health Sync Not Available',
              style: AppTheme.heading3.copyWith(
                fontSize: 24,
                color: Colors.grey[600],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'Your device doesn\'t support health data sync\nor health permissions are not granted.',
            textAlign: TextAlign.center,
            style: AppTheme.body1.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _initializeHealthSync,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthAppInfo(),
          const SizedBox(height: 30),
          _buildTodaySummary(),
          const SizedBox(height: 30),
          _buildWeeklyChart(),
          const SizedBox(height: 30),
          _buildHeartRateChart(),
          const SizedBox(height: 30),
          _buildWeightSection(),
          const SizedBox(height: 30),
          _buildSyncOptions(),
        ],
      ),
    );
  }

  Widget _buildHealthAppInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Platform.isIOS ? Icons.apple : Icons.fitness_center,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _healthSyncService.getHealthAppName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Connected and syncing',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'ACTIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Activity',
          style: AppTheme.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                'Steps',
                _todaySteps.toString(),
                'steps',
                Icons.directions_walk,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActivityCard(
                'Calories',
                _todayCalories.toStringAsFixed(0),
                'kcal',
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
              child: _buildActivityCard(
                'Distance',
                (_todayDistance / 1000).toStringAsFixed(2),
                'km',
                Icons.straighten,
                Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActivityCard(
                'Workouts',
                _todayWorkouts.toString(),
                'sessions',
                Icons.fitness_center,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    if (_weeklyData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Activity',
          style: AppTheme.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 15),
        Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                        DateTime date = DateTime.parse(_weeklyData[value.toInt()]['date']);
                        return Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _weeklyData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['steps'].toDouble());
                  }).toList(),
                  isCurved: true,
                  color: AppTheme.primaryColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeartRateChart() {
    if (_heartRateData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Process heart rate data for chart
    List<FlSpot> heartRateSpots = [];
    for (int i = 0; i < _heartRateData.length; i++) {
      if (_heartRateData[i].value is NumericHealthValue) {
        double value = (_heartRateData[i].value as NumericHealthValue).numericValue.toDouble();
        heartRateSpots.add(FlSpot(i.toDouble(), value));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heart Rate (7 days)',
          style: AppTheme.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 15),
        Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: heartRateSpots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.red.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight Tracking',
          style: AppTheme.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.monitor_weight,
                color: AppTheme.primaryColor,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Weight',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _latestWeight != null
                          ? '${_latestWeight!.toStringAsFixed(1)} kg'
                          : 'No data available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSyncOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync Options',
          style: AppTheme.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSyncOption(
                'Sync Workouts',
                'Automatically sync your workouts to ${_healthSyncService.getHealthAppName()}',
                Icons.fitness_center,
                true,
              ),
              _buildSyncOption(
                'Sync Steps',
                'Track your daily step count',
                Icons.directions_walk,
                true,
              ),
              _buildSyncOption(
                'Sync Heart Rate',
                'Monitor your heart rate during workouts',
                Icons.favorite,
                true,
              ),
              _buildSyncOption(
                'Sync Weight',
                'Track your weight progress',
                Icons.monitor_weight,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSyncOption(String title, String subtitle, IconData icon, bool isEnabled) {
    return ListTile(
      leading: Icon(
        icon,
        color: isEnabled ? AppTheme.primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isEnabled ? Colors.black : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: isEnabled,
        onChanged: (value) {
          // Handle sync option toggle
        },
        activeColor: AppTheme.primaryColor,
      ),
    );
  }
} 