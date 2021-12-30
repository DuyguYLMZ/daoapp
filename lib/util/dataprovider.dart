import 'package:dao/model/announcement.dart';
import 'package:dao/model/info.dart';
import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  String walletAmount;
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


  List<Info> getCryptoList(int index){
    if(dateList[index].infoList == null){
      dateList[index].infoList = [];
    }
    return this.dateList[index].infoList;
  }

  void addDateList(Announcement announcement) {
    if(dateList == null){
      dateList = [];
    }
    this.dateList.add(announcement);
  }

  void removeDateList(Announcement announcement) {
    if(dateList.contains(announcement)){
      this.dateList.remove(announcement);
    }
  }

  void removeCrypto(int index, Info info) {
    if(dateList[index].infoList.contains(info)!=null){
      this.dateList[index].infoList.remove(info);
    }
  }

  List<Announcement> getDateList(){
    if(dateList == null){
      dateList = [];
    }
    return this.dateList;
  }
}
