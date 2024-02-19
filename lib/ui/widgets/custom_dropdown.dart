import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final TextEditingController? controller;

  const CustomDropdown({
    super.key,
    required this.items,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: DropdownMenu(
        controller: controller,
        width: MediaQuery.of(context).size.width - 40,
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => Palette.dropdownBackground),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Palette.lightGreen,
          filled: true,
          fillColor: Palette.lightGreen,
          border: InputBorder.none,
        ),
        enableFilter: false,
        enableSearch: false,
        leadingIcon: const Icon(Icons.arrow_drop_down),
        trailingIcon: const Text(""),
        initialSelection: items.first,
        dropdownMenuEntries: items.map<DropdownMenuEntry<String>>((value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),
    );
  }
}
