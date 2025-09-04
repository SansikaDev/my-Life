import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/meal_plan_model.dart';
import '../services/meal_service.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  
  final List<String> _categories = [
    'All',
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Cardio',
    'Vegetarian',
    'Keto',
  ];

  @override
  void initState() {
    super.initState();
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
    _animationController.dispose();
    super.dispose();
  }

  List<MealPlanModel> get _filteredMealPlans {
    return MealService.mealPlans.where((mealPlan) {
      // Category filter
      if (_selectedCategory != 'All' && mealPlan.category != _selectedCategory) {
        return false;
      }
      
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!mealPlan.name.toLowerCase().contains(query) &&
            !mealPlan.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Favorites filter
      if (_showFavoritesOnly && !mealPlan.isFavorite) {
        return false;
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Search and Filters
              _buildSearchAndFilters(),
              
              // Meal Plans List
              Expanded(
                child: _buildMealPlansList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meal Plans',
                  style: AppTheme.heading1.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover personalized nutrition plans',
                  style: AppTheme.body2.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add to favorites or settings
            },
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search meal plans...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        category,
                        style: AppTheme.caption.copyWith(
                          color: isSelected ? AppTheme.primaryColor : Colors.white,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Favorites Toggle
          Row(
            children: [
              Switch(
                value: _showFavoritesOnly,
                onChanged: (value) {
                  setState(() {
                    _showFavoritesOnly = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(width: 8),
              Text(
                'Show favorites only',
                style: AppTheme.body2.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlansList() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _filteredMealPlans.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _filteredMealPlans.length,
                  itemBuilder: (context, index) {
                    final mealPlan = _filteredMealPlans[index];
                    return _buildMealPlanCard(mealPlan, index);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No meal plans found',
            style: AppTheme.heading3.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: AppTheme.body2.copyWith(color: AppTheme.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanCard(MealPlanModel mealPlan, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealPlanDetailScreen(mealPlan: mealPlan),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image and favorite button
                Row(
                  children: [
                    // Meal plan image or placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: _getCategoryGradient(mealPlan.category),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getCategoryIcon(mealPlan.category),
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealPlan.name,
                            style: AppTheme.heading3,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mealPlan.description,
                            style: AppTheme.body2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    IconButton(
                      onPressed: () {
                        // TODO: Toggle favorite
                      },
                      icon: Icon(
                        mealPlan.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: mealPlan.isFavorite ? AppTheme.errorColor : AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Nutrition info
                Row(
                  children: [
                    _buildNutritionChip('${mealPlan.totalCalories} kcal', Icons.local_fire_department),
                    const SizedBox(width: 12),
                    _buildNutritionChip('${mealPlan.totalProtein}g protein', Icons.fitness_center),
                    const SizedBox(width: 12),
                    _buildNutritionChip('${mealPlan.duration} days', Icons.calendar_today),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Category and difficulty
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(mealPlan.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mealPlan.category,
                        style: AppTheme.caption.copyWith(
                          color: _getCategoryColor(mealPlan.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(mealPlan.difficulty).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mealPlan.difficulty,
                        style: AppTheme.caption.copyWith(
                          color: _getDifficultyColor(mealPlan.difficulty),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChip(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTheme.caption.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LinearGradient _getCategoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'weight loss':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        );
      case 'muscle gain':
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        );
      case 'cardio':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
      default:
        return const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'weight loss':
        return Icons.trending_down;
      case 'muscle gain':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.favorite;
      default:
        return Icons.restaurant_menu;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'weight loss':
        return AppTheme.successColor;
      case 'muscle gain':
        return AppTheme.warningColor;
      case 'cardio':
        return AppTheme.errorColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'hard':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class MealPlanDetailScreen extends StatelessWidget {
  final MealPlanModel mealPlan;

  const MealPlanDetailScreen({
    super.key,
    required this.mealPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal plan info
                        _buildMealPlanInfo(),
                        
                        const SizedBox(height: 24),
                        
                        // Nutrition breakdown
                        _buildNutritionBreakdown(),
                        
                        const SizedBox(height: 24),
                        
                        // Meals list
                        _buildMealsList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              mealPlan.name,
              style: AppTheme.heading2.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Toggle favorite
            },
            icon: Icon(
              mealPlan.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealPlan.description,
            style: AppTheme.body1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip('${mealPlan.duration} days', Icons.calendar_today),
              const SizedBox(width: 12),
              _buildInfoChip(mealPlan.difficulty, Icons.speed),
              const SizedBox(width: 12),
              _buildInfoChip(mealPlan.category, Icons.category),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Breakdown',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNutritionCard(
                'Calories',
                '${mealPlan.totalCalories}',
                'kcal',
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutritionCard(
                'Protein',
                '${mealPlan.totalProtein}',
                'g',
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutritionCard(
                'Carbs',
                '${mealPlan.totalCarbs}',
                'g',
                AppTheme.warningColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNutritionCard(
                'Fat',
                '${mealPlan.totalFat}',
                'g',
                AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.heading2.copyWith(color: color),
          ),
          Text(
            unit,
            style: AppTheme.caption.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 16),
        ...mealPlan.meals.map((meal) => _buildMealCard(meal)).toList(),
      ],
    );
  }

  Widget _buildMealCard(MealModel meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getMealTypeIcon(meal.type),
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: AppTheme.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      meal.type,
                      style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${meal.calories} kcal',
                style: AppTheme.body2.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          if (meal.foodItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Ingredients:',
              style: AppTheme.caption.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: meal.foodItems.map((food) => _buildFoodChip(food)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFoodChip(FoodItemModel food) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${food.name} (${food.quantity}${food.unit})',
        style: AppTheme.caption.copyWith(
          color: AppTheme.textSecondary,
          fontSize: 10,
        ),
      ),
    );
  }

  IconData _getMealTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.restaurant;
      case 'dinner':
        return Icons.nightlight;
      case 'snack':
        return Icons.coffee;
      default:
        return Icons.restaurant_menu;
    }
  }
}
