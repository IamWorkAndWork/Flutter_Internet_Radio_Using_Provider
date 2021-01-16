import 'package:flutter_internet_radio_using_provider/config.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';
import 'package:flutter_internet_radio_using_provider/utils/db_service.dart';
import 'package:flutter_internet_radio_using_provider/utils/webservice.dart';

class DBDownloadService {
  static Future<bool> isLocalDBAvailable() async {
    await DB.init();
    List<Map<String, dynamic>> _results = await DB.query(RadioModel.table);
    return _results.length == 0 ? false : true;
  }

  static Future<RadioAPIModel> fetchAllRadios() async {
    final serviceResponse =
        await WebService().getData(Config.api_URL, RadioAPIModel());
    return serviceResponse;
  }

  static Future<List<RadioModel>> fetchLocalDB({
    String searchQuery = "",
    bool isFavouriteOnly = false,
  }) async {
    await Future.delayed(
      Duration(
        seconds: 1,
      ),
    );

    if (!await isLocalDBAvailable()) {
      RadioAPIModel radioAPIModel = await fetchAllRadios();
      if (radioAPIModel.data.length > 0) {
        await DB.init();

        radioAPIModel.data.forEach((RadioModel radioModel) {
          DB.insert(RadioModel.table, radioModel);
        });
      }
    }

    String rawQuery = "";
    if (!isFavouriteOnly) {
      rawQuery =
          "SELECT radios.id, radioName, radioURL, radioURL, radioDesc, radioWebsite, radioPic,"
          "isFavourite FROM radios LEFT JOIN radios_bookmarks ON radios_bookmarks.id = radios.id ";

      if (searchQuery.trim() != "") {
        rawQuery = rawQuery +
            " WHERE radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }
    } else {
      rawQuery =
          "SELECT radios.id, radioName, radioURL, radioURL, radioDesc, radioWebsite, radioPic,"
          "isFavourite FROM radios INNER JOIN radios_bookmarks ON radios_bookmarks.id = radios.id "
          "WHERE isFavourite = 1 ";

      if (searchQuery.trim() != "") {
        rawQuery = rawQuery +
            " AND radioName LIKE '%$searchQuery%' OR radioDesc LIKE '%$searchQuery%' ";
      }
    }

    List<Map<String, dynamic>> _results = await DB.rawQuery(rawQuery);

    List<RadioModel> radioModelList = List<RadioModel>();
    radioModelList = _results.map((item) => RadioModel.fromMap(item)).toList();

    return radioModelList;
  }
}
