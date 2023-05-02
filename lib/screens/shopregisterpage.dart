import 'package:flutter/material.dart';

class ShopResgisterPage extends StatefulWidget {
  const ShopResgisterPage({super.key});

  @override
  State<ShopResgisterPage> createState() => _ShopResgisterPageState();
}

class _ShopResgisterPageState extends State<ShopResgisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _shopname = '';
  String _ownername = '';
  String _companyname = '';
  String _companytelno = '';
  String _password = '';
  String _confirmPassword = '';
  String _address = '';

  void _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Registration Page'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/store_icon.png'),
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
                          labelText: ' Full Name',
                          labelStyle: TextStyle(color: Colors.blue.shade800)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Your name';
                        }
                        return null;
                      },
                      onSaved: (value) => _ownername = value!,
                    ),
                  ),
                  SizedBox(height: 5),
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
                  SizedBox(height: 5),
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
                  SizedBox(height: 5),
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
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                      onSaved: (value) => _companytelno = value!,
                    ),
                  ),
                  SizedBox(height: 5),
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
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter store address';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                  ),
                  SizedBox(height: 5),
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
                          labelText: ' Password',
                          labelStyle: TextStyle(color: Colors.blue.shade800)),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onSaved: (value) => _confirmPassword = value!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
