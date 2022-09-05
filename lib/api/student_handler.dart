import 'dart:convert';
import 'dart:io';
import 'package:http_server/model/student.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:uuid/uuid.dart';

class StudentHandler {
  static List<Student> stu = [];

  //create
  createStu(String name, String dep) {
    Student s = Student(id: const Uuid().v1(), name: name, dep: dep);
    stu.add(s);
  }

  //read
  readStu(HttpRequest httpRequest) {
    String stuAsJsonFormat = jsonEncode(stu);
    httpRequest.response.write(stuAsJsonFormat);
  }

  //update
  updateStu(String id, String name, String dep) {
    for (int i = 0; i < stu.length; i++) {
      if (stu[i].id == id) {
        stu[i] = Student(id: stu[i].id, name: name, dep: dep);
        break;
      }
    }
  }

  //delete
  deleteStu(String id) {
    for (int i = 0; i < stu.length; i++) {
      if (stu[i].id == id) {
        stu.removeAt(i);
        break;
      }
    }
  }
}
