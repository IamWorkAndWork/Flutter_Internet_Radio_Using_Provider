import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';
import 'package:flutter_internet_radio_using_provider/services/player_provider.dart';
import 'package:provider/provider.dart';

class RadioRowTemplate extends StatefulWidget {
  final RadioModel radioModel;
  final bool isFavouriteOnlyRadios;

  RadioRowTemplate({Key key, this.radioModel, this.isFavouriteOnlyRadios})
      : super(key: key);

  @override
  _RadioRowTemplateState createState() => _RadioRowTemplateState();
}

class _RadioRowTemplateState extends State<RadioRowTemplate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  Widget _buildSongRow() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final bool _isSelctedRadio =
        widget.radioModel.id == playerProvider.currentRadio.id;

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
        children: <Widget>[
          _buildPlayStopIcon(playerProvider, _isSelctedRadio),
          _buildAddFavouriteIcon()
        ],
      ),
    );
  }

  _buildPlayStopIcon(PlayerProvider playerProvider, isSelctedRadio) {
    return IconButton(
      icon: _buildAudioButton(playerProvider, isSelctedRadio),
      onPressed: () {
        print(
            "play music : ${widget.radioModel.id} | ${widget.radioModel.radioName} | ${widget.radioModel.radioUrl} | ${playerProvider.getPlayerState()}");
        if (!playerProvider.isStopped() && isSelctedRadio) {
          playerProvider.stopRadio();
        } else {
          bool isloading = playerProvider.isLoading();
          // print("isLoading = ${isloading}");
          if (!isloading) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(widget.radioModel);
            playerProvider.playRadio();
          }
        }
      },
    );
  }

  _buildAudioButton(PlayerProvider playerProvider, bool isSelctedRadio) {
    if (isSelctedRadio) {
      if (playerProvider.isLoading()) {
        return Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
      }

      if (!playerProvider.isStopped()) {
        return Icon(Icons.stop);
      }

      if (playerProvider.isStopped()) {
        return Icon(Icons.play_circle_filled);
      }
    } else {
      return Icon(Icons.play_circle_filled);
    }
  }

  _buildAddFavouriteIcon() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    return IconButton(
      icon: widget.radioModel.isBookmarked
          ? Icon(Icons.favorite)
          : Icon(
              Icons.favorite_border,
              color: Color(
                0xff9097a6,
              ),
            ),
      onPressed: () {
        playerProvider.radioBookmarked(
          widget.radioModel.id,
          !widget.radioModel.isBookmarked,
          isFavoriteOnly: widget.isFavouriteOnlyRadios,
        );
      },
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
