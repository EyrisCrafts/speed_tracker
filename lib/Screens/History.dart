import 'dart:developer';

import 'package:background_locator_example/Providers/ProviderFiles.dart';
import 'package:background_locator_example/Utils.dart';
import 'package:flutter/material.dart';
import 'package:background_locator_example/Screens/MapScreen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<String>> fileNames;
  @override
  void initState() {
    fileNames = ProviderFiles.listFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Container(
        width: double.infinity,
        child: FutureBuilder<List<String>>(
            future: fileNames,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log("list size ${snapshot.data.length}");
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              //TODO Go to map
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                            fileName: snapshot.data[index],
                                          )));
                            },
                            child: ListTile(
                              title: Text(
                                  Utils.translateDate(snapshot.data[index])),
                            ),
                          ),
                        ));
              }
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
