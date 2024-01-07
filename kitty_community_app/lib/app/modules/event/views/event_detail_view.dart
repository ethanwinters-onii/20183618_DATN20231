import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/modules/event/controllers/event_detail_controller.dart';
import 'package:sizer/sizer.dart';

class EventDetailView extends GetView<EventDetailController> {
  const EventDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<EventDetailController>(
      appBar: AppBar(
        title: const Text('Event'),
        centerTitle: true,
      ),
      child: Column(
        children: [],
      ),
    );
  }
}
