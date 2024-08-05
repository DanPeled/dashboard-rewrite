import 'package:elastic_dashboard/services/hotkey_manager.dart';
import 'package:flutter/material.dart';

class ShortcutView extends StatefulWidget {
  final HotKey? hotkey;
  final String title;

  const ShortcutView({super.key, this.hotkey, required this.title});

  @override
  State<StatefulWidget> createState() => _ShortcutViewState();
}

class _ShortcutViewState extends State<ShortcutView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String keys = "";
    if (widget.hotkey != null) {
      keys = ": ";
      if (widget.hotkey!.modifiers != null) {
        for (int i = 0; i < widget.hotkey!.modifiers!.length; i++) {
          if (i > 0) {
            keys += " + ";
          }

          keys += getModifierKeyName(widget.hotkey!.modifiers![i]);
        }
      }

      keys +=
          " + ${widget.hotkey!.logicalKey.debugName?.replaceAll("Key ", "")}";
    }

    return Text("${widget.title} $keys");
  }

  String getModifierKeyName(KeyModifier modifier) {
    if (modifier == KeyModifier.control) {
      return "Control";
    } else if (modifier == KeyModifier.alt) {
      return "Alt";
    } else if (modifier == KeyModifier.shift) {
      return "Shift";
    }

    return "unKnown";
  }
}
