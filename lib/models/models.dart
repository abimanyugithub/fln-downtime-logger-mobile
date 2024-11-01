// Peran
class Peran {
  final String roleID; // ID Peran
  final String roleName; // Nama Peran

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

// DowntimeRole
class DowntimePeran {
  final int downtimeRoleID; // ID Downtime Role
  final String downtimeRoleName; // Name of the downtime role
  final String downtimeRoleStatus;
  final String downtimeMesinID;
  final int downtimeRoleAttempt;

  DowntimePeran({
    required this.downtimeRoleID,
    required this.downtimeRoleName,
    required this.downtimeRoleStatus,
    required this.downtimeMesinID,
    required this.downtimeRoleAttempt
  });

  factory DowntimePeran.fromJson(Map<String, dynamic> json) {
    return DowntimePeran(
      downtimeRoleID: json['id'],
      downtimeMesinID: json['downtime'], // downtime mesin id
      downtimeRoleName: json['nama_peran'],
      downtimeRoleStatus: json['status'],// Sesuaikan dengan kunci JSON
      downtimeRoleAttempt: json['attempt']
    );
  }
}

// DowntimeMesin
/*class DowntimeMesin {
  final String downtimeMesinID; // ID Downtime Mesin
  final List<DowntimePeran> roles; // List Downtime Role

  DowntimeMesin({
    required this.downtimeMesinID,
    required this.roles,
  });

  factory DowntimeMesin.fromJson(Map<String, dynamic> json) {
    var roleList = json['peran'] as List? ?? [];
    List<DowntimePeran> roleItems = roleList.map((i) => DowntimePeran.fromJson(i)).toList();

    return DowntimeMesin(
      downtimeMesinID: json['id'],
      roles: roleItems,
    );
  }
}*/

class Mesin {
  final String id;
  final String noMachine;
  final String categoryName;
  final String status;
  final List<Peran> roles; // List of roles
  // final List<DowntimeMesin> downtimeMachines; // List of downtime machines
  final List<DowntimePeran> downtimePeran; // List of downtime machines

  Mesin({
    required this.id,
    required this.noMachine,
    required this.categoryName,
    required this.status,
    required this.roles,
    // required this.downtimeMachines,
    required this.downtimePeran,
  });

  factory Mesin.fromJson(Map<String, dynamic> json) {
    var peranList = json['peran'] as List? ?? []; // 'peran' variabel dari serializers.py
    List<Peran> peranItems = peranList.map((i) => Peran.fromJson(i)).toList();

    // var downtimeMesinList = json['downtime_mesin'] as List? ?? []; // 'downtime_mesin' variabel dari serializers.py
    // List<DowntimeMesin> downtimeMachineItems = downtimeMesinList.map((i) => DowntimeMesin.fromJson(i)).toList();

    var downtimePeranList = json['downtime_peran'] as List? ?? []; // 'downtime_peran' variabel dari serializers.py
    List<DowntimePeran> downtimeRoleItems = downtimePeranList.map((i) => DowntimePeran.fromJson(i)).toList();

    return Mesin(
      id: json['id'],
      noMachine: json['no_machine'],
      categoryName: json['nama_kategori'],
      status: json['status'],
      roles: peranItems,
      // downtimeMachines: downtimeMachineItems,
      downtimePeran: downtimeRoleItems,
    );
  }
}
