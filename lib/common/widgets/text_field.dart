import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SdTextField extends StatelessWidget {
  final String label;
  final String? value;
  final void Function(String)? onChanged;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final bool readOnly;
  final bool enabled;
  final int? numberOfLines;
  final bool isRequired;
  final List<TextInputFormatter> formatters;
  final Color? borderColor;
  final double? borderRadius;
  final TextStyle? labelStyle;
  final Function(String?)? validator;

  const SdTextField({
    super.key,
    required this.label,
    this.value,
    this.numberOfLines,
    this.enabled = true,
    this.isRequired = false,
    this.onChanged,
    required this.textInputType,
    this.textEditingController,
    this.formatters = const <TextInputFormatter>[],
    this.readOnly = false,
    this.borderColor,
    this.borderRadius,
    this.labelStyle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      inputFormatters: [...formatters],
      key: Key(label.replaceAll(' ', "_")),
      readOnly: readOnly,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      minLines: numberOfLines ?? 1,
      maxLines: numberOfLines ?? 8,
      controller: textEditingController,
      cursorColor: Colors.blue,
      cursorOpacityAnimates: true,
      initialValue: (value != null && value is int)
          ? value.toString().trim().replaceAll('.', '').replaceAll('.', '')
          : value,
      onChanged: onChanged,
      keyboardType: textInputType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 25)),
          borderSide:
              BorderSide(width: 2, color: borderColor ?? Colors.grey.shade200),
        ),
        labelStyle: labelStyle ?? const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
        ),
        label: isRequired
            ? Row(
                children: [
                  Text(label),
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              )
            : Text(label),
      ),
      validator: validator != null
          ? (value) {
              validator!(value);
              return null;
            }
          : null,
    );
  }
}
