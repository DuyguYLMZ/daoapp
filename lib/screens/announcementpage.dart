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
  List dateList = [];
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
                return ListView.separated(
                  itemCount: dateList.length,
                  separatorBuilder: (context, index){
                    return const Divider(height: 1.0);
                  },
                  itemBuilder: (context, index){
                    final item = dateList[index];
                    return ExpansionTile(
                      title: Text(item.toString()),
                      children: [ ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                            MediaQuery.of(context).size.height * 0.75),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true, //just set this property
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: cryptoList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding:
                                        EdgeInsets.fromLTRB(2, 0, 2, 0),
                                        height: 120,
                                        width: double.maxFinite,
                                        child: CardWidget(
                                            context, index, cryptoList));
                                  }),
                            ),
                          ],
                        ),
                      )]
                    );
                  },
                );
              }
            },
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection('dao');

    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.map((doc) {



      if (this.dateList == null) {
        this.dateList = [];
      }
      if (dateList.length > 0) {
        bool isExsist = false;
        for (var data in dateList) {
          if (data == doc.id) {
            isExsist = true;
          }
        }
        if (!isExsist) {
          dateList.add(doc.id);
        }
      } else {
        dateList.add(doc.id);
      }


    }).toList();

    for(int i =0; i<dateList.length;i++)
    await FirebaseFirestore.instance
        .collection("dao")
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((result) async {
        await FirebaseFirestore.instance
            .collection("dao")
            .doc(dateList[i])
            .collection("post1")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            if (this.cryptoList == null) {
              this.cryptoList = [];
            }
            if (cryptoList.length > 0) {
              bool isExsist = false;
              for (var data in cryptoList) {
                if (data.cryptoName == result.data()['cryptoName']) {
                  isExsist = true;
                }
              }
              if (!isExsist) {
                cryptoList.add(Announcement(
                  result.data()['totalAmount'],
                  result.data()['cryptoName'],
                  result.data()['announcementContent'],
                ));
              }
            } else {
              cryptoList.add(Announcement(
                result.data()['totalAmount'],
                result.data()['cryptoName'],
                result.data()['announcementContent'],
              ));
            }
          });
        });
      });
    });
    return querySnapshot;
  }

  Future<void> _onRefresh() async {
    setState(() {
      // getData();
    });

    return 'success';
  }
}
