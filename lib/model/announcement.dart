import 'package:dao/model/info.dart';


class Announcement {
  List<Info> infoList;
  String announcementDate;

  Announcement(this.infoList, this.announcementDate);


/*

  String get announcementDate => _announcementDate;
  List<Info> get infoList => _infoList;

  Announcement({
    List<Info> infoList,
    String announcementDate}){
    _infoList = infoList;
    _announcementDate = announcementDate;
  }

  Announcement.fromJson(Map<String, dynamic> json) {
    _announcementDate = json["announcementDate"];
    if (json["infoList"] != null) {
      _infoList = [];
      json["infoList"].forEach((v) {
        _infoList.add(Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["announcementDate"] = _announcementDate;
    if (_infoList != null) {
      map["infoList"] = _infoList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
*/
}
