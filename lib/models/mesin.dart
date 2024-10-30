// lib/models/mesin.dart
class Peran {
  final String roleID; // Unique identifier for the role
  final String roleName; // Name of the role

  Peran({
    required this.roleID,
    required this.roleName,
  });

  factory Peran.fromJson(Map<String, dynamic> json) {
    return Peran(
      roleID: json['id'],
      roleName: json['role_name'],
    );
  }
}

class Mesin {
  final String id;
  final String noMachine;
  final String categoryName;
  final String status;
  final List<Peran> roleName;


  Mesin({
    required this.id,
    required this.noMachine,
    required this.categoryName,
    required this.status,
    required this.roleName,
  });

  /* factory Mesin.fromJson(Map<String, dynamic> json) {
    return Mesin(
      id: json['id'],
      noMachine: json['no_machine'],
      categoryName: json['category_machine__category'], // Ambil nama kategori dari JSON
      status: json['status']
    );
  } */

  factory Mesin.fromJson(Map<String, dynamic> json) {
    var peranList = json['peran'] as List;
    List<Peran> peranItems = peranList.map((i) => Peran.fromJson(i)).toList();

    return Mesin(
      id: json['id'],
      noMachine: json['no_machine'],
      categoryName: json['category_machine__category'],
      status: json['status'],
      roleName: peranItems,
    );
  }
}