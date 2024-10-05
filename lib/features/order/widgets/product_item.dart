import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final Color bgColor;
  final Color textColor;
  final FontWeight fontWeight;
  final bool border;

  const ProductItem({
    super.key,
    required this.onPressed,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.fontWeight,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onPressed,
      // () => isDelivery.value = true,
      backgroundColor: bgColor,
      // isDelivery.value ? Colors.white : AppColors.secondaryColor,
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          // color: isDelivery.value ? AppColors.secondaryColor : Colors.white,
          // fontWeight: isDelivery.value ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: border ? Colors.white : bgColor,
        ),
      ),
    );
  }
}
