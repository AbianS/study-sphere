import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/password_icon_provider.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isValid;
  final int maxLines;
  final bool showIconHide;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool readOnly;

  const CustomTextFormField(
      {super.key,
      this.label,
      this.hint,
      this.errorMessage,
      this.obscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.isValid = false,
      this.maxLines = 1,
      this.keyboardType,
      this.showIconHide = false,
      this.focusNode,
      this.initialValue,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    return ChangeNotifierProvider(
        create: (context) => PasswordIconProvider(),
        child: Consumer<PasswordIconProvider>(
          builder: (context, ref, child) {
            return TextFormField(
              readOnly: readOnly,
              initialValue: initialValue,
              focusNode: focusNode,
              keyboardType: keyboardType,
              maxLines: maxLines,
              onChanged: onChanged,
              validator: validator,
              obscureText: showIconHide ? !ref.showPassword : obscureText,
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                suffixIcon: showIconHide
                    ? GestureDetector(
                        onTap: ref.toggleVisibility,
                        child: Icon(
                          ref.showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )
                    : isValid
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : null,
                isDense: true,
                errorText: errorMessage,
                hintText: hint,
                enabledBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: isValid ? Colors.green : Colors.grey,
                  ),
                ),
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: isValid ? Colors.green : Colors.grey,
                  ),
                ),
                errorBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
