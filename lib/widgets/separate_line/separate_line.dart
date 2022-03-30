import 'package:flutter/material.dart';

/*分割线*/
class SeparateLineWidget extends StatelessWidget {
  const SeparateLineWidget({
    Key? key,
    this.width = double.infinity,
    this.height = 0.5,
    this.color = const Color(0xFFF0F2F5),
  }) : super(key: key);

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      width: width,
      color: color,
      alignment: Alignment.center,
    );
  }
}
