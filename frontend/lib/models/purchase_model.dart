class PurchaseModel {
  final String id;
  final String userId;
  final String itemId; // workout plan id or coach id
  final String itemType; // 'workout_plan' or 'coach'
  final String itemName;
  final double amount;
  final String currency;
  final String status; // pending, completed, failed, refunded
  final String? paymentMethod;
  final String? transactionId;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final Map<String, dynamic>? metadata;

  PurchaseModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.itemName,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentMethod,
    this.transactionId,
    required this.purchaseDate,
    this.expiryDate,
    this.metadata,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json['_id'] ?? json['id'],
        userId: json['userId'],
        itemId: json['itemId'],
        itemType: json['itemType'],
        itemName: json['itemName'],
        amount: json['amount']?.toDouble() ?? 0.0,
        currency: json['currency'],
        status: json['status'],
        paymentMethod: json['paymentMethod'],
        transactionId: json['transactionId'],
        purchaseDate: DateTime.parse(json['purchaseDate']),
        expiryDate: json['expiryDate'] != null 
            ? DateTime.parse(json['expiryDate']) 
            : null,
        metadata: json['metadata'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'itemId': itemId,
        'itemType': itemType,
        'itemName': itemName,
        'amount': amount,
        'currency': currency,
        'status': status,
        'paymentMethod': paymentMethod,
        'transactionId': transactionId,
        'purchaseDate': purchaseDate.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'metadata': metadata,
      };
}

class CoachBookingModel {
  final String id;
  final String userId;
  final String coachId;
  final String coachName;
  final String? coachImage;
  final String bookingType; // 'single_session', 'monthly', 'quarterly', 'yearly'
  final int sessions; // number of sessions included
  final double pricePerSession;
  final double totalAmount;
  final String currency;
  final String status; // pending, confirmed, completed, cancelled
  final DateTime bookingDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SessionModel> sessionsList;
  final String? notes;

  CoachBookingModel({
    required this.id,
    required this.userId,
    required this.coachId,
    required this.coachName,
    this.coachImage,
    required this.bookingType,
    required this.sessions,
    required this.pricePerSession,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.bookingDate,
    this.startDate,
    this.endDate,
    required this.sessionsList,
    this.notes,
  });

  factory CoachBookingModel.fromJson(Map<String, dynamic> json) => CoachBookingModel(
        id: json['_id'] ?? json['id'],
        userId: json['userId'],
        coachId: json['coachId'],
        coachName: json['coachName'],
        coachImage: json['coachImage'],
        bookingType: json['bookingType'],
        sessions: json['sessions'],
        pricePerSession: json['pricePerSession']?.toDouble() ?? 0.0,
        totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
        currency: json['currency'],
        status: json['status'],
        bookingDate: DateTime.parse(json['bookingDate']),
        startDate: json['startDate'] != null 
            ? DateTime.parse(json['startDate']) 
            : null,
        endDate: json['endDate'] != null 
            ? DateTime.parse(json['endDate']) 
            : null,
        sessionsList: (json['sessionsList'] as List)
            .map((session) => SessionModel.fromJson(session))
            .toList(),
        notes: json['notes'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'coachId': coachId,
        'coachName': coachName,
        'coachImage': coachImage,
        'bookingType': bookingType,
        'sessions': sessions,
        'pricePerSession': pricePerSession,
        'totalAmount': totalAmount,
        'currency': currency,
        'status': status,
        'bookingDate': bookingDate.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'sessionsList': sessionsList.map((session) => session.toJson()).toList(),
        'notes': notes,
      };
}

class SessionModel {
  final String id;
  final DateTime scheduledDate;
  final int duration; // in minutes
  final String status; // scheduled, completed, cancelled, no_show
  final String? notes;
  final String? feedback;
  final double? rating;

  SessionModel({
    required this.id,
    required this.scheduledDate,
    required this.duration,
    required this.status,
    this.notes,
    this.feedback,
    this.rating,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
        id: json['_id'] ?? json['id'],
        scheduledDate: DateTime.parse(json['scheduledDate']),
        duration: json['duration'],
        status: json['status'],
        notes: json['notes'],
        feedback: json['feedback'],
        rating: json['rating']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'scheduledDate': scheduledDate.toIso8601String(),
        'duration': duration,
        'status': status,
        'notes': notes,
        'feedback': feedback,
        'rating': rating,
      };
}

class SubscriptionModel {
  final String id;
  final String userId;
  final String planType; // 'basic', 'premium', 'coach'
  final String planName;
  final double monthlyPrice;
  final String currency;
  final String status; // active, cancelled, expired, pending
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final String? paymentMethod;
  final bool autoRenew;
  final List<String> features; // list of features included

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planType,
    required this.planName,
    required this.monthlyPrice,
    required this.currency,
    required this.status,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    this.paymentMethod,
    required this.autoRenew,
    required this.features,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        id: json['_id'] ?? json['id'],
        userId: json['userId'],
        planType: json['planType'],
        planName: json['planName'],
        monthlyPrice: json['monthlyPrice']?.toDouble() ?? 0.0,
        currency: json['currency'],
        status: json['status'],
        startDate: DateTime.parse(json['startDate']),
        endDate: json['endDate'] != null 
            ? DateTime.parse(json['endDate']) 
            : null,
        nextBillingDate: json['nextBillingDate'] != null 
            ? DateTime.parse(json['nextBillingDate']) 
            : null,
        paymentMethod: json['paymentMethod'],
        autoRenew: json['autoRenew'] ?? true,
        features: List<String>.from(json['features']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'planType': planType,
        'planName': planName,
        'monthlyPrice': monthlyPrice,
        'currency': currency,
        'status': status,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'nextBillingDate': nextBillingDate?.toIso8601String(),
        'paymentMethod': paymentMethod,
        'autoRenew': autoRenew,
        'features': features,
      };
} 