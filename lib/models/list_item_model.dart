class ListItemModel{
  final String itemTitle;
  Function()? clickEvent;
  Function()? longClickEvent;

  ListItemModel({required this.itemTitle, this.clickEvent});
}