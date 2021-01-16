class RadioModel {
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
}
