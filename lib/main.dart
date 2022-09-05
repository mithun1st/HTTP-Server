import 'package:flutter/material.dart';
import 'package:http_server/controller/server.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Server serverObj = Server();
  bool isServerOn = false;

  @override
  Widget build(BuildContext context) {
    //--

    //--/
    return Scaffold(
      appBar: AppBar(
        title: const Text('http Server'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: serverObj.findIp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                } else if (snapshot.hasData) {
                  var ip = snapshot.data;
                  return Text(
                    'http://$ip:${serverObj.port}/',
                    style: const TextStyle(fontSize: 22),
                  );
                } else {
                  return const Text('IP Not Found');
                }
              },
            ),
            Switch(
              value: isServerOn,
              onChanged: (v) async {
                setState(() {
                  isServerOn = v;
                });
                if (isServerOn) {
                  await serverObj.openServer();
                } else {
                  await serverObj.closeServer();
                }
              },
            ),
            const Text('''
create: (POST)
http://ip:port/student/create
{"name":"Mithun", "dep":"cse"}
            
read: (GET)
http://ip:port/student/read

update: (PATCH)
http://ip:port/student/update?id=UUID
{"name":"MH Mithun", "dep":"CSE"}

delete: (DELETE )
http://ip:port/student/delete?id=UUID'''),
          ],
        ),
      ),
    );
  }
}
