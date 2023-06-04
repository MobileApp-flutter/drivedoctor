//make sure you carry the sidemenu feature here
//manage user - not creation, only update and delete

//check createroute and route

import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/screens/admin/updateuserdialog.dart';
import 'package:drivedoctor/widgets/admin_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manageuser extends StatefulWidget {
  const Manageuser({Key? key}) : super(key: key);

  @override
  State<Manageuser> createState() => _ManageuserState();
}

class _ManageuserState extends State<Manageuser> {
  List<UserData>? users;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users = snapshot.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User'),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: const Drawer(
        child: AdminSideMenu(),
      ),
      body:
          users != null ? buildDataTable() : const CircularProgressIndicator(),
    );
  }

  Widget buildDataTable() {
    final columns = ['Username', 'Full Name', 'Contact'];

    return Center(
      child: Card(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue[900]!,
              ),
              sortAscending: isAscending,
              sortColumnIndex: sortColumnIndex,
              columns: getColumns(columns),
              rows: getRows(users!),
              dataRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              ),
              dataTextStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    final List<DataColumn> dataColumns = columns
        .map((String column) => DataColumn(
              label: Text(column),
              tooltip: column,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sortColumnIndex = columnIndex;
                  isAscending = ascending;
                  sortUsers();
                });
              },
            ))
        .toList();

    // Add two additional DataColumn for the update and delete buttons
    dataColumns.add(
      const DataColumn(
        label: Text('Action'),
      ),
    );

    return dataColumns;
  }

  List<DataRow> getRows(List<UserData> users) => users.map((UserData user) {
        final cells = [user.username, user.fullname, user.contact.toString()];
        return DataRow(
          cells: [
            ...getCells(cells),
            DataCell(
              ElevatedButton(
                onPressed: () {
                  // Handle update button press
                  showDialog(
                    context: context,
                    builder: (context) =>
                        Updateuserdialog(user: user, users: users),
                  );
                },
                child: const Text('Modify'),
              ),
            ),
          ],
        );
      }).toList();

  List<DataCell> getCells(List<String> cells) =>
      cells.map((data) => DataCell(Text(data))).toList();

  void sortUsers() {
    switch (sortColumnIndex) {
      case 0:
        users!.sort((a, b) => a.username.compareTo(b.username));
        break;
      case 1:
        users!.sort((a, b) => a.fullname.compareTo(b.fullname));
        break;
      case 2:
        users!.sort((a, b) => a.contact.compareTo(b.contact));
        break;
    }
    if (!isAscending) {
      users = users!.reversed.toList();
    }
  }
}
