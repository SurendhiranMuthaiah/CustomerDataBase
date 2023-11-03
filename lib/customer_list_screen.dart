import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_database/customer_details_model.dart';

import 'package:flutter_project_database/database_helper.dart';

import 'package:flutter_project_database/main.dart';
import 'package:flutter_project_database/optimize_customer_form.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {

  late List<CustomerDetailsModel> _CustomerDetailsList;

  @override
  void initState() {
    super.initState();
    getAllCustomerDetails();
  }

  getAllCustomerDetails() async {
    _CustomerDetailsList = <CustomerDetailsModel>[];
    var CustomerDetailsRecords =
    await dbHelper.queryAllRows(DataBaseHelper.customerDetailsTable);

    CustomerDetailsRecords.forEach((CustomerDetails) {
      setState(() {

        print(CustomerDetails['_id']);
        print(CustomerDetails['_name']);
        print(CustomerDetails['_contact_no']);
        print(CustomerDetails['_designation']);
        print(CustomerDetails['_email']);

        var customerDetailsModel =
        CustomerDetailsModel(
          CustomerDetails['_id'],
          CustomerDetails['_name'],
          CustomerDetails['_contact_no'],
          CustomerDetails['_designation'],
          CustomerDetails['_email'],
        );
        _CustomerDetailsList.add(customerDetailsModel);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Customer Details',
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _CustomerDetailsList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print('------------>Edit or Delete invoke : Send Data ');
                  print(_CustomerDetailsList[index].id);
                  print(_CustomerDetailsList[index].name);
                  print(_CustomerDetailsList[index].contact_no);
                  print(_CustomerDetailsList[index].designation);
                  print(_CustomerDetailsList[index].email);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OptimizeCustomerFormScreen(),
                      settings: RouteSettings(
                        arguments: _CustomerDetailsList[index],
                      )
                  ));
                },
                child: ListTile(
                  title: Text(_CustomerDetailsList[index].contact_no),
                ),
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('-------->Lanch Customer Form Screen');
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OptimizeCustomerFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }


}
