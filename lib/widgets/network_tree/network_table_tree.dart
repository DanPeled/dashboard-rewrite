import 'dart:ui';

import 'package:elastic_dashboard/services/nt4.dart';
import 'package:elastic_dashboard/services/nt4_connection.dart';
import 'package:elastic_dashboard/widgets/draggable_widget_container.dart';
import 'package:elastic_dashboard/widgets/network_tree/tree_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class NetworkTableTree extends StatefulWidget {
  final Function(Offset globalPosition, WidgetContainer widget)? onDragUpdate;
  final Function(WidgetContainer widget)? onDragEnd;

  const NetworkTableTree({super.key, this.onDragUpdate, this.onDragEnd});

  @override
  State<NetworkTableTree> createState() => _NetworkTableTreeState();
}

class _NetworkTableTreeState extends State<NetworkTableTree> {
  final TreeRow root = TreeRow(topic: '/', rowName: '');
  late final TreeController<TreeRow> treeController;

  late final Function(Offset globalPosition, WidgetContainer widget)?
      onDragUpdate;
  late final Function(WidgetContainer widget)? onDragEnd;

  @override
  void initState() {
    super.initState();

    treeController = TreeController<TreeRow>(
        roots: root.children, childrenProvider: (node) => node.children);

    onDragUpdate = widget.onDragUpdate;
    onDragEnd = widget.onDragEnd;
  }

  void createRows(NT4Topic nt4Topic) {
    String topic = nt4Topic.name;

    List<String> rows = topic.substring(1).split('/');
    TreeRow? current;
    String currentTopic = '';

    for (String row in rows) {
      currentTopic += '/$row';

      bool lastElement = currentTopic == topic;

      if (current != null) {
        if (current.hasRow(row)) {
          current = current.getRow(row);
        } else {
          current = current.createNewRow(
              topic: currentTopic,
              name: row,
              nt4Topic: (lastElement) ? nt4Topic : null);
        }
      } else {
        if (root.hasRow(row)) {
          current = root.getRow(row);
        } else {
          current = root.createNewRow(
              topic: currentTopic,
              name: row,
              nt4Topic: (lastElement) ? nt4Topic : null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<NT4Topic> topics = [];

    for (NT4Topic topic in nt4Connection.nt4Client.announcedTopics.values) {
      if (topic.name == 'Time') {
        continue;
      }

      topics.add(topic);
    }

    for (NT4Topic topic in topics) {
      createRows(topic);
    }

    root.sort();

    return TreeView<TreeRow>(
      treeController: treeController,
      nodeBuilder: (BuildContext context, TreeEntry<TreeRow> entry) {
        return TreeTile(
          key: UniqueKey(),
          entry: entry,
          onDragUpdate: onDragUpdate,
          onDragEnd: onDragEnd,
          onTap: () {
            setState(() => treeController.toggleExpansion(entry.node));
          },
        );
      },
    );
  }
}

class TreeTile extends StatelessWidget {
  TreeTile({
    super.key,
    required this.entry,
    required this.onTap,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final TreeEntry<TreeRow> entry;
  final VoidCallback onTap;
  final Function(Offset globalPosition, WidgetContainer widget)? onDragUpdate;
  final Function(WidgetContainer widget)? onDragEnd;

  WidgetContainer? draggingWidget;

  @override
  Widget build(BuildContext context) {
    TextStyle trailingStyle =
        Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: GestureDetector(
            onPanStart: (details) async {
              if (draggingWidget != null) {
                return;
              }

              // Prevents 2 finger drags from dragging a widget
              if (details.kind != null &&
                  details.kind! == PointerDeviceKind.trackpad) {
                draggingWidget = null;
                return;
              }

              draggingWidget = await entry.node.toWidgetContainer();
            },
            onPanUpdate: (details) {
              if (draggingWidget == null) {
                return;
              }

              onDragUpdate?.call(
                  details.globalPosition -
                      Offset(draggingWidget!.width, draggingWidget!.height) / 2,
                  draggingWidget!);
            },
            onPanEnd: (details) {
              if (draggingWidget == null) {
                return;
              }

              onDragEnd?.call(draggingWidget!);

              draggingWidget = null;
            },
            // onPanDown: (details) {},
            // onPanCancel: () {},
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: entry.level * 16.0),
              child: Column(
                children: [
                  ListTile(
                    style: ListTileStyle.drawer,
                    dense: true,
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    leading: (entry.hasChildren)
                        ? FolderButton(
                            openedIcon: const Icon(Icons.arrow_drop_down),
                            closedIcon: const Icon(Icons.arrow_right),
                            iconSize: 24,
                            isOpen: entry.hasChildren ? entry.isExpanded : null,
                            onPressed: entry.hasChildren ? onTap : null,
                          )
                        : const SizedBox(width: 8.0),
                    title: Text(entry.node.rowName),
                    trailing: (entry.node.nt4Topic != null)
                        ? Text(entry.node.nt4Topic!.type, style: trailingStyle)
                        : null,
                    // subtitle:
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}