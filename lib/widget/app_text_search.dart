import 'package:flutter/material.dart';

import '../core/pallete.dart';

class AppTextSearch extends StatelessWidget {
  final String hintText;
  final Widget? icon;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;

  const AppTextSearch(
      {this.hintText = 'Search ...',
      this.controller,
      super.key,
      this.icon,
      this.onTap,
      this.suffixIcon,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: TextField(
          enabled: onTap == null,
          controller: controller,
          style: const TextStyle(
            fontSize: 13, // Ukuran font teks
            height: 1.4, // Jarak baris teks
          ),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            isDense: true,
            hintStyle: const TextStyle(
              color: Pallete.grey2,
              fontSize: 13,
            ),
            prefixIcon: icon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 60, // Atur lebar minimum
              minHeight: 25, // Atur tinggi minimum
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 60, // Atur lebar minimum
              minHeight: 1, // Atur tinggi minimum
            ),
            filled: true,
            fillColor: Pallete.black1,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Theme.of(context).dividerTheme.color!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Theme.of(context).dividerTheme.color!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Theme.of(context).dividerTheme.color!),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Theme.of(context).dividerTheme.color!),
            ),
          ),
        ),
      ),
    );
  }
}
