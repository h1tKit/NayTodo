import 'package:flutter/material.dart';
import 'package:naytodo/shared/widgets/page_background.dart';

class BackgroundEditResult {
  final Offset focus;
  final double scale;

  const BackgroundEditResult({required this.focus, required this.scale});
}

class BackgroundEditorPage extends StatefulWidget {
  final String imagePath;
  final Offset initialFocus;
  final double initialScale;

  const BackgroundEditorPage({
    super.key,
    required this.imagePath,
    this.initialFocus = const Offset(0.5, 0.5),
    this.initialScale = 1.0,
  });

  @override
  State<BackgroundEditorPage> createState() => _BackgroundEditorPageState();
}

class _BackgroundEditorPageState extends State<BackgroundEditorPage> {
  late Offset _focus;
  late double _scale;
  late double _gestureScale;
  Offset? _lastFocalPoint;

  @override
  void initState() {
    super.initState();
    _focus = widget.initialFocus;
    _scale = widget.initialScale;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _gestureScale = _scale;
    _lastFocalPoint = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size viewport) {
    final lastFocalPoint = _lastFocalPoint ?? details.localFocalPoint;
    final delta = details.localFocalPoint - lastFocalPoint;
    _lastFocalPoint = details.localFocalPoint;

    setState(() {
      _scale = (_gestureScale * details.scale).clamp(1.0, 4.0);
      final width = viewport.width * _scale;
      final height = viewport.height * _scale;
      _focus = Offset(
        (_focus.dx - delta.dx / width).clamp(0.0, 1.0),
        (_focus.dy - delta.dy / height).clamp(0.0, 1.0),
      );
    });
  }

  void _reset() {
    setState(() {
      _focus = const Offset(0.5, 0.5);
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('调整背景'),
        actions: [
          IconButton(
            tooltip: '重置',
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: '完成',
            onPressed: () {
              Navigator.of(
                context,
              ).pop(BackgroundEditResult(focus: _focus, scale: _scale));
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = constraints.biggest;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, viewport),
            onScaleEnd: (_) => _lastFocalPoint = null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PositionedBackgroundImage(
                  imagePath: widget.imagePath,
                  focus: _focus,
                  scale: _scale,
                ),
                const IgnorePointer(
                  child: Center(
                    child: Icon(
                      Icons.control_camera_outlined,
                      color: Colors.white70,
                      size: 32,
                    ),
                  ),
                ),
                const Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: IgnorePointer(
                    child: Text(
                      '拖动调整位置，双指缩放图片',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
