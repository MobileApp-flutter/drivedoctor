import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedoctor/bloc/services/productservice.dart';
import 'package:drivedoctor/bloc/controller/textform.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:drivedoctor/constants/textstyle.dart';

class Productedit extends StatefulWidget {
  final String productId;

  const Productedit({Key? key, required this.productId}) : super(key: key);

  @override
  State<Productedit> createState() => _ProducteditState();
}

class _ProducteditState extends State<Productedit> {
  String? _productName;
  double? _price;
  String? _description;
  int? _stock;
  String? shopID;

  final _formKey = GlobalKey<FormState>();
  final TextFormController textform = TextFormController();

  void _editProduct() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await updateProduct(
            productId: widget.productId,
            productName: _productName,
            price: _price,
            stock: _stock,
            description: _description,
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Product Updated!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not logged in')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating product')),
        );
      }
    }
  }

  void _deleteProduct() async {
    try {
      await deleteProduct(widget.productId);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Deleted!')));
      Navigator.pop(context); // Return to the previous screen after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting Product')),
      );
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
                    labelText: "Product Name",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _productName = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.servicePriceController,
                  decoration: InputDecoration(
                    labelText: "Product Price",
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _price = double.tryParse(value) ?? 0.0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.waitTimeController,
                  decoration: InputDecoration(
                    labelText: "Stock",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    if (value != null) {
                      _stock = int.tryParse(value) ?? 0;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: textform.serviceDescController,
                  decoration: InputDecoration(
                    labelText: "Product Description",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _editProduct,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _deleteProduct, // Add the delete function here
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Use a red color for the delete button
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Delete Service',
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
