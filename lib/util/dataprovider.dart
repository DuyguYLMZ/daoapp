import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  String walletAmount;

  void setWalletAmount(String amount) {
    this.walletAmount = amount;
  }

  String getWalletAmount(){
    if(walletAmount == null){
      walletAmount = "";
    }
    return this.walletAmount;
  }
}
