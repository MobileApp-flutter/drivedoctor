import 'package:drivedoctor/bloc/models/user.dart';
import 'package:drivedoctor/bloc/services/userservice.dart';
import 'package:flutter/material.dart';

class Updateuserdialog extends StatefulWidget {
  final UserData user;
  final List<UserData> users;

  const Updateuserdialog({Key? key, required this.user, required this.users})
      : super(key: key);

  @override
  State<Updateuserdialog> createState() => _UpdateuserdialogState();
}

class _UpdateuserdialogState extends State<Updateuserdialog> {
  String? updateusername;
  String? updatefullname;
  int? updatecontact;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(
          255, 118, 204, 247), // Set the background color to white
      title: const Text('Update User', style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.user.username,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Set focused border color to black
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  updateusername = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.user.fullname,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Set focused border color to black
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  updatefullname = value;
                });
              },
            ),
            TextFormField(
              initialValue: widget.user.contact.toString(),
              decoration: const InputDecoration(
                labelText: 'Contact',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Set focused border color to black
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  updatecontact = int.tryParse(value);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none,
              ),
            ),
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Update user logic
            await adminupdateUser(
              id: widget.user.id,
              username: updateusername,
              fullname: updatefullname,
              contact: updatecontact,
            );

            // Show a successful update message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User updated successfully'),
                backgroundColor: Colors.white,
              ),
            );

            Navigator.pop(context);

            // Update the local user object with the new data
            setState(() {
              widget.user.username = updateusername!;
              widget.user.fullname = updatefullname!;
              widget.user.contact = updatecontact!;
            });
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(Colors.green),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none,
              ),
            ),
          ),
          child: const Text('Update'),
        ),
        TextButton(
          onPressed: () async {
            // Delete user logic
            await deleteUser(widget.user.id);

            // Show a successful update message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User updated successfully'),
                backgroundColor: Colors.white,
              ),
            );

            Navigator.pop(context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(Colors.red),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none,
              ),
            ),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
