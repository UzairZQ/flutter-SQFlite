import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_sqlflite/user_database.dart';
import 'package:flutter_sqlflite/user_modal.dart';

void main() {
  runApp((SQLApp()));
}

class SQLApp extends StatelessWidget {
  const SQLApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String id = "";
  String name = "";

  EmployeeDatabse employeeDatabse = EmployeeDatabse();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      employeeDatabse.initiliazeDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD RECORD'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  id = value;
                });
                print(id);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });

                print(name);
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (id.isNotEmpty) {
                      UserModal userModal =
                          UserModal(id: int.parse(id), name: name);

                      employeeDatabse
                          .addEmployees(userModal)
                          .then((bool isAdded) {
                        if (isAdded) {
                          print("Record Added Successfully");
                        } else {
                          print('Record insertion failed');
                        }
                      });
                    } else {
                      print('Record cannot be empty to add');
                    }
                  },
                  child: const Text(
                    'Add Record',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (id.isNotEmpty) {
                      UserModal userModal =
                          UserModal(id: int.parse(id), name: name);
                      employeeDatabse.updateEmployee(userModal).then((value) {
                        if (value) {
                          print("Record updated successfully");
                        } else {
                          print("Record Updation Failed");
                        }
                      });
                    } else {
                      print('Record cannot be empty to update');
                    }
                  },
                  child: const Text(
                    'Update Record',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (id.isNotEmpty) {
                      employeeDatabse
                          .deleteEmployeebyId(id)
                          .then((bool isDeleted) {
                        if (isDeleted) {
                          print("Single Record Deleted Successfully");
                        } else {
                          print('Single Record Deletion Failed');
                        }
                      });
                    } else {
                      print('Record cannot be empty to Delete');
                    }
                  },
                  child: const Text(
                    'Delete Single Record',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    employeeDatabse.deleteAllEmployees().then((value) {
                      if (value) {
                        print("All Records Deleted Successfully");
                      } else {
                        print("All Record Deleteion Failed");
                      }
                    });
                  },
                  child: const Text(
                    'Delete All Records',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    employeeDatabse.getEmployeesCount().then((value) {
                      print("Total Record: $value");
                    });
                  },
                  child: const Text(
                    'Count Records',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    employeeDatabse
                        .getAllEmployees()
                        .then((List<UserModal> list) {
                      list.forEach((element) {
                        print("Id: ${element.id}  Name: ${element.name}");
                      });
                    });
                  },
                  child: const Text(
                    'Show All Records',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
