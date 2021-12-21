import 'package:dao/model/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CardWidget(BuildContext context, int index, List<Info> AnnouncementList) {
  return Card(
    shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.green, width: 1)),
    elevation: 3,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0.0, 0.0, 0.0, 0.8],
            colors: [
              Colors.white38,
              Colors.green,
              Colors.green,
              Colors.white38,
            ],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.white30,
                blurRadius: 2.0,
                offset: Offset(2.0, 2.0))
          ]),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(child: AnnouncementIcon(AnnouncementList  [index])),
                            AnnouncementChange(AnnouncementList[index]),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: AnnouncementAmount(
                                    AnnouncementList[index], context))
                          ],
                        )
                      ],
                    ))
              ],
            ),
          )
        ]),
      ),
    ),
  );
}

Widget AnnouncementIcon(data) {
  return Padding(
    padding: const EdgeInsets.only(left: 0),
    child: Row(
      children: [

        Expanded(child: AnnouncementNameSymbol(data)),
      ],
    ),
  );
}

Widget AnnouncementNameSymbol(data) {
  return RichText(
    text: TextSpan(
      text: "${data.totalAmount}",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 16),
      children: <TextSpan>[
        TextSpan(
            text: "\n${data.totalAmount}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget AnnouncementChange(data) {
  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: RichText(
        text: TextSpan(
          text: "Price",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
                text: "\n" + "\$ " + "${data.totalAmount}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}

Widget AnnouncementAmount(data, BuildContext context) {
 //final dateTime = DateTime.parse(data.totalAmount);
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time Left",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                          fontSize: 14),
                    ),
                  
                  ],
                ),
              ),
              
            ])),
  );
}
