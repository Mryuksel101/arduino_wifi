class Arrow {
  String code; // Unique identifier for the arrow
  double weight; // Weight in grams
  double balancePoint; // Center of gravity as percentage
  double leftSpine; // First spine measurement
  double rightSpine; // Second spine measurement
  // Optional fields
  DateTime createdAt;

  Arrow({
    required this.code,
    required this.weight,
    required this.balancePoint,
    required this.leftSpine,
    required this.rightSpine,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'weight': weight,
      'balancePoint': balancePoint,
      'leftSpine': leftSpine,
      'rightSpine': rightSpine,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Arrow.fromJson(Map<String, dynamic> json) {
    return Arrow(
      code: json['code'],
      weight: json['weight'],
      balancePoint: json['balancePoint'],
      leftSpine: json['leftSpine'],
      rightSpine: json['rightSpine'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Copy with new values
  Arrow copyWith({
    String? code,
    double? weight,
    double? balancePoint,
    double? spine1,
    double? spine2,
    String? notes,
  }) {
    return Arrow(
      code: code ?? this.code,
      weight: weight ?? this.weight,
      balancePoint: balancePoint ?? this.balancePoint,
      leftSpine: spine1 ?? leftSpine,
      rightSpine: spine2 ?? rightSpine,
      createdAt: createdAt,
    );
  }
}
