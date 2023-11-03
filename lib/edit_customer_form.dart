import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_database/customer_details_model.dart';
import 'package:flutter_project_database/customer_list_screen.dart';
import 'package:flutter_project_database/database_helper.dart';
import 'package:flutter_project_database/main.dart';

class EditCustomerFormScreen extends StatefulWidget {
  const EditCustomerFormScreen({super.key});

  @override
  State<EditCustomerFormScreen> createState() => _EditCustomerFormScreenState();
}

class _EditCustomerFormScreenState extends State<EditCustomerFormScreen> {
  var _CustomerNameController = TextEditingController();
  var _CustomerMobileNoController = TextEditingController();
  var _CustomerDesignationController = TextEditingController();
  var _CustomerEmailIdController = TextEditingController();

  bool firstTimeFlag=false;
  int _selectedId=0;

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag = false) {
      print('---------->once execute');

      firstTimeFlag = true;

      final CustomerDetails =
          ModalRoute.of(context)!.settings.arguments as CustomerDetailsModel;

      print('---------->Received Data');
      print(CustomerDetails.id);
      print(CustomerDetails.name);
      print(CustomerDetails.contact_no);
      print(CustomerDetails.designation);
      print(CustomerDetails.email);

      _selectedId = CustomerDetails.id!;

      _CustomerNameController.text = CustomerDetails.name;
      _CustomerMobileNoController.text = CustomerDetails.contact_no;
      _CustomerDesignationController.text = CustomerDetails.designation;
      _CustomerEmailIdController.text = CustomerDetails.email;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Customer Details Form',
        ),
        actions: [
          PopupMenuButton<int>(
              itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text('Delete')),
                  ],
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  print('Delete option clicked');
                  _deleteFormDialog(context);
                }
              },
              ),
        ],
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
                      hintText: 'Enter Customer Name'),
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
                      labelText: 'Customer Mobile',
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
                    hintText: 'Enter Designation',
                  ),
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
                    print('-------------> Update Button Clicked');
                    _update();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('----------->Cancel Button clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async{
                  print('----------->Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        }
        );
  }


  void _update() async {
    print('------------> _Updated');

    print('-------->id : $_selectedId');
    print('--------->name: ${_CustomerNameController.text}');
    print('---------->contact_no ${_CustomerMobileNoController.text}');
    print('---------->designation: ${_CustomerDesignationController.text}');
    print('--------->email: ${_CustomerEmailIdController.text}');

    Map<String, dynamic> row = {
      DataBaseHelper.colId: _selectedId,
      DataBaseHelper.colCustomerName: _CustomerNameController.text,
      DataBaseHelper.colMobileNo: _CustomerMobileNoController.text,
      DataBaseHelper.colDesignation: _CustomerDesignationController.text,
      DataBaseHelper.colemail: _CustomerEmailIdController.text,
    };

    final result = await dbHelper.updateCustomerDetails(
        row, DataBaseHelper.customerDetailsTable);
    debugPrint('----------> Updated Row Id:$result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Update');
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

  void _delete() async {
    print('----------> _Delete');

    final result = await dbHelper.deleteCustomerDetails(
        _selectedId, DataBaseHelper.customerDetailsTable);

    debugPrint('----------> _Delete: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Delete.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CustomerListScreen()));
    });
  }
}
