import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/pages/radio_page.dart';

class FavRadioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RadioPage(
      isFavouriteOnly: true,
    );
  }
}
