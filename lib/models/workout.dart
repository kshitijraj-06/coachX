class Workout {
  final int id;
  final String name;
  final String description;
  final double caloriesPerMinute;
  final String type;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.caloriesPerMinute,
    required this.type,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      caloriesPerMinute: json['caloriesPerMinute'].toDouble(),
      type: json['type'],
    );
  }
}
