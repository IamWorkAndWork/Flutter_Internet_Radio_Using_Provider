import 'package:flutter_internet_radio_using_provider/models/base_model.dart';
import 'package:flutter_internet_radio_using_provider/models/db_model.dart';

class RadioAPIModel extends BaseModel {
  List<RadioModel> data;

  RadioAPIModel({this.data});

  @override
  fromJson(Map<String, dynamic> json) {
    this.data =
        (json["Data"] as List).map((e) => RadioModel.fromJson(e)).toList();
  }
}

class RadioModel extends DBBaseBoldel {
  static String table = "radios";
  @override
  final int id;
  final String radioName;
  final String radioUrl;
  final String radioDesc;
  final String radioWebsite;
  final String radioPic;
  final bool isBookmarked;

  RadioModel(
      {this.id,
      this.radioName,
      this.radioUrl,
      this.radioDesc,
      this.radioWebsite,
      this.radioPic,
      this.isBookmarked});

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
        id: json["ID"],
        radioName: json["RadioName"],
        radioUrl: json["RadioURL"],
        radioDesc: json["RadioDesc"],
        radioWebsite: json["RadioWebsite"],
        radioPic: json["RadioPic"],
        isBookmarked: false);
  }

  static RadioModel fromMap(Map<String, dynamic> map) {
    return RadioModel(
        id: map["id"],
        radioName: map["radioName"],
        radioUrl: map["radioURL"],
        radioDesc: map["radioDesc"],
        radioWebsite: map["radioWebsite"],
        radioPic: map["radioPic"],
        isBookmarked: map["isFavourite"] == 1 ? true : false);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'RadioName': radioName,
      'RadioURL': radioUrl,
      'RadioDesc': radioDesc,
      'RadioWebsite': radioWebsite,
      'RadioPic': radioPic
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
