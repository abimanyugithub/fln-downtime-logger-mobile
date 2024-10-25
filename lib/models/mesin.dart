// lib/models/mesin.dart
class Mesin {
  final String id;
  final String noMachine;
  final String categoryName;

  Mesin({
    required this.id,
    required this.noMachine,
    required this.categoryName,
  });

  factory Mesin.fromJson(Map<String, dynamic> json) {
    return Mesin(
      id: json['id'],
      noMachine: json['no_machine'],
      categoryName: json['category_machine__category'], // Ambil nama kategori dari JSON
    );
  }
}