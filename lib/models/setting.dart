class Setting {
  final String mainTitle;
  final String? subTitle;
  final Function()? clickEvent;
  final String? statusText;
  final bool? isCheckbox;
  final String? colorCode;

  Setting({
    this.subTitle,
    this.statusText,
    this.isCheckbox,
    this.clickEvent,
    this.colorCode,
    required this.mainTitle,
  });
}
