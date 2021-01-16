import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';
import 'package:flutter_internet_radio_using_provider/pages/now_playing_template.dart';
import 'package:flutter_internet_radio_using_provider/pages/radio_row_template.dart';

class RadioPage extends StatefulWidget {
  RadioPage({Key key}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  RadioModel radioModel = RadioModel(
      id: 1,
      radioName: "Test radio 1",
      radioDesc: "Test radio desc",
      radioPic: "http://isharpeners.com/sc_logo.png");

  var _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _appLogo(),
          _searchBar(),
          _radioList(),
          NowPlayingTemplate(
            radioTitle: radioModel.radioName,
            radioImageUrl: radioModel.radioPic,
          )
        ],
      ),
    );
  }

  Widget _appLogo() {
    return Container(
      width: double.infinity,
      color: Color(0xff182545),
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            "Radio App",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          Flexible(
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5.0),
                hintText: "Search Radio",
              ),
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _radioList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: ListView(
          children: <Widget>[
            ListView.separated(
              itemCount: 10,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return RadioRowTemplate(
                  radioModel: radioModel,
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            )
          ],
        ),
      ),
    );
  }
}
