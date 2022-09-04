import 'dart:io';
import 'package:http_server/api/student_handler.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Server {
  HttpServer? hServer;
  String? wifiIP;
  int port = 1122;

  Future<dynamic> findIp() async {
    wifiIP = await NetworkInfo().getWifiIP() ?? '0.0.0.0';
    return wifiIP;
  }

  openServer() async {
    hServer = await HttpServer.bind(wifiIP, port);

    await for (HttpRequest hr in hServer!) {
      if (hr.uri.path == '/student/create') {
        String? name = hr.uri.queryParameters['name'];
        String? dep = hr.uri.queryParameters['dep'];
        StudentHandler().createStu(name!, dep!);
        hr.response.write('Create StatusCode: ${hr.response.statusCode}');
      }
      if (hr.uri.path == '/student/read') {
        StudentHandler().readStu(hr);
      }
      if (hr.uri.path == '/student/update') {
        String? id = hr.uri.queryParameters['id'];
        String? name = hr.uri.queryParameters['name'];
        String? dep = hr.uri.queryParameters['dep'];
        StudentHandler().updateStu(id!, name!, dep!);
        hr.response.write('Update StatusCode: ${hr.response.statusCode}');
      }
      if (hr.uri.path == '/student/delete') {
        String? id = hr.uri.queryParameters['id'];
        StudentHandler().deleteStu(id!);
        hr.response.write('Delete StatusCode: ${hr.response.statusCode}');
      }

      hr.response.close();
    }
  }

  closeServer() async {
    await hServer!.close();
  }
}
