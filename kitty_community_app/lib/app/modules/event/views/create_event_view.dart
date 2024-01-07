import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/main_layout.dart';
import 'package:kitty_community_app/app/core/theme/color_theme.dart';
import 'package:kitty_community_app/app/global_widgets/app_button.dart';
import 'package:kitty_community_app/app/modules/event/controllers/create_event_controller.dart';
import 'package:kitty_community_app/app/modules/event/widgets/event_background.dart';
import 'package:kitty_community_app/app/modules/event/widgets/event_textfield.dart';
import 'package:sizer/sizer.dart';

class CreateEventView extends GetView<CreateEventController> {
  const CreateEventView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout<CreateEventController>(
      appBar: AppBar(
        title: const Text('Add new event'),
        centerTitle: true,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => EventBackground(
                callback: () {
                  controller.handleSelectPhoto();
                },
                imagePath: controller.photoPath.value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: CachedNetworkImage(
                          imageUrl: controller.accountLocal.avatar ?? "",
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.accountLocal.name ?? "",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Organizer",
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    EventTextField(
                      labelText: "Event name",
                      txtController: controller.nameEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Event name can not be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            controller.showDatePickerDialog(context);
                          },
                          child: EventTextField(
                            labelText: "Start day",
                            txtController: controller.dateEditingController,
                            readOnly: true,
                            prefixIcon: const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            controller.showTimePickerDialog(context);
                          },
                          child: EventTextField(
                            labelText: "Time begin",
                            txtController: controller.timeEditingController,
                            readOnly: true,
                            prefixIcon: const Icon(
                              Icons.schedule,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    EventTextField(
                      labelText: "Address",
                      txtController: controller.addressEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Address can not be empty";
                        }
                        return null;
                      }
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    EventTextField(
                      labelText: "Description",
                      txtController: controller.descriptionEditingController,
                      maxLine: 5,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description can not be empty";
                        }
                        return null;
                      }
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                  callback: controller.handleCreateEvent,
                  width: 100.w,
                  height: 6.h,
                  label: "Create +"),
            )
          ],
        ),
      ),
    );
  }
}
