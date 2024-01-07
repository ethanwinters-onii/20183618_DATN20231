import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/utils/extensions/datetime_extension.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/event_model/event_model.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/global_widgets/app_bottom_sheet.dart';
import 'package:kitty_community_app/app/global_widgets/custom_snack_bar.dart';
import 'package:kitty_community_app/app/modules/update_profile/widgets/image_picker_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

class CreateEventController extends BaseController {
  final AccountInfo accountLocal = AccountLocalHelper.get();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final dateEditingController = TextEditingController();
  final timeEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  Rx<String> photoPath = "".obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    dateEditingController.text =
        selectedDate.value.toCustomFormat("dd-MM-yyyy");
    timeEditingController.text = _toTimeFormat(selectedTime.value);
    setStatus(Status.success);
    return super.initialData();
  }

  void showDatePickerDialog(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      selectedDate.value = date;
      dateEditingController.text = date.toCustomFormat("dd-MM-yyyy");
    }
  }

  void showTimePickerDialog(BuildContext context) async {
    final time = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        initialEntryMode: TimePickerEntryMode.inputOnly);

    if (time != null) {
      selectedTime.value = time;
      timeEditingController.text = _toTimeFormat(time);
    }
  }

  String _toTimeFormat(TimeOfDay time) {
    return "${time.hour < 10 ? '0${time.hour}' : time.hour} : ${time.minute < 10 ? '0${time.minute}' : time.minute}";
  }

  void handleSelectPhoto() async {
    Get.bottomSheet(
      AppBottomSheet(
        height: 25.h,
        child: ImagePickerBottomSheet(
          onTakePhoto: handleTakePhoto,
          onPickGallery: handlePickImage,
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      shape: const BeveledRectangleBorder(),
    );
  }

  void handleTakePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      photoPath.value = image.path;
    }
  }

  void handlePickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Get.back();
      logger.d(image.path);
      photoPath.value = image.path;
    }
  }

  void handleCreateEvent() async {
    if (formKey.currentState!.validate()) {
      if (photoPath.value.isEmpty) {
        CustomSnackBar.showSnackBar(
            title: "Error", message: "Please select an image for your event");
      } else {
        Get.back();
        setStatus(Status.waiting);
        final event = EventModel.fromJson({
          "eventId": DateTime.now().millisecondsSinceEpoch.toString(),
          "userId": accountLocal.userId,
          "userAvatar": accountLocal.avatar,
          "userName": accountLocal.name,
          "eventName": nameEditingController.text,
          "bgImage": photoPath.value,
          "eventDate": selectedDate.value.toAPIFormat(),
          "eventTime": timeEditingController.text,
          "eventAddress": addressEditingController.text,
          "eventDescription": descriptionEditingController.text,
          "eventMembers": []
        });
        await FirebaseProvider.createEvent(event);
        setStatus(Status.success);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
