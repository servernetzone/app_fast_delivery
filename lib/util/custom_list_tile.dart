import 'package:flutter/material.dart';


class CustomListTile extends StatelessWidget {

  final Widget leading;
  final Widget title;
  final Widget trailing;
  final EdgeInsetsGeometry contentPadding;


  CustomListTile({
    Key key,
    this.leading,
    this.title,
    this.trailing,
    this.contentPadding
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
