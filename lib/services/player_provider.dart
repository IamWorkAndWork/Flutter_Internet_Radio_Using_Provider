import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/models/radio.dart';
import 'package:flutter_internet_radio_using_provider/services/db_download_service.dart';
import 'package:flutter_internet_radio_using_provider/utils/db_service.dart';

enum RadioPlayerState { LOADING, STOPPED, PLAYING, PAUSE, CIMPLETED }

class PlayerProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  RadioModel _radioDetails;

  List<RadioModel> _radioFetcher;
  List<RadioModel> get allRadio => _radioFetcher;
  bool _isFetch = false;
  bool get isFetch => _isFetch;
  int get totalRecords => _radioFetcher != null ? _radioFetcher.length : 0;
  RadioModel get currentRadio => _radioDetails;

  RadioPlayerState _playerState = RadioPlayerState.STOPPED;
  StreamSubscription _positionSubscription;

  getPlayerState() => _playerState;
  getAudioPlayer() => _audioPlayer;
  getCurrentRadio() => _radioDetails;

  PlayerProvider() {
    _initStreams();
  }

  void _initStreams() {
    _radioFetcher = List<RadioModel>();
    if (_radioDetails == null) {
      _radioDetails = RadioModel(id: 0);
    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.STOPPED) {
      _audioPlayer = AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(RadioModel radio) async {
    _radioDetails = radio;

    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.LOADING);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_playerState == RadioPlayerState.LOADING && p.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.PLAYING);
      }

      // print("1p.inMilliseconds  = ${p.inMilliseconds}");

      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print("Flutter : state : " + state.toString());
      if (state == AudioPlayerState.PLAYING) {
        //updatePlayerState(RadioPlayerState.PLAYING);
        //notifyListeners();
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(RadioPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playRadio() async {
    print("currentRadio.radioURL1 = ${currentRadio.radioUrl}");

    try {
      print("start play radio");
      int status =
          await _audioPlayer.play(currentRadio.radioUrl, stayAwake: true);
      print("play radio success ${status}");
    } catch (e) {
      print("play radio error : ${e.toString()}");
    }
  }

  stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(RadioPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
    // await _audioPlayer.dispose();
  }

  bool isPlaying() {
    return getPlayerState() == RadioPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == RadioPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == RadioPlayerState.STOPPED;
  }

  fetchAllRadios({
    String searchQuery = "",
    bool isFavouriteOnly = false,
  }) async {
    _isFetch = false;
    _radioFetcher = await DBDownloadService.fetchLocalDB(
        searchQuery: searchQuery, isFavouriteOnly: isFavouriteOnly);
    _isFetch = true;
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state) {
    _playerState = state;
    notifyListeners();
  }

  Future<void> radioBookmarked(int radioId, bool isFavourite,
      {bool isFavoriteOnly = false}) async {
    await Future.delayed(Duration(
      microseconds: 500,
    ));

    int isFavouriteVal = isFavourite ? 1 : 0;
    await DB.init();
    await DB.rawInsert(
        "insert or replace into radios_bookmarks (id, isFavourite) values($radioId, $isFavouriteVal)");
    fetchAllRadios(isFavouriteOnly: isFavoriteOnly);
  }
}
