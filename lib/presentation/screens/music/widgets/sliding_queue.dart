import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';

/// The play queue from the playing track on (or after it, without [showCurrent]). When the playing track moves
/// ahead – a skip or a tap on a later track – the tracks in between slide out at the top and the rest moves up.
class SlidingQueue extends StatefulWidget {
  const SlidingQueue({
    super.key,
    required this.items,
    required this.currentTitle,
    required this.itemExtent,
    required this.itemBuilder,
    this.showCurrent = true,
    this.maxItems,
  });

  final List<QueueItem> items;
  final String? currentTitle;
  final double itemExtent;
  final Widget Function(BuildContext context, QueueItem item, {required bool current}) itemBuilder;
  final bool showCurrent;

  /// Rows shown at most, without scrolling; `null`: all, scrollable.
  final int? maxItems;

  @override
  State<SlidingQueue> createState() => _SlidingQueueState();
}

class _SlidingQueueState extends State<SlidingQueue> with SingleTickerProviderStateMixin {
  late final _slide = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final _curve = CurvedAnimation(parent: _slide, curve: Curves.easeInOutCubic);

  /// What is shown: the queue and the first row. While sliding, the rows before the new first one are still there.
  late List<QueueItem> _items = widget.items;
  late int _start = _startOf(widget.items, widget.currentTitle);
  var _leaving = 0;

  int _startOf(List<QueueItem> items, String? title) {
    final current = items.indexWhere((item) => item.title == title);
    return current < 0 ? 0 : current + (widget.showCurrent ? 0 : 1);
  }

  @override
  void didUpdateWidget(SlidingQueue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items == oldWidget.items && widget.currentTitle == oldWidget.currentTitle) return;
    // The new playing track further down in what is shown: slide there, then take the new queue.
    final ahead = _items.indexWhere((item) => item.title == widget.currentTitle, _start) - _start;
    final leaving = ahead + (widget.showCurrent ? 0 : 1);
    if (!_slide.isAnimating && ahead >= 0 && leaving > 0) {
      setState(() => _leaving = leaving);
      _slide.forward(from: 0).whenComplete(_settle);
    } else if (!_slide.isAnimating) {
      _settle();
    }
  }

  void _settle() {
    if (!mounted) return;
    setState(() {
      _items = widget.items;
      _start = _startOf(widget.items, widget.currentTitle);
      _leaving = 0;
    });
  }

  @override
  void dispose() {
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rest = math.max(0, _items.length - _start);
    final count = math.min(rest, (widget.maxItems ?? rest) + _leaving);
    final sliding = _leaving > 0;
    return ClipRect(
      child: AnimatedBuilder(
        animation: _curve,
        builder: (context, child) =>
            Transform.translate(offset: Offset(0, -_leaving * widget.itemExtent * _curve.value), child: child),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemExtent: widget.itemExtent,
          itemCount: count,
          // The rows that move up from below are built ahead of time.
          scrollCacheExtent: ScrollCacheExtent.pixels((_leaving + 1) * widget.itemExtent),
          physics: sliding || widget.maxItems != null ? const NeverScrollableScrollPhysics() : null,
          itemBuilder: (context, index) {
            final item = _items[_start + index];
            final row = widget.itemBuilder(context, item, current: item.title == widget.currentTitle);
            if (index >= _leaving) return row;
            return FadeTransition(opacity: ReverseAnimation(_curve), child: row);
          },
        ),
      ),
    );
  }
}
