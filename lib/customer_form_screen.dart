import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_database/customer_list_screen.dart';
import 'package:flutter_project_database/database_helper.dart';
import 'package:flutter_project_database/main.dart';

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({super.key});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  var _CustomerNameController = TextEditingController();
  var _CustomerMobileNoController = TextEditingController();
  var _CustomerDesignationController = TextEditingController();
  var _CustomerEmailIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Details Form',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: _CustomerNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Customer Name',
                    hintText: 'Enter Customer Name',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _CustomerMobileNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Customer MobileNo',
                      hintText: 'Enter MobileNo'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _CustomerDesignationController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Customer Designation',
                      hintText: 'Enter Designation'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _CustomerEmailIdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Customer EmailId',
                    hintText: 'Enter EmailId',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('-------------> save button clicked');
                    _save();
                  },
                  child: Text('save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('---------------> name : ${_CustomerNameController.text}');
    print(
        '---------------> contact_no: ${_CustomerMobileNoController.text}');
    print(
        '---------------> designation : ${_CustomerDesignationController.text}');

    print('---------------> email : ${_CustomerEmailIdController.text}');

    Map<String, dynamic> row = {
      DataBaseHelper.colCustomerName: _CustomerNameController.text,
      DataBaseHelper.colMobileNo: _CustomerMobileNoController.text,
      DataBaseHelper.colDesignation: _CustomerDesignationController.text,
      DataBaseHelper.colemail: _CustomerEmailIdController.text,
    };

    final result = await dbHelper.insertCustomerDetails(
        row, DataBaseHelper.customerDetailsTable);
    debugPrint('---------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'save');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CustomerListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
