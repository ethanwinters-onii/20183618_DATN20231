import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'dart:math' as math;

import 'package:kitty_community_app/app/modules/wrap/controllers/wrap_controller.dart';
import 'package:rive/rive.dart';

class FabExpandable extends GetView<WrapController> {
  const FabExpandable(
      {super.key, required this.distance, required this.children});
  final double distance;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    print(children.length);
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            _buildTapToCloseFab(context),
            ..._buildExpandingActionButtons(),
            _buildTapToOpenFab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    // print(controller.isFabExpand.value);
    return Obx(
      () => IgnorePointer(
        ignoring: controller.isFabExpand.value,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            controller.isFabExpand.value ? 0.7 : 1.0,
            controller.isFabExpand.value ? 0.7 : 1.0,
            1.0,
          ),
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          child: AnimatedOpacity(
            opacity: controller.isFabExpand.value ? 0.0 : 1.0,
            curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
            duration: const Duration(milliseconds: 250),
            child: SizedBox(
              width: 72,
              height: 72,
              child: FloatingActionButton.large(
                onPressed: controller.toggleFab,
                backgroundColor: secondaryColor,
                shape: const CircleBorder(),
                child: const SizedBox(
                  width: 64,
                  height: 64,
                  child: RiveAnimation.asset(AssetsContants.kitty_login),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToCloseFab(BuildContext context) {
    return SizedBox(
      width: 72.0,
      height: 72.0,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: InkWell(
          onTap: controller.toggleFab,
          child: Icon(
            Icons.close,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final widgets = <Widget>[];
    final count = children.length;
    print(count);
    // final step = 160.0 / (count - 1);
    const step = 60.0;
    for (var i = 0, angleInDegrees = 30.0;
        i < count;
        i++, angleInDegrees += step) {
      widgets.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: distance,
          progress: controller.expandAnimation,
          child: children[i],
        ),
      );
    }
    return widgets;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          // right: 12.0 + offset.dx,
          bottom: 8.0 + offset.dy,
          left: 190.0 + offset.dx,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
