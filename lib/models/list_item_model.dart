class ListItemModel{
  final String itemTitle;
  List<void Function()>? clickEvent;

  ListItemModel({required this.itemTitle, clickEvent});
}