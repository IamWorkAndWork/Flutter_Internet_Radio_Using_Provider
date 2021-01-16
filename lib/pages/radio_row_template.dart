import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';

class RadioRowTemplate extends StatefulWidget {
  final RadioModel radioModel;

  RadioRowTemplate({Key key, this.radioModel}) : super(key: key);

  @override
  _RadioRowTemplateState createState() => _RadioRowTemplateState();
}

class _RadioRowTemplateState extends State<RadioRowTemplate> {
  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  Widget _buildSongRow() {
    return ListTile(
      title: Text(
        widget.radioModel.radioName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff182545),
        ),
      ),
      leading: _image(widget.radioModel.radioPic),
      subtitle: Text(
        widget.radioModel.radioDesc,
        maxLines: 2,
      ),
      trailing: Wrap(
        spacing: -10.0, //gap between adjacent chip
        runSpacing: 0.0, //gap between line
        children: <Widget>[_buildPlayStopIcon(), _buildAddFavouriteIcon()],
      ),
    );
  }

  _buildPlayStopIcon() {
    return IconButton(
      icon: Icon(Icons.play_circle_fill),
      onPressed: () {},
    );
  }

  _buildAddFavouriteIcon() {
    return IconButton(
      icon: Icon(Icons.favorite_border),
      onPressed: () {},
      color: Color(0xff9097a6),
    );
  }

  _image(String url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
          color: Color(0xffffe5ec),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                offset: Offset(0, 3), //change position of shadow
                blurRadius: 3)
          ]),
    );
  }
}
