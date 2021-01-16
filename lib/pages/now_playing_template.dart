import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/services/player_provider.dart';
import 'package:provider/provider.dart';

class NowPlayingTemplate extends StatelessWidget {
  final String radioTitle;
  final String radioImageUrl;

  NowPlayingTemplate({Key key, this.radioTitle, this.radioImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff182545),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _nowPlayingText(context, this.radioTitle, this.radioImageUrl)
            ],
          ),
        ),
      ),
    );
  }

  Widget _nowPlayingText(BuildContext context, String title, String imageUrl) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "Now Playing",
          textScaleFactor: 0.8,
          style: TextStyle(color: Colors.white),
        ),
        leading: _image(imageUrl, size: 50.0),
        trailing: Wrap(
          spacing: -10.0,
          children: <Widget>[
            _buildStopIcon(context),
            _buildShareIcon(),
          ],
        ),
      ),
    );
  }

  _image(String imageUrl, {double size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(imageUrl),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: Color(0xff182545),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 1), //change position of shadow
          )
        ],
      ),
    );
  }

  _buildStopIcon(BuildContext context) {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return IconButton(
      icon: Icon(Icons.stop),
      onPressed: () {
        playerProvider.stopRadio();
      },
      color: Color(0xff9097a6),
    );
  }

  _buildShareIcon() {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {},
      color: Color(0xff9097a6),
    );
  }
}
