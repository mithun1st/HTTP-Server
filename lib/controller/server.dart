import 'dart:convert';
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
      //for 'student' path
      if (hr.uri.pathSegments[0] == 'student') {
        if (hr.uri.path == '/student/create' && hr.method == 'POST') {
          var data = await utf8.decoder.bind(hr).join();
          String? name = json.decode(data)['name'];
          String? dep = json.decode(data)['dep'];
          
          StudentHandler().createStu(name!, dep!);
          hr.response.write('Create StatusCode: ${hr.response.statusCode}');
        }
        if (hr.uri.path == '/student/read' && hr.method == 'GET') {
          StudentHandler().readStu(hr);
        }
        if (hr.uri.path == '/student/update'&& hr.method == 'PATCH') {
          String? id = hr.uri.queryParameters['id'];
          
          var data = await utf8.decoder.bind(hr).join();
          String? name = json.decode(data)['name'];
          String? dep = json.decode(data)['dep'];

          StudentHandler().updateStu(id!, name!, dep!);
          hr.response.write('Update StatusCode: ${hr.response.statusCode}');
        }
        if (hr.uri.path == '/student/delete'&&hr.method == 'DELETE') {
          String? id = hr.uri.queryParameters['id'];
          StudentHandler().deleteStu(id!);
          hr.response.write('Delete StatusCode: ${hr.response.statusCode}');
        }
      }

      hr.response.close();
    }
  }

  closeServer() async {
    await hServer!.close();
  }
}
