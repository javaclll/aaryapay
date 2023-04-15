
import 'package:flutter/material.dart';


class CustomStatusButton extends StatelessWidget {
  const CustomStatusButton(
      {Key? key,
      required this.widget,
      required this.label,
      this.width,
      this.height,
      this.borderRadius})
      : super(key: key);
  final Widget widget;
  final double? width;
  final double? height;
  final String label;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      // onTap: print("lol"),
      child: Container(
        padding: const EdgeInsets.all(5),
        width: width ?? size.width * 0.19,
        height: height ?? size.height * 0.04,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 10))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // SvgPicture.asset(
          //   "assets/icons/sync.svg",
          //   height: 11,
          //   width: 11,
          // ),
          widget,
          Text(
            label,
            style: textTheme.bodySmall,
          )
        ]),
      ),
    );
  }
}
