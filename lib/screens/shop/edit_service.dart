import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedoctor/bloc/services/servicesservice.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:drivedoctor/constants/textstyle.dart';

class Serviceedit extends StatefulWidget {
  final String serviceId;

  const Serviceedit({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<Serviceedit> createState() => _ServiceeditState();
}

class _ServiceeditState extends State<Serviceedit> {
  String? _servicename;
  String? _serviceprice;
  String? _waittime;
  String? _servicedesc;
  String? shopID;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();

  void _editService() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await updateService(
            serviceId: widget.serviceId,
            servicename: _servicename,
            serviceprice: _serviceprice,
            waittime: _waittime,
            servicedesc: _servicedesc,
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Service Updated!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not logged in')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating service')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text("Edit Service", style: defaultText),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: textform.serviceNameController,
                  decoration: InputDecoration(
                    labelText: "Service Name",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _servicename = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.servicePriceController,
                  decoration: InputDecoration(
                    labelText: "Service Price",
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the service price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _serviceprice = value;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.waitTimeController,
                  decoration: InputDecoration(
                    labelText: "Wait Time",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _waittime = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.serviceDescController,
                  decoration: InputDecoration(
                    labelText: "Service Description",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _servicedesc = value;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _editService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Update Service',
                      style: defaultText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
