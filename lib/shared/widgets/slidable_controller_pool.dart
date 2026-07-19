import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableControllerPool extends StatefulWidget {
  final Widget child;
  const SlidableControllerPool({super.key, required this.child});

  static SlidableControllerPoolState of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_SlidablePoolScope>();
    return scope!.state;
  }

  @override
  State<SlidableControllerPool> createState() => SlidableControllerPoolState();
}

class _SlidablePoolScope extends InheritedWidget {
  final SlidableControllerPoolState state;
  const _SlidablePoolScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(_SlidablePoolScope oldWidget) => false;
}

class SlidableControllerPoolState extends State<SlidableControllerPool>
    with TickerProviderStateMixin {
  final Map<String, SlidableController> _map = {};

  SlidableController of(String id) =>
      _map.putIfAbsent(id, () => SlidableController(this));

  void close(String id) => _map[id]?.close();

  @override
  void dispose() {
    for (final c in _map.values) {
      c.dispose();
    }
    _map.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _SlidablePoolScope(state: this, child: widget.child);
}
