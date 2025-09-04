import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/workout_plan_model.dart';
import '../services/workout_service.dart';
import '../services/auth_service.dart';

class WorkoutPlansScreen extends StatefulWidget {
  const WorkoutPlansScreen({super.key});

  @override
  State<WorkoutPlansScreen> createState() => _WorkoutPlansScreenState();
}

class _WorkoutPlansScreenState extends State<WorkoutPlansScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  final List<String> _categories = ['All', 'Weight Loss', 'Muscle Gain', 'Cardio', 'Strength'];
  final List<String> _difficulties = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Free Plans'),
            Tab(text: 'Premium Plans'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    items: _difficulties.map((difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Plans List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Free Plans
                _buildPlansList(WorkoutService.getFreeWorkoutPlans()),
                // Premium Plans
                _buildPlansList(WorkoutService.getPremiumWorkoutPlans()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<WorkoutPlanModel> plans) {
    final filteredPlans = plans.where((plan) {
      if (_selectedCategory != 'All' && plan.category != _selectedCategory) return false;
      if (_selectedDifficulty != 'All' && plan.difficulty != _selectedDifficulty) return false;
      return true;
    }).toList();

    if (filteredPlans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No workout plans found',
              style: AppTheme.heading3.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: AppTheme.body2.copyWith(color: AppTheme.textLight),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredPlans.length,
        itemBuilder: (context, index) {
          final plan = filteredPlans[index];
          return _buildPlanCard(plan);
        },
      ),
    );
  }

  Widget _buildPlanCard(WorkoutPlanModel plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Plan Image Placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(
                Icons.fitness_center,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: AppTheme.heading3,
                      ),
                    ),
                    if (plan.isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Coach Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        plan.coachName.split(' ').map((e) => e[0]).join(''),
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'by ${plan.coachName}',
                      style: AppTheme.body2.copyWith(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  plan.description,
                  style: AppTheme.body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Plan Details
                Row(
                  children: [
                    _buildDetailChip('${plan.duration} weeks'),
                    const SizedBox(width: 8),
                    _buildDetailChip('${plan.workoutsPerWeek}x/week'),
                    const SizedBox(width: 8),
                    _buildDetailChip(plan.difficulty),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: plan.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
                    ),
                  )).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Rating and Price
                Row(
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.warningColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.rating.toString(),
                          style: AppTheme.body2.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${plan.reviewCount})',
                          style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Price
                    if (plan.isPremium)
                      Text(
                        '\$${plan.price.toStringAsFixed(2)}',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'FREE',
                          style: AppTheme.body2.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handlePlanAction(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.isPremium ? AppTheme.primaryColor : AppTheme.successColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      plan.isPremium ? 'Buy Now' : 'Start Free',
                      style: AppTheme.button.copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTheme.caption.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handlePlanAction(WorkoutPlanModel plan) async {
    if (plan.isPremium) {
      // Show purchase dialog
      final result = await _showPurchaseDialog(plan);
      if (result == true) {
        await _purchasePlan(plan);
      }
    } else {
      // Start free plan
      _startFreePlan(plan);
    }
  }

  Future<bool?> _showPurchaseDialog(WorkoutPlanModel plan) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${plan.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Duration: ${plan.duration} weeks'),
            const SizedBox(height: 8),
            Text('Workouts per week: ${plan.workoutsPerWeek}'),
            const SizedBox(height: 16),
            Text(
              'This purchase includes:',
              style: AppTheme.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...plan.workouts.map((workout) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• ${workout.name}'),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  Future<void> _purchasePlan(WorkoutPlanModel plan) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to purchase plans')),
      );
      return;
    }

    final result = await WorkoutService.purchaseWorkoutPlan(plan.id, userId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? AppTheme.successColor : AppTheme.errorColor,
        ),
      );
    }
  }

  void _startFreePlan(WorkoutPlanModel plan) {
    // Navigate to workout plan details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${plan.name}'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    // TODO: Navigate to workout plan details screen
  }
} 