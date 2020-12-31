import 'package:background_locator_example/Global.dart';
import 'package:background_locator_example/Providers/ProviderFirebase.dart';
import 'package:background_locator_example/Screens/AdminPage/LiveTracking.dart';
import 'package:background_locator_example/Screens/LoginPage.dart';
import 'package:flutter/material.dart';

class AdminMain extends StatefulWidget {
  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ProviderFirebase.logout().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false));
            }),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [Text("Watch Devices")],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: Global.deviceList.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          //Go to Live Tracking
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LiveTracking(
                                        deviceID: Global.deviceList[index],
                                      )));
                        },
                        child: ListTile(
                          title: Text(Global.deviceList[index]),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
