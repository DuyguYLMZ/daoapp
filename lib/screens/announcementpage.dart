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

  List<Announcement> cryptoList = [];
  final DateFormat formatter = DateFormat('MM/dd/yyyy');


  @override
  void initState() {
    super.initState();
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
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: const Text('Loading...'),
                );
              } else {
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
                              children: [CardWidget(context,0, cryptoList)],
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

          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("dao").get();

    await FirebaseFirestore.instance.collection("dao").get().then((querySnapshot) async {
      querySnapshot.docs.forEach((result) async {
        await FirebaseFirestore.instance
            .collection("dao")
            .doc("010122")
            .collection("post1")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
              cryptoList.add(  Announcement(
                result.data()['totalAmount'],
                result.data()['cryptoName'],
                result.data()['announcementContent'],
              ));
          });
        });
      });
    });
  return  querySnapshot;
  }

  Future<void> _onRefresh() async {
    setState(() {
      // getData();
    });

    return 'success';
  }
}
