import 'package:drivedoctor/bloc/routes/route.dart';
import 'package:drivedoctor/bloc/services/shopservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ShopResgisterPage extends StatefulWidget {
  const ShopResgisterPage({super.key});

  @override
  State<ShopResgisterPage> createState() => _ShopResgisterPageState();
}

class _ShopResgisterPageState extends State<ShopResgisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _shopname = '';
  String _companyname = '';
  int _companytelno = 0;
  String _address = '';

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      final currentUser = FirebaseAuth.instance.currentUser;

      try {
        await createShop(
          shopname: _shopname,
          companyname: _companyname,
          companycontact: _companytelno,
          address: _address,
          ownerId: currentUser!.uid,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, profile);
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text('Shop Registration'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      SizedBox(height: 6),
                    ],
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
                            labelText: ' Shop Name',
                            labelStyle: TextStyle(color: Colors.blue.shade800)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Shop name';
                          }
                          return null;
                        },
                        onSaved: (value) => _shopname = value!,
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
                            labelText: ' Company Name',
                            labelStyle: TextStyle(color: Colors.blue.shade800)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                        onSaved: (value) => _companyname = value!,
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
                            labelText: ' Contact No.',
                            labelStyle: TextStyle(color: Colors.blue.shade800)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter shop contact number';
                          }
                          return null;
                        },
                        onSaved: (value) => _companytelno = int.parse(value!),
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
                            labelText: ' Address',
                            labelStyle: TextStyle(color: Colors.blue.shade800)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter store address';
                          }
                          return null;
                        },
                        onSaved: (value) => _address = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
