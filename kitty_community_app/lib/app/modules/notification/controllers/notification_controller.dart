import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/data/models/notification_model/notification_model.dart';

class NotificationController extends BaseController {
  List<NotificationModel> notifcations = [
    NotificationModel.fromJson({
      "notificationId": "1",
      "userNotifyId": "a",
      "userReceiveId": "b",
      "userNotifyName": "Nguyễn Văn A",
      "userNotifyAvatar": "aaa",
      "notifyType": "post",
      "notificationContent": "đã cập nhật một trạng thái mới",
      "notificationCreateAt": "2023-11-29 21:02:00",
      "postId": "",
      "eventId": "",
      "read": true
    }),
    NotificationModel.fromJson({
      "notificationId": "1",
      "userNotifyId": "a",
      "userReceiveId": "b",
      "userNotifyName": "Nguyễn Văn A",
      "userNotifyAvatar": "aaa",
      "notifyType": "comment",
      "notificationContent": "đã bình luận vào bài viết của bạn",
      "notificationCreateAt": "2023-11-29 21:02:00",
      "postId": "",
      "eventId": "",
      "read": false
    }),
    NotificationModel.fromJson({
      "notificationId": "1",
      "userNotifyId": "a",
      "userReceiveId": "b",
      "userNotifyName": "Nguyễn Văn A",
      "userNotifyAvatar": "aaa",
      "notifyType": "event",
      "notificationContent": "đã tạo một sự kiện mới",
      "notificationCreateAt": "2023-11-29 21:02:00",
      "postId": "",
      "eventId": "",
      "read": false
    }),
  ];

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
