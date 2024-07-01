import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  final double starRating;
  final IconData icons;
  final Color colors;
  final double? sizes;
  final double? sizesIcon;
  final FontWeight? fontWeight;

  const IconTextWidget({
    super.key,
    required this.starRating,
    required this.icons,
    required this.colors,
    this.sizes,
    this.fontWeight,
    this.sizesIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icons,
          color: colors,
          size: sizesIcon,
        ),
        Text(
          starRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: sizes,
            fontWeight: fontWeight,
          ),
        )
      ],
    );
  }
}
