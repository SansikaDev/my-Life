class MealPlanModel {
  final String id;
  final String name;
  final String description;
  final String category; // weight loss, muscle gain, maintenance, etc.
  final int totalCalories;
  final int totalProtein; // in grams
  final int totalCarbs; // in grams
  final int totalFat; // in grams
  final List<MealModel> meals;
  final String difficulty; // easy, medium, hard
  final int duration; // in days
  final String? imageUrl;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  MealPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.meals,
    required this.difficulty,
    required this.duration,
    this.imageUrl,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) => MealPlanModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        totalCalories: json['totalCalories'],
        totalProtein: json['totalProtein'],
        totalCarbs: json['totalCarbs'],
        totalFat: json['totalFat'],
        meals: (json['meals'] as List)
            .map((meal) => MealModel.fromJson(meal))
            .toList(),
        difficulty: json['difficulty'],
        duration: json['duration'],
        imageUrl: json['imageUrl'],
        isFavorite: json['isFavorite'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'totalCalories': totalCalories,
        'totalProtein': totalProtein,
        'totalCarbs': totalCarbs,
        'totalFat': totalFat,
        'meals': meals.map((meal) => meal.toJson()).toList(),
        'difficulty': difficulty,
        'duration': duration,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class MealModel {
  final String id;
  final String name;
  final String type; // breakfast, lunch, dinner, snack
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fat; // in grams
  final List<FoodItemModel> foodItems;
  final String? instructions;
  final int? prepTime; // in minutes
  final int? cookTime; // in minutes
  final String? imageUrl;

  MealModel({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.foodItems,
    this.instructions,
    this.prepTime,
    this.cookTime,
    this.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        type: json['type'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
        foodItems: (json['foodItems'] as List)
            .map((item) => FoodItemModel.fromJson(item))
            .toList(),
        instructions: json['instructions'],
        prepTime: json['prepTime'],
        cookTime: json['cookTime'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'foodItems': foodItems.map((item) => item.toJson()).toList(),
        'instructions': instructions,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'imageUrl': imageUrl,
      };
}

class FoodItemModel {
  final String id;
  final String name;
  final double quantity; // in grams or pieces
  final String unit; // g, pieces, cups, etc.
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fat; // in grams
  final String? imageUrl;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) => FoodItemModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        quantity: json['quantity']?.toDouble() ?? 0.0,
        unit: json['unit'],
        calories: json['calories'],
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'imageUrl': imageUrl,
      };
} 