import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isPassword;
  final String? hint;
  final bool? enabled;
  final TextStyle? textStyle;
  final int? maxLines, minLines, maxLength;
  final String? obscuringCharacter, value;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged, onFieldSubmitted, onSaved;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget;
  final IconData? icon;
  final TextInputAction? action;
  final FocusNode? focusNode;
  final Color? hintColor;
  final TextDirection? textDirection;
  final EdgeInsets? edgeInsets;
  final double? borderRadius;
  final bool? enableSuggestions;
  final String text;

  const CustomTextFormField({
    super.key,
    required this.text,
    this.controller,
    this.isPassword,
    this.hint,
    this.textStyle,
    this.enableSuggestions,
    this.enabled,
    this.obscuringCharacter,
    this.value,
    this.onValidate,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.suffixWidget,
    this.icon,
    this.action,
    this.focusNode,
    this.textDirection,
    this.edgeInsets = const EdgeInsets.only(
      top: 14,
      left: 16,
      right: 16,
      bottom: 14,
    ),
    this.hintColor = Colors.white,
    this.borderRadius
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Wrap(
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),
        TextFormField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          textDirection: widget.textDirection,
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.center,
          initialValue: widget.value,
          validator: widget.onValidate,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          onTap: widget.onTap,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          obscureText: widget.isPassword ?? false ? obscureText : false,
          obscuringCharacter: '*',
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          enableSuggestions: widget.enableSuggestions ?? false,
          style: widget.textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF222222), fontWeight: FontWeight.w500),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: widget.action ?? TextInputAction.done,
          focusNode: widget.focusNode,
          cursorColor: theme.primaryColor,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword ?? false
                ? InkWell(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  )
                : widget.suffixWidget,
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 15,
              color: widget.hintColor,
            ),
            counterText: "",
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
              borderSide: const BorderSide(
                color: AppColors.grey,
                width: 2,
              ),
            ),
            contentPadding: widget.edgeInsets,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
              borderSide: const BorderSide(
                color: AppColors.grey,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
              borderSide: const BorderSide(
                color: AppColors.grey,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
              borderSide: const BorderSide(
                color: AppColors.grey,
                width: 2,
              ),
            ),
        
            errorStyle: const TextStyle(
              color: Color(0xFFCC0000),
              fontSize: 12,
            ),
            errorMaxLines: 6,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFCC0000),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
