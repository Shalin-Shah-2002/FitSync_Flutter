class Itemsmodel {
  final String name;
  final String brand;
  final String ServingSize;
  final double calories; // Using camelCase convention
  final double fat;
  final double Carbs;
  final double Protein;

  Itemsmodel(
      {required this.name,
      required this.calories,
      required this.fat,
      required this.brand,
      required this.ServingSize,
      required this.Carbs,
      required this.Protein});

factory Itemsmodel.fromJson(Map<String, dynamic> json) {
  // Function to safely parse double values, removing 'g' if present
  double parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Default fallback
    }
  }

  return Itemsmodel(
    name: json['name'] ?? '',
    calories: parseDouble(json['nutrition']['Calories']),
    fat: parseDouble(json['nutrition']['Fat']),
    brand: json['brand'] ?? '',
    ServingSize: json['nutrition']['Serving Size'] ?? '',
    Carbs: parseDouble(json['nutrition']['Carbs']),
    Protein: parseDouble(json['nutrition']['Protein']),
  );
}


}
