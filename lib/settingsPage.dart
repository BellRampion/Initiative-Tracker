// ignore_for_file: file_names

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  Color? selectedColor;
  bool darkMode;
  SettingsPage({super.key, required this.darkMode});

  @override
  State<StatefulWidget> createState() => SettingsPageState();

    
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text("Settings"),
      ),
      // Show the color picker in sized box in a raised card.
      body: Column(
        children: [
          // TextButton(
          //   style: const ButtonStyle(
          //     elevation: MaterialStatePropertyAll<double>(6),
          //   ),
          //   onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(useSystem: false),
          //   child: const Text("Toggle Dark Mode"),
          // ),
          Switch(
            value: widget.darkMode,
            onChanged: (value) {
              setState(() {
                widget.darkMode = value;
                AdaptiveTheme.of(context).setThemeMode(value ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light);
              });
            },
          ),
          // Pick color in a dialog.
          ListTile(
            title: const Text('Click this color to change it in a dialog'),
            trailing: ColorIndicator(
              borderRadius: 4,
              color: widget.selectedColor ?? AdaptiveTheme.of(context).theme.colorScheme.primary,
              onSelectFocus: false,
              onSelect: () async {
                // Store current color before we open the dialog.
                final Color colorBeforeDialog = widget.selectedColor ?? AdaptiveTheme.of(context).theme.colorScheme.primary;
                // Wait for the picker to close, if dialog was dismissed, 
                // then restore the color we had before it was opened.
                if (!(await colorPickerDialog(context))) {
                  setState(() {
                    AdaptiveTheme.of(context).setTheme(
                      light: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: colorBeforeDialog,
                      ),
                      dark: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: colorBeforeDialog,
                      ),
                    ); 
                  });
                }
                else {
                  setState(() {
                    AdaptiveTheme.of(context).setTheme(
                      light: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: widget.selectedColor,
                      ),
                      dark: ThemeData(
                        useMaterial3: true,
                        colorSchemeSeed: widget.selectedColor,
                      ),
                    ); 
                  });
                }

              },
            ),
          ),          
        ]
      ),
    );
  }

  Future<bool> colorPickerDialog(BuildContext context) async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: widget.selectedColor ?? AdaptiveTheme.of(context).theme.colorScheme.primary,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => widget.selectedColor = color),
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context,
          Animation<double> a1,
          Animation<double> a2,
          Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(
              0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
  
}