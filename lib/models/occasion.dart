class Occasion {
  final int id;
  final String name;
  final String date;

  Occasion({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Occasion.fromJson(Map<String, dynamic> json) {
    return Occasion(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'date': date};
  }
}

