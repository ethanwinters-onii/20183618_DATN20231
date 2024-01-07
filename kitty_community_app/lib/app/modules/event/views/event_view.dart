import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/core/utils/extensions/datetime_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/string_extension.dart';
import 'package:kitty_community_app/app/data/models/event_model/event_model.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';

import '../controllers/event_controller.dart';

class EventView extends GetView<EventController> {
  const EventView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<EventController>(
      appBar: AppBar(
        title: const Text(
          'Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric( vertical: 12, horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.accountLocal.role == "1")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "My Events",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.CREATE_EVENT);
                            },
                            child: const Icon(
                              Icons.add,
                              color: primaryColor,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    StreamBuilder(
                        stream: FirebaseProvider.streamUserEvent(
                            controller.accountLocal.userId ?? ""),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              List<EventModel> events = [];
                              for (var i in data!) {
                                logger.d(i.data());
                                events.add(EventModel.fromJson(i.data()));
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ...events.map((e) => EventItem(
                                          e: e,
                                        ))
                                  ],
                                ),
                              );
                          }
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/ic_planner.png",
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Will participate",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: [
                      ...controller.eventWillParticipate.map((e) => EventItem(
                            e: e,
                            nameButton: "Interested",
                            participated: true,
                            callback: () => controller.handleDeclineEvent(e),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/ic_event.png",
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Maybe you are interested",
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              Obx(
                () => Wrap(
                  runSpacing: 8,
                  children: [
                    ...controller.eventMayBe.map((e) => EventItem(
                          e: e,
                          nameButton: "Take interest",
                          participated: false,
                          callback: () => controller.handleParticipateEvent(e),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  EventItem(
      {super.key, required this.e, this.nameButton, this.participated = false, this.callback});

  final EventModel e;
  String? nameButton;
  bool participated;
  VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 46.w,
        height: 53.w,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: e.bgImage ?? "",
              errorWidget: (context, url, error) =>
                  const Icon(Icons.lock_clock),
              fit: BoxFit.cover,
              width: 46.w,
              height: 25.w,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "${e.eventTime?.replaceAll(" ", "")} ${e.eventDate!.toDateTime().toCustomFormat("dd/MM/yyyy")}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                e.eventName ?? "",
                style: TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: callback,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: nameButton == null ? 32.w : 42.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            nameButton == null
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    participated == true
                                        ? Icons.star
                                        : Icons.star_outline,
                                    color: participated == true
                                        ? customBlueColor
                                        : Colors.black,
                                  ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              nameButton ?? "Participants",
                              style: TextStyle(
                                  fontSize: 10.sp, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (nameButton == null)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            e.eventMembers?.length.toString() ?? "0",
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
