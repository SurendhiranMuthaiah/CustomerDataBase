import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_database/customer_details_model.dart';
import 'package:flutter_project_database/customer_list_screen.dart';
import 'package:flutter_project_database/database_helper.dart';
import 'package:flutter_project_database/main.dart';

class OptimizeCustomerFormScreen extends StatefulWidget {
  const OptimizeCustomerFormScreen({super.key});

  @override
  State<OptimizeCustomerFormScreen> createState() =>
      _OptimizeCustomerFormScreenState();
}

class _OptimizeCustomerFormScreenState
    extends State<OptimizeCustomerFormScreen> {
  var _CustomerNameController = TextEditingController();
  var _CustomerMobileNoController = TextEditingController();
  var _CustomerDesignationController = TextEditingController();
  var _CustomerEmailIdController = TextEditingController();

  bool firstTimeFlag = false;
  int _selectedId = 0;

  String buttonText = 'save';

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      final CustomerDetails =
          ModalRoute.of(context)!.settings.arguments;

      if (CustomerDetails == null) {
        print('-------->FAB: Insert/Save: ');
      } else {
        print('------>ListView: Received Data: Edit/Delete');

        CustomerDetails as CustomerDetailsModel;

        print('---------->Received Data');
        print(CustomerDetails.id);
        print(CustomerDetails.name);
        print(CustomerDetails.contact_no);
        print(CustomerDetails.designation);
        print(CustomerDetails.email);

        _selectedId = CustomerDetails.id!;
        buttonText = 'Update';

        _CustomerNameController.text = CustomerDetails.name;
        _CustomerMobileNoController.text = CustomerDetails.contact_no;
        _CustomerDesignationController.text = CustomerDetails.designation;
        _CustomerEmailIdController.text = CustomerDetails.email;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Customer Details Form',
        ),
        actions: _selectedId != 0
            ? [
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text('Delete')),
                  ],
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      _deleteFormDialog(context);
                    }
                  },
                ),
              ]
            : null,
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
                    print('-------------> Button Clicked');
                    if(_selectedId == 0){
                      print('-------->save');
                      _save();
                    } else{
                      print('-----------> Update');
                      _update();
                    }
                  },
                  child: Text(buttonText),
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
                onPressed: () async {
                  print('----------->Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              ),
            ],
            title: const Text('Are you sure you want to delete this ?'),
          );
        });
  }



  void _save() async {
    print('--------> _save');

    print('-----------> name : ${_CustomerNameController.text}');
    print('-----------> contact_no : ${_CustomerMobileNoController.text}');
    print('-----------> designation : ${_CustomerDesignationController.text}');
    print('-----------> email : ${_CustomerEmailIdController.text}');

    Map<String, dynamic> row = {
      DataBaseHelper.colCustomerName: _CustomerNameController.text,
      DataBaseHelper.colMobileNo: _CustomerMobileNoController.text,
      DataBaseHelper.colDesignation: _CustomerDesignationController.text,
      DataBaseHelper.colemail: _CustomerEmailIdController.text,
    };

    final result = await dbHelper.insertCustomerDetails(
        row, DataBaseHelper.customerDetailsTable);
    debugPrint('-----------> Insert Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'saved');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CustomerListScreen()));
    });
  }

  void _update() async {
    print('-------->id: $_selectedId.');
    print('--------->name: ${_CustomerNameController.text}');
    print('----------> contact_no${_CustomerMobileNoController.text}');
    print(
        '---------->designation: ${_CustomerDesignationController.text}');
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
    debugPrint('----------> Update Row Id:$result');

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
    print('----------> _delete');

    final result = await dbHelper.deleteCustomerDetails(
        _selectedId, DataBaseHelper.customerDetailsTable);

    debugPrint('----------> _delete Row Id: $result');

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
