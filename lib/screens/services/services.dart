import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedoctor/bloc/controller/auth.dart';
import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/servicesservice.dart';

class Services extends StatelessWidget {
  Services({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  String _servicename = '';
  String _serviceprice = '';
  String _waittime = '';

  void _submitForm(BuildContext context) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        await createService(
          servicename: _servicename,
          serviceprice: _serviceprice,
          waittime: _waittime,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service Added')),
        );

        Navigator.pushReplacementNamed(context, profile);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Register'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: const [],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                          labelStyle: TextStyle(color: Colors.blue.shade800),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the service name';
                          }
                          return null;
                        },
                        onSaved: (value) => _servicename = value!,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Starting Price',
                          labelStyle: TextStyle(color: Colors.blue.shade800),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the starting price';
                          }
                          return null;
                        },
                        onSaved: (value) => _serviceprice = value!,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Expected Waiting Time',
                          labelStyle: TextStyle(color: Colors.blue.shade800),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the expected waiting time';
                          }
                          return null;
                        },
                        onSaved: (value) => _waittime = value!,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  ),
                  child: const Text('Add Service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
