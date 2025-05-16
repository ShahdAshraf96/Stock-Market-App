import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.buttonColor,
    this.icn,
    this.imgIcn,
    this.onTap
  });

  final String text;
  final Color? buttonColor;
  final IconData? icn;
  final String? imgIcn;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: buttonColor != null ? BorderSide.none : BorderSide(color: AppColors.grey)
        ),
      ),
      child: icn != null || imgIcn != null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: imgIcn == null ? Icon(icn, color: AppColors.red, size: 25,) : Image.asset(imgIcn!, height: 25.0)
          ),
          Expanded(
            flex: 6,
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.white,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ) : 
      Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.white,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
