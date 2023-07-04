import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../bloc/models/user.dart';
import '../../widgets/admin_side_menu.dart';

class SubscriptionManagementPage extends StatefulWidget {
  @override
  _SubscriptionManagementPageState createState() =>
      _SubscriptionManagementPageState();
}

class _SubscriptionManagementPageState
    extends State<SubscriptionManagementPage> {
  List<UserData> users = [];
  List<UserData> filteredUsers = [];
  String filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      users = querySnapshot.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
      filteredUsers = users; // Initially, display all users
    });
  }

  void filterUsers(String status) {
    setState(() {
      filterStatus = status;
      if (status == 'all') {
        filteredUsers = users;
      } else {
        // Filter the users based on the selected status
        filteredUsers = users.where((user) => user.status == status).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Management'),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF303030),
        ),
        child: const AdminSideMenu(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFilterButton('all', 'All'),
                const SizedBox(width: 16),
                buildFilterButton('premium', 'Premium'),
                const SizedBox(width: 16),
                buildFilterButton('regular', 'Regular'),
              ],
            ),
          ),
          Expanded(
            child: users.isNotEmpty
                ? buildDataTable()
                : const CircularProgressIndicator(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF303030),
    );
  }

  Widget buildFilterButton(String status, String label) {
    final bool isSelected = filterStatus == status;

    return ElevatedButton(
      onPressed: () => filterUsers(status),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : null,
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.blue[900]!,
        ),
        headingTextStyle: const TextStyle(color: Colors.white),
        dataRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.white,
        ),
        dataTextStyle: const TextStyle(color: Colors.black),
        columns: const [
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('Status')),
        ],
        rows: filteredUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user.username)),
              DataCell(Text(user.status)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
