import 'package:flutter/material.dart';

//side effect will not be prioritised at the moment
class TextFormController {
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  final passwordController = TextEditingController();
  final contactController = TextEditingController();

  //shop form controller
  final shopnameController = TextEditingController();
  final companynameController = TextEditingController();
  final companycontactController = TextEditingController();
  final companyemailController = TextEditingController();
  final addressController = TextEditingController();

  //shop service controller
  final serviceNameController = TextEditingController();
  final servicePriceController = TextEditingController();
  final waitTimeController = TextEditingController();
  final serviceDescController = TextEditingController();
}
