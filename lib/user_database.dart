import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'user_modal.dart';

const String databaseName = "employee_db";

const String tableName = "employee_table";

const String columnId = "id";

const String columnName = "name";

class EmployeeDatabse {
  static Database? _database;

  Future<Database> get getGatabase async {
    _database ??= await initiliazeDatabase();
    return _database!;
  }

  static EmployeeDatabse? _employeeDatabse;
  EmployeeDatabse._createInstance();

  factory EmployeeDatabse() {
    _employeeDatabse ??= EmployeeDatabse._createInstance();
    return _employeeDatabse!;
  }

  Future<Database> initiliazeDatabase() async {
    try {
      var databasePath = await getDatabasesPath();
      String path = p.join(databasePath, databaseName);

      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) {
          // creates a table in the database with id and name columns
          db.execute('''
        create table $tableName(
          $columnId INTEGER PRIMARY KEY,
          $columnName text not null
        )
      ''');
        },
      );
      return database;
    } catch (e) {
      print("DatabaseError  ${e.toString()}");
      return null!;
    }
  }

  Future<bool> addEmployees(UserModal employeeModal) async {
    try {
      Database db = await getGatabase;
      var result = await db.insert(
          tableName,
          employeeModal
              .toMap()); //adds all the values in the table of the database from the userModal
      print('DataBase add Result:$result');
      return true;
    } catch (e) {
      print("Database Add function Error :${e.toString()}");
      return false;
    }
  }

  Future<bool> updateEmployee(UserModal employeeModal) async {
    try {
      Database db = await getGatabase;
      var result = await db.update(
        tableName,
        employeeModal.toMap(),
        where: "$columnId = ?",
        whereArgs: [employeeModal.id],
      ); //updates values in the specific tuple of the database from the userModal
      print('DataBase update Result:$result');
      return true;
    } catch (e) {
      print("DatabaseError update function  ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteEmployeebyId(String id) async {
    try {
      Database db = await getGatabase;
      var result = await db.delete(tableName,
          where: "$columnId = ?",
          whereArgs: [id]); //deletes a specific value from the given argument
      print('DataBase delete specific Result:$result');
      return true;
    } catch (e) {
      print("DatabaseError deletebyId function  ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteAllEmployees() async {
    try {
      Database db = await getGatabase;
      var result = await db
          .delete(tableName); //deletes a specific value from the given argument
      print('DataBase delete Result:$result');
      return true;
    } catch (e) {
      print("DatabaseError deleteall function  ${e.toString()}");
      return false;
    }
  }

  Future<List<UserModal>> getAllEmployees() async {
    List<UserModal> employeeList = [];
    try {
      Database db = await getGatabase;
      List<Map<String, dynamic>> result =
          await db.query(tableName, orderBy: "$columnId DESC");
      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          UserModal userModal = UserModal.ModelObjectFromMap(result[i]);
          employeeList.add(userModal);
        }
      }
      return employeeList;
    } catch (e) {
      print("DatabaseError getallEmplyee function  ${e.toString()}");
      return null!;
    }
  }

  Future<int> getEmployeesCount() async {
    try {
      Database db = await getGatabase;
      List<Map<String, dynamic>> result = await db.query(tableName);
      print('DataBase getCount Result:$result');
      return result.length;
    } catch (e) {
      print("DatabaseError count function  ${e.toString()}");
      return null!;
    }
  }
}
