import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:dot_cast/dot_cast.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:elastic_dashboard/services/ip_address_util.dart';
import 'package:elastic_dashboard/services/nt_connection.dart';
import 'package:elastic_dashboard/services/settings.dart';
import 'package:elastic_dashboard/services/text_formatter_builder.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_color_picker.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_dropdown_chooser.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_toggle_switch.dart';

class SettingsDialog extends StatefulWidget {
  final NTConnection ntConnection;

  static final List<String> themeVariants = FlexSchemeVariant.values
      .whereNot((variant) => variant == Defaults.themeVariant)
      .map((variant) => variant.variantName)
      .toList()
    ..add(Defaults.defaultVariantName)
    ..sort();

  final SharedPreferences preferences;

  final Function(String? data)? onIPAddressChanged;
  final Function(String? data)? onTeamNumberChanged;
  final Function(IPAddressMode mode)? onIPAddressModeChanged;
  final Function(Color color)? onColorChanged;
  final Function(bool value)? onGridToggle;
  final Function(String? gridSize)? onGridSizeChanged;
  final Function(String? radius)? onCornerRadiusChanged;
  final Function(bool value)? onResizeToDSChanged;
  final Function(bool value)? onRememberWindowPositionChanged;
  final Function(bool value)? onLayoutLock;
  final Function(String? value)? onDefaultPeriodChanged;
  final Function(String? value)? onDefaultGraphPeriodChanged;
<<<<<<< HEAD
  final Function(bool value)? onAutoSaveChanged;
  final Function(bool value)? onAutoSwitchTabsChanged;

  const SettingsDialog(
      {super.key,
      required this.preferences,
      this.onTeamNumberChanged,
      this.onIPAddressModeChanged,
      this.onIPAddressChanged,
      this.onColorChanged,
      this.onGridToggle,
      this.onGridSizeChanged,
      this.onCornerRadiusChanged,
      this.onResizeToDSChanged,
      this.onRememberWindowPositionChanged,
      this.onLayoutLock,
      this.onDefaultPeriodChanged,
      this.onDefaultGraphPeriodChanged,
      this.onAutoSaveChanged,
      this.onAutoSwitchTabsChanged});
=======
  final Function(FlexSchemeVariant variant)? onThemeVariantChanged;

  const SettingsDialog({
    super.key,
    required this.ntConnection,
    required this.preferences,
    this.onTeamNumberChanged,
    this.onIPAddressModeChanged,
    this.onIPAddressChanged,
    this.onColorChanged,
    this.onGridToggle,
    this.onGridSizeChanged,
    this.onCornerRadiusChanged,
    this.onResizeToDSChanged,
    this.onRememberWindowPositionChanged,
    this.onLayoutLock,
    this.onDefaultPeriodChanged,
    this.onDefaultGraphPeriodChanged,
    this.onThemeVariantChanged,
  });
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: Container(
        constraints: const BoxConstraints(
<<<<<<< HEAD
          maxHeight: 400,
=======
          maxHeight: 350,
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
          maxWidth: 725,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ..._generalSettings(),
                ],
              ),
            ),
            const VerticalDivider(),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...allRobotSettings(),
                  const Divider(),
                  ..._networkTablesSettings(),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  List<Widget> _robotPerf() {
    Color currentColor = Color(widget.preferences.getInt(PrefKeys.teamColor) ??
        Colors.blueAccent.value);

    // Safety feature to prevent theme variants dropdown from not rendering if the current selection doesn't exist
    List<String>? themeVariantsOverride;
    if (!SettingsDialog.themeVariants
            .contains(widget.preferences.getString(PrefKeys.themeVariant)) &&
        widget.preferences.getString(PrefKeys.themeVariant) != null) {
      // Weird way of copying the list
      themeVariantsOverride = SettingsDialog.themeVariants.toList()
        ..add(widget.preferences.getString(PrefKeys.themeVariant)!)
        ..sort();
      themeVariantsOverride = Set.of(themeVariantsOverride).toList();
    }

    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                child: DialogTextInput(
                  initialText: widget.preferences
                          .getInt(PrefKeys.teamNumber)
                          ?.toString() ??
                      Defaults.teamNumber.toString(),
                  label: 'Team Number',
                  onSubmit: (data) async {
                    await widget.onTeamNumberChanged?.call(data);
                    setState(() {});
                  },
                  formatter: FilteringTextInputFormatter.digitsOnly,
                ),
              ),
              Expanded(
                child: DialogColorPicker(
                  onColorPicked: (color) => widget.onColorChanged?.call(color),
                  label: 'Team Color',
                  initialColor: currentColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Theme Variant'),
              const SizedBox(width: 5),
              Flexible(
                child: DialogDropdownChooser<String>(
                    onSelectionChanged: (variantName) {
                      if (variantName == null) return;
                      FlexSchemeVariant variant = FlexSchemeVariant.values
                              .firstWhereOrNull(
                                  (e) => e.variantName == variantName) ??
                          FlexSchemeVariant.material3Legacy;

                      widget.onThemeVariantChanged?.call(variant);
                      setState(() {});
                    },
                    choices:
                        themeVariantsOverride ?? SettingsDialog.themeVariants,
                    initialValue:
                        widget.preferences.getString(PrefKeys.themeVariant) ??
                            Defaults.defaultVariantName),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<Widget> allRobotSettings() {
    return [
      const Align(
        alignment: Alignment.topLeft,
        child: Text("Robot Settings",
            style: TextStyle(
              fontSize: 20.0,
            )),
      ),
      const Divider(),
      const SizedBox(height: 5),
      ..._robotPerf(),
      const Divider(),
      const SizedBox(height: 5),
      const Align(
        alignment: Alignment.topLeft,
        child: Text('IP Address Settings'),
      ),
      const SizedBox(height: 5),
      const Text('IP Address Mode'),
      DialogDropdownChooser<IPAddressMode>(
        onSelectionChanged: (mode) {
          if (mode == null) {
            return;
          }

          widget.onIPAddressModeChanged?.call(mode);

          setState(() {});
        },
        choices: IPAddressMode.values,
        initialValue: IPAddressMode.fromIndex(
            widget.preferences.getInt(PrefKeys.ipAddressMode)),
      ),
      const SizedBox(height: 5),
      StreamBuilder(
          stream: widget.ntConnection.dsConnectionStatus(),
          initialData: widget.ntConnection.isDSConnected,
          builder: (context, snapshot) {
            bool dsConnected = tryCast(snapshot.data) ?? false;

            return DialogTextInput(
              enabled: widget.preferences.getInt(PrefKeys.ipAddressMode) ==
                      IPAddressMode.custom.index ||
                  (widget.preferences.getInt(PrefKeys.ipAddressMode) ==
                          IPAddressMode.driverStation.index &&
                      !dsConnected),
              initialText: widget.preferences.getString(PrefKeys.ipAddress) ??
                  Defaults.ipAddress,
              label: 'IP Address',
              onSubmit: (String? data) async {
                await widget.onIPAddressChanged?.call(data);
                setState(() {});
              },
            );
          })
    ];
  }

  List<Widget> _generalSettings() {
    return [
      const Align(
          alignment: Alignment.topLeft,
          child: Text("General Settings", style: TextStyle(fontSize: 20.0))),
      const Divider(),
      const Align(
        alignment: Alignment.topLeft,
        child: Text('Grid Settings'),
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: DialogToggleSwitch(
<<<<<<< HEAD
              initialValue: widget.preferences.getBool(PrefKeys.snapToGrid) ??
                  Settings.snapToGrid,
              label: 'Snap To Grid',
=======
              initialValue: widget.preferences.getBool(PrefKeys.showGrid) ??
                  Defaults.showGrid,
              label: 'Show Grid',
>>>>>>> 8d8667119a03e9f68a44f6d693542ab070c13126
              onToggle: (value) {
                setState(() {
                  widget.onGridToggle?.call(value);
                });
              },
            ),
          ),
          Flexible(
            child: DialogTextInput(
              initialText:
                  widget.preferences.getInt(PrefKeys.gridSize)?.toString() ??
                      Defaults.gridSize.toString(),
              label: 'Grid Size',
              onSubmit: (value) async {
                await widget.onGridSizeChanged?.call(value);
                setState(() {});
              },
              formatter: FilteringTextInputFormatter.digitsOnly,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            child: DialogTextInput(
              initialText:
                  (widget.preferences.getDouble(PrefKeys.cornerRadius) ??
                          Defaults.cornerRadius.toString())
                      .toString(),
              label: 'Corner Radius',
              onSubmit: (value) {
                setState(() {
                  widget.onCornerRadiusChanged?.call(value);
                });
              },
              formatter: TextFormatterBuilder.decimalTextFormatter(),
            ),
          ),
          Flexible(
            flex: 3,
            child: DialogToggleSwitch(
              initialValue:
                  widget.preferences.getBool(PrefKeys.autoResizeToDS) ??
                      Defaults.autoResizeToDS,
              label: 'Resize to Driver Station Height',
              onToggle: (value) {
                setState(() {
                  widget.onResizeToDSChanged?.call(value);
                });
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 5,
            child: DialogToggleSwitch(
              initialValue:
                  widget.preferences.getBool(PrefKeys.rememberWindowPosition) ??
                      false,
              label: 'Remember Window Position',
              onToggle: (value) {
                setState(() {
                  widget.onRememberWindowPositionChanged?.call(value);
                });
              },
            ),
          ),
          Flexible(
            flex: 4,
            child: DialogToggleSwitch(
              initialValue: widget.preferences.getBool(PrefKeys.layoutLocked) ??
                  Defaults.layoutLocked,
              label: 'Lock Layout',
              onToggle: (value) {
                setState(() {
                  widget.onLayoutLock?.call(value);
                });
              },
            ),
          ),
        ],
      ),
      const Divider(),
      const Align(
        alignment: Alignment.topLeft,
        child: Text('Preferences'),
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 4,
            child: DialogToggleSwitch(
              initialValue:
                  widget.preferences.getBool(PrefKeys.autoSwitchTabs) ??
                      Settings.autoSwitchTabs,
              label: 'Auto-Switch tabs',
              onToggle: (value) {
                setState(() {
                  Settings.set('autoSwitchTabs', value);
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Auto-Switch Tabs Info'),
                    content: const Text(
                        'Will automatically switch between tabs according to the according state of the robot: \n\t - Disabled \n\t - Autonomous \n\t - Teleoperated \n\t - Test \n\n * Will not switch if a tab with the according name does not exist.'),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      )
    ];
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _networkTablesSettings() {
    return [
      const Align(
        alignment: Alignment.topLeft,
        child: Text('Network Tables Settings'),
      ),
      const SizedBox(height: 5),
      Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: DialogTextInput(
                initialText:
                    (widget.preferences.getDouble(PrefKeys.defaultPeriod) ??
                            Defaults.defaultPeriod)
                        .toString(),
                label: 'Default Period',
                onSubmit: (value) async {
                  await widget.onDefaultPeriodChanged?.call(value);
                  setState(() {});
                },
                formatter: TextFormatterBuilder.decimalTextFormatter(),
              ),
            ),
            Flexible(
              child: DialogTextInput(
                initialText: (widget.preferences
                            .getDouble(PrefKeys.defaultGraphPeriod) ??
                        Defaults.defaultGraphPeriod)
                    .toString(),
                label: 'Default Graph Period',
                onSubmit: (value) async {
                  widget.onDefaultGraphPeriodChanged?.call(value);
                  setState(() {});
                },
                formatter: TextFormatterBuilder.decimalTextFormatter(),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
