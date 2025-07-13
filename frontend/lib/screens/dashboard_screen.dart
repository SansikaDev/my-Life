import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'workout_plans_screen.dart';
import 'health_sync_screen.dart';
import 'workout_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Get current user from auth service
  UserModel? get _user => AuthService.currentUser;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeTab(),
          _buildWorkoutsTab(),
          _buildMealsTab(),
          _buildCoachesTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                _buildNavItem(1, Icons.fitness_center_outlined, Icons.fitness_center, 'Workouts'),
                _buildNavItem(2, Icons.restaurant_outlined, Icons.restaurant, 'Meals'),
                _buildNavItem(3, Icons.person_outline, Icons.person, 'Coaches'),
                _buildNavItem(4, Icons.account_circle_outlined, Icons.account_circle, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
                         flexibleSpace: FlexibleSpaceBar(
               title: Text(
                 'Welcome back, ${_user?.name.split(' ').first ?? 'User'}!',
                 style: AppTheme.heading3.copyWith(color: Colors.white),
               ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),
                         actions: [
               IconButton(
                 icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                 onPressed: () {},
               ),
               PopupMenuButton<String>(
                 icon: const Icon(Icons.more_vert, color: Colors.white),
                 onSelected: (value) async {
                   if (value == 'logout') {
                     await AuthService.logout();
                     if (mounted) {
                       Navigator.of(context).pushReplacementNamed('/login');
                     }
                   }
                 },
                 itemBuilder: (context) => [
                   const PopupMenuItem(
                     value: 'logout',
                     child: Row(
                       children: [
                         Icon(Icons.logout, color: Colors.red),
                         SizedBox(width: 8),
                         Text('Logout'),
                       ],
                     ),
                   ),
                 ],
               ),
             ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Cards
                _buildStatsSection(),
                const SizedBox(height: 24),

                // Today's Workout
                _buildTodayWorkout(),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 24),

                // Recent Activities
                _buildRecentActivities(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Steps',
            '8,432',
            '6,000',
            Icons.directions_walk,
            AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Calories',
            '1,234',
            '2,000',
            Icons.local_fire_department,
            AppTheme.warningColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Workouts',
            '3',
            '5',
            Icons.fitness_center,
            AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String current, String target, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            current,
            style: AppTheme.heading2.copyWith(fontSize: 20),
          ),
          Text(
            'of $target',
            style: AppTheme.caption.copyWith(color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWorkout() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                "Today's Workout",
                style: AppTheme.heading3.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Upper Body Strength',
            style: AppTheme.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '6 exercises • 45 minutes',
            style: AppTheme.body2.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start Workout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Log Workout',
                Icons.add_circle_outline,
                AppTheme.primaryColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutTrackingScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Log Meal',
                Icons.restaurant_outlined,
                AppTheme.successColor,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Book Coach',
                Icons.person_add_outlined,
                AppTheme.warningColor,
                () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Health Sync',
                Icons.health_and_safety,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthSyncScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Progress',
                Icons.trending_up,
                Colors.purple,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Settings',
                Icons.settings,
                Colors.grey,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final activities = [
              {'title': 'Morning Run', 'time': '2 hours ago', 'duration': '30 min'},
              {'title': 'Strength Training', 'time': 'Yesterday', 'duration': '45 min'},
              {'title': 'Yoga Session', 'time': '2 days ago', 'duration': '20 min'},
            ];
            final activity = activities[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title']!,
                          style: AppTheme.body1.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${activity['duration']} • ${activity['time']}',
                          style: AppTheme.caption.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutsTab() {
    return const WorkoutPlansScreen();
  }

  Widget _buildMealsTab() {
    return const Center(child: Text('Meals Tab'));
  }

  Widget _buildCoachesTab() {
    return const Center(child: Text('Coaches Tab'));
  }

  Widget _buildProfileTab() {
    return const Center(child: Text('Profile Tab'));
  }
}