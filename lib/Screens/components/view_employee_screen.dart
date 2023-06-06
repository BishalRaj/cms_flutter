import 'package:flutter/material.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/navIcons.dart';

class ViewEmployeeScreen extends StatefulWidget {
  const ViewEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<ViewEmployeeScreen> createState() => _ViewEmployeeScreenState();
}

class _ViewEmployeeScreenState extends State<ViewEmployeeScreen> {
  var _hasData;
  var _employeeList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('View Employees'),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(iconBack)),
        ),
        body: Expanded(
          child: _hasData
              ? ListView.builder(
                  itemCount: _employeeList.length,
                  itemBuilder: (context, int index) =>
                      _buildEmployeeCard(context, index),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [Text('Nothing to show')],
                ),
        ),
      ),
    );
  }

  _buildEmployeeCard(BuildContext context, int index) {}
}
