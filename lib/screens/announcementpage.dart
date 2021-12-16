import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dao/model/announcement.dart';
import 'package:dao/widgets/cardwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementPage extends StatefulWidget {
  AnnouncementPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  bool active = false;
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  List<Announcement> cryptoList = [];
  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('dao');

  @override
  void initState() {
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {
    String createDate = formatter.format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: const Text('Loading...'),
                );
              } else {
                // List<dynamic> json=jsonDecode(snapshot.data.body);

                return SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      active = !active;
                      setState(() {});
                    },
                    children: <ExpansionPanel>[
                      ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return Text(createDate);
                          },
                          body: Container(
                            child: Column(
                              children: [CardWidget(context, 0, cryptoList)],
                            ),
                          ),
                          isExpanded: active,
                          canTapOnHeader:
                              true), //for (int i = 0; i < 5; i++) items[i];
                    ],
                  ),
                );
              }
            },
            future: getData(),
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < allData.length; i++) {
      cryptoList.add(  Announcement(
        (allData[i] as dynamic)['totalAmount'],
        (allData[i] as dynamic)['cryptoName'],
        (allData[i] as dynamic)['announcementContent'],
      ));

    }

    return querySnapshot;
  }

  Future<void> _onRefresh() async {
    setState(() {
      // getData();
    });

    return 'success';
  }
}
