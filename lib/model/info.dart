class Info {
  double totalAmount;
  String cryptoName;
  String announcementContent;

  Info(this.totalAmount, this.cryptoName, this.announcementContent);

/*
  double get totalAmount => _totalAmount;

  String get cryptoName => _cryptoName;

  String get announcementContent => _announcementContent;

  Info({
    double totalAmount,
    String cryptoName,
    String announcementContent}) {
    _totalAmount = totalAmount;
    _cryptoName = cryptoName;
    _announcementContent = announcementContent;
  }

  Info.fromJson(Map<String, dynamic> json) {
    _totalAmount = json["totalAmount"];
    _cryptoName = json["cryptoName"];
    _announcementContent = json["announcementContent"];

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["totalAmount"] = _totalAmount;
    map["cryptoName"] = _cryptoName;
    map["announcementContent"] = _announcementContent;

    return map;
  }*/
}

