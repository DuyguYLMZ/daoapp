import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dao/model/announcement.dart';
import 'package:dao/model/info.dart';
import 'package:dao/screens/loginpage.dart';
import 'package:dao/util/dataprovider.dart';
import 'package:dao/widgets/cardwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  AnnouncementPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Info> cryptoList = [];
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  List<Announcement> dateList = [];
  DataProvider _provider;

  @override
  void initState() {
    super.initState();
    getAnnocumentList();
  }

  @override
  Widget build(BuildContext context) {
    this._provider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
      Padding(
      padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );},
          child: Icon(
            Icons.power_settings_new,
            size: 26.0,
          ),
        )
    ),
          ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Hello"),
            FutureBuilder(
              future: getWalletAmount(),
              builder: (context,snap){
                if (!snap.hasData) {
                  return Expanded(child: Container(child: Text('Loading...')));
                }
                else{
                  return Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Text("Total "),
                          Text(_provider.getWalletAmount()),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
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
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1.0);
                  },
                  itemBuilder: (context, indexx) {
                    return ExpansionTile(
                        title:
                            Text(dateList[indexx].announcementDate.toString()),
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.75),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: ListView.builder(
                                      shrinkWrap: true, //just set this property
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount:
                                          dateList[indexx].infoList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 0, 2, 0),
                                            height: 120,
                                            width: double.maxFinite,
                                            child: CardWidget(context, index,
                                                dateList[indexx].infoList));
                                      }),
                                ),
                              ],
                            ),
                          )
                        ]);
                  },
                );
              }
            },
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('dao');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for (int i = 0; i < dateList.length; i++) {
      await FirebaseFirestore.instance
          .collection("dao")
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((result) async {
          await FirebaseFirestore.instance
              .collection("dao")
              .doc(dateList[i].announcementDate.toString())
              .collection("post1")
              .get()
              .then((querySnapshot) {
            this.cryptoList = [];
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
                  cryptoList.add(Info(
                    result.data()['totalAmount'],
                    result.data()['cryptoName'],
                    result.data()['announcementContent'],
                  ));
                  for (var date in dateList) {
                    if (dateList[i].announcementDate.toString() ==
                        date.announcementDate.toString()) {
                      dateList[i].infoList = cryptoList;
                    }
                  }
                }
              } else {
                cryptoList.add(Info(
                  result.data()['totalAmount'],
                  result.data()['cryptoName'],
                  result.data()['announcementContent'],
                ));
                for (var date in dateList) {
                  if (dateList[i].announcementDate.toString() ==
                      date.announcementDate.toString()) {
                    dateList[i].infoList = cryptoList;
                  }
                }
              }
            });
          });
        });
      });
    }

    return querySnapshot;
  }

  Future getAnnocumentList() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('dao');

    dateList = [];
    QuerySnapshot querySnapshot = await _collectionRef.get();
    querySnapshot.docs.map((doc) {
      if (this.dateList == null) {
        this.dateList = [];
      }
      if (dateList.length > 0) {
        bool isExsist = false;
        for (var data in dateList) {
          if (data.announcementDate == doc.id) {
            isExsist = true;
          }
        }
        if (!isExsist) {
          dateList.add(Announcement([], doc.id));
        }
      } else {
        dateList.add(Announcement([], doc.id));
      }
    }).toList();
  }

  Future getWalletAmount() async{
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('wallet');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    await FirebaseFirestore.instance
        .collection("wallet")
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((result) async {
        await FirebaseFirestore.instance
            .collection("wallet")
            .doc("total")
            .get()
            .then((querySnapshot) {
          setState(() {
            _provider.setWalletAmount(querySnapshot.data()["amount"]);
          });

        });
      });
    });

    return querySnapshot;
  }

}
