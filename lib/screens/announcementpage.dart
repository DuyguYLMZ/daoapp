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
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  DataProvider _provider;
  CollectionReference _collectionRef;

  @override
  void initState() {
    super.initState();
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
                  );
                },
                child: Icon(
                  Icons.power_settings_new,
                  size: 26.0,
                ),
              )),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Hello"),
            FutureBuilder(
              future: getWalletAmount(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Expanded(
                      child:
                          Container(child: Center(child: Text('Loading...'))));
                } else {
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
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
                    itemCount: _provider.getDateList().length,
                    separatorBuilder: (context, index) {
                      return const Divider(height: 1.0);
                    },
                    itemBuilder: (context, indexx) {
                      return ExpansionTile(
                          title: Text(_provider
                              .getDateList()[indexx]
                              .announcementDate
                              .toString()),
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height *
                                          0.75),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        //just set this property
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: _provider
                                            .getDateList()[indexx]
                                            .infoList
                                            .length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 0, 2, 0),
                                              height: 120,
                                              width: double.maxFinite,
                                              child: CardWidget(
                                                  context,
                                                  index,
                                                  _provider
                                                      .getDateList()[indexx]
                                                      .infoList));
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
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getData() async {
    Future<void> user =  FirebaseAuth.instance.currentUser.reload();

    if (user == null){
      await FirebaseAuth.instance.signOut();
print("dd");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }else{
      print("jkkjcsjkds");
    }

    this._collectionRef = FirebaseFirestore.instance.collection('dao');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    querySnapshot.docs.map((doc) {
      if (_provider.getDateList().length > 0) {
        bool isExsist = false;
        for (var data in _provider.getDateList()) {
          if (data.announcementDate == doc.id) {
            isExsist = true;
          }
        }
        if (!isExsist) {
          setState(() {
            _provider.addDateList(Announcement([], doc.id));
          });
        }
      } else {
        setState(() {
          _provider.addDateList(Announcement([], doc.id));
        });
      }
    }).toList();

    for (int i = 0; i < _provider.getDateList().length; i++) {
      _collectionRef.get().then((querySnapshot) async {
        querySnapshot.docs.forEach((result) async {
          await FirebaseFirestore.instance
              .collection("dao")
              .doc(_provider.getDateList()[i].announcementDate.toString())
              .collection("post1")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if (this._provider.getCryptoList(i).length > 0) {
                bool isExsist = false;
                for (var data in this._provider.getCryptoList(i)) {
                  if (data.cryptoName == result.data()['cryptoName'] &&
                      data.totalAmount == result.data()['totalAmount'] &&
                      data.announcementContent ==
                          result.data()['announcementContent']) {
                    isExsist = true;
                  } else if (data.cryptoName == result.data()['cryptoName'] ||
                      data.totalAmount == result.data()['totalAmount'] ||
                      data.announcementContent ==
                          result.data()['announcementContent']) {
                    _provider
                        .getDateList()[i]
                        .infoList[_provider.getCryptoList(i).indexOf(data)]
                        .cryptoName = result.data()['cryptoName'];
                    _provider
                        .getDateList()[i]
                        .infoList[_provider.getCryptoList(i).indexOf(data)]
                        .totalAmount = result.data()['totalAmount'];
                    _provider
                            .getDateList()[i]
                            .infoList[_provider.getCryptoList(i).indexOf(data)]
                            .announcementContent =
                        result.data()['announcementContent'];
                    isExsist = true;
                  }
                }
                if (!isExsist) {
                  setState(() {
                    _provider.getDateList()[i].infoList.add(Info(
                          result.data()['totalAmount'],
                          result.data()['cryptoName'],
                          result.data()['announcementContent'],
                        ));
                  });

                  for (var date in _provider.getDateList()) {
                    if (_provider
                            .getDateList()[i]
                            .announcementDate
                            .toString() ==
                        date.announcementDate.toString()) {
                      setState(() {
                        _provider.getDateList()[i].infoList =
                            this._provider.getCryptoList(i);
                      });
                    }
                  }
                }
              } else {
                setState(() {
                  _provider.getDateList()[i].infoList.add(Info(
                        result.data()['totalAmount'],
                        result.data()['cryptoName'],
                        result.data()['announcementContent'],
                      ));
                  for (var date in _provider.getDateList()) {
                    if (_provider
                            .getDateList()[i]
                            .announcementDate
                            .toString() ==
                        date.announcementDate.toString()) {
                      _provider.getDateList()[i].infoList =
                          this._provider.getCryptoList(i);
                    }
                  }
                });
              }
            });
          });
        });
      });
    }

    return querySnapshot;
  }

  Future getWalletAmount() async {
    this._collectionRef = FirebaseFirestore.instance.collection('wallet');
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

  Future<void> _onRefresh() async {
    setState(() {
      getData();
    });

    return 'success';
  }
}
