import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../values/enums/status.dart';
import 'base_controller.dart';

class MainLayout<T extends BaseController> extends StatelessWidget {
  const MainLayout({
    this.appBar,
    this.mustSafeView = true,
    this.withImageBackground = false,
    required this.child,
    this.onClick,
    this.backgroundColor = Colors.transparent,
    Key? key,
    this.resizeToAvoidBottomInset,
    this.imageBackground,
    this.extendBody = true,
    this.indicator,
  }) : super(key: key);
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Function? onClick;
  final bool? mustSafeView;
  final bool? withImageBackground;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final Color backgroundColor;
  final Widget? indicator;
  final String? imageBackground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onBackgroundPress(context),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: Stack(
          children: [
            if (withImageBackground == true)
              Positioned.fill(
                  child: Image.asset(
                imageBackground ?? "",
                fit: BoxFit.cover,
              )),
            child,
            Positioned.fill(
              child: Obx(
                () => Visibility(
                  visible: Get.find<T>().getStatus() == Status.loading ||
                      Get.find<T>().getStatus() == Status.waiting,
                  child: indicator ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBackgroundPress(BuildContext context) {
    FocusScope.of(context).unfocus();
    onClick?.call();
  }
}
