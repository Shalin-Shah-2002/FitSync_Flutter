class Itemsmodel {
  final String name;
  final double calories; // Using camelCase convention

  Itemsmodel({required this.name, required this.calories});

  factory Itemsmodel.fromJson(Map<String, dynamic> json) {
    // Safely convert the Calories value to double
    var caloriesValue = json['nutrition']['Calories'];
    double parsedCalories;
    
    if (caloriesValue is int) {
      parsedCalories = caloriesValue.toDouble();
    } else if (caloriesValue is String) {
      parsedCalories = double.tryParse(caloriesValue) ?? 0.0;
    } else if (caloriesValue is double) {
      parsedCalories = caloriesValue;
    } else {
      parsedCalories = 0.0; // Default value if parsing fails
    }

    return Itemsmodel(
      name: json['name'] ?? '', // Add null safety
      calories: parsedCalories,
    );
  }
}