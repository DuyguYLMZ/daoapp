import 'package:dao/model/announcement.dart';
import 'package:dao/model/info.dart';
import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  String walletAmount;
  List<Info> cryptoList = [];
  List<Announcement> dateList = [];

  void setWalletAmount(String amount) {
    this.walletAmount = amount;
  }

  String getWalletAmount(){
    if(walletAmount == null){
      walletAmount = "";
    }
    return this.walletAmount;
  }

  void addCryptoList(Info crypto) {
    if(cryptoList == null){
      cryptoList = [];
    }
    this.cryptoList.add(crypto);
  }

  List<Info> getcryptoListt(){
    if(cryptoList == null){
      cryptoList = [];
    }
    return this.cryptoList;
  }
}
