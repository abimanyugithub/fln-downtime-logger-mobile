import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '../models/mesin.dart';
import '../services/api_service.dart';
import 'machine_detail.dart';

// stream methode
/* class MachineList extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mesin>>(
      stream: apiService.getmachines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No active machines available'));
        }

        final machines = snapshot.data!;
        /* return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: machines.map((machine) {
              return MachineListTile(machine: machine);
            }),
          ).toList(),
        ); */
        return ListView.separated(
          itemCount: machines.length,
          itemBuilder: (context, index) {
            return MachineListTile(machine: machines[index]);
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
} */


// methode future
class MachineList extends StatefulWidget {
  @override
  _MachineListState createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
  final ApiService apiService = ApiService();
  late Future<List<Mesin>> _machinesFuture;

  @override
  void initState() {
    super.initState();
    _machinesFuture = apiService.getMachines();
  }

  Future<void> _refreshMachines() async {
    setState(() {
      _machinesFuture = apiService.getMachines(); // Update future
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshMachines,
      child: FutureBuilder<List<Mesin>>(
        future: _machinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No active machines available'));
          }

          /* final machines = snapshot.data!;
          return ListView.separated(
            itemCount: machines.length,
            itemBuilder: (context, index) {
              return MachineListCard(machine: machines[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
          ); */
          final machines = snapshot.data!;
          return ListView.builder(
            itemCount: machines.length,
            itemBuilder: (context, index) {
              return MachineListCard(machine: machines[index]);
            },
          );
        },
      ),
    );
  }
}

class MachineListCard extends StatelessWidget {
  final Mesin machine;

  const MachineListCard({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors based on machine status
    Color tileColor;
    Color iconColor;

    switch (machine.status) {
      case 'ready':
        tileColor = Colors.green.withOpacity(0.1);
        iconColor = Colors.green;
        break;
      case 'maintain':
      case 'pending':
        tileColor = Colors.orange.withOpacity(0.1);
        iconColor = Colors.orange;
        break;
      default:
        tileColor = Colors.grey.withOpacity(0.1);
        iconColor = Colors.grey;
    }

    return Card(
      color: tileColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.factory, size: 48, color: iconColor),
        title: Text(
          machine.noMachine,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                machine.categoryName ?? "No Category",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Status: ${machine.status ?? "No Status"}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onTap: () {
          // Navigate to detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MachineDetailPage(
                idMesin: machine.id,
              ),
            ),
          ).then((_) {
            // Set orientation back to portrait after returning
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          });
        },
      ),
    );
  }
}
