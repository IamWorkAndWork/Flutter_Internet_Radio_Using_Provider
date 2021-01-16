import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';
import 'package:flutter_internet_radio_using_provider/pages/now_playing_template.dart';
import 'package:flutter_internet_radio_using_provider/pages/radio_row_template.dart';
import 'package:flutter_internet_radio_using_provider/services/player_provider.dart';
import 'package:provider/provider.dart';

class RadioPage extends StatefulWidget {
  final bool isFavouriteOnly;
  RadioPage({Key key, this.isFavouriteOnly}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _searchQuery = TextEditingController();
  Timer _debounce;
  AudioPlayer _audioPlayer;

  RadioModel radioModel = RadioModel(
      id: 1,
      radioName: "Test radio 1",
      radioDesc: "Test radio desc",
      radioPic: "http://isharpeners.com/sc_logo.png");

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllRadios(isFavouriteOnly: widget.isFavouriteOnly);

    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _appLogo(),
          _searchBar(),
          _radiosList(),
          _nowPlaying(),
        ],
      ),
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    print("_nowPlaying status  = ${playerProvider.getPlayerState()}");
    return Visibility(
        visible: playerProvider.getPlayerState() == RadioPlayerState.PLAYING,
        child: NowPlayingTemplate(
          radioTitle: radioModel.radioName,
          radioImageUrl: radioModel.radioPic,
        ));
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

  Widget _radiosList() {
    return Consumer<PlayerProvider>(
      builder: (context, radioModel, child) {
        if (radioModel.totalRecords > 0) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                    itemBuilder: (context, index) {
                      return RadioRowTemplate(
                        radioModel: radioModel.allRadio[index],
                        isFavouriteOnlyRadios: widget.isFavouriteOnly,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: radioModel.totalRecords,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                  )
                ],
              ),
            ),
          );
        }
        return Expanded(child: _noData(radioModel.isFetch));
      },
    );
  }

  // Widget _radiosList() {
  //   return FutureBuilder(
  //     future: DBDownloadService.fetchLocalDB(),
  //     builder: (BuildContext context, AsyncSnapshot<List<RadioModel>> radios) {
  //       if (radios.hasData) {
  //         return Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //             child: ListView(
  //               children: <Widget>[
  //                 ListView.separated(
  //                   itemCount: radios.data.length,
  //                   physics: ScrollPhysics(),
  //                   shrinkWrap: true,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     // print("data = ${radios.data[index].toMap()}");

  //                     return RadioRowTemplate(
  //                       radioModel: radios.data[index],
  //                     );
  //                   },
  //                   separatorBuilder: (context, index) {
  //                     return Divider();
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //       return Expanded(
  //           child: Center(
  //         child: CircularProgressIndicator(),
  //       ));
  //     },
  //   );
  // }

  _onSearchChanged() {
    var radioProvider = Provider.of<PlayerProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(Duration(microseconds: 500), () {
      radioProvider.fetchAllRadios(
        isFavouriteOnly: widget.isFavouriteOnly,
        searchQuery: _searchQuery.text,
      );
    });
  }

  _noData(bool isFetch) {
    String noDataText = "";
    bool showTextMessge = false;

    if (widget.isFavouriteOnly ||
        (widget.isFavouriteOnly && _searchQuery.text.isNotEmpty)) {
      noDataText = "No Favorites";
      showTextMessge = true;

      if (!isFetch) {
        showTextMessge = false;
      }
    } else if (_searchQuery.text.isNotEmpty) {
      noDataText = "No Radio Found";
      showTextMessge = true;
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: showTextMessge
                ? Text(
                    noDataText,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
