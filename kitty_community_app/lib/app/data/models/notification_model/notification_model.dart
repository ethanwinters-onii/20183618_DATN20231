class NotificationModel {
    String? notificationId;
    String? userNotifyId;
    String? userReceiveId;
    String? userNotifyName;
    String? userNotifyAvatar;
    String? notifyType;
    String? notificationContent;
    String? notificationContentEn;
    String? notificationCreateAt;
    String? postId;
    String? eventId;
    bool? read;

    NotificationModel({
        this.notificationId,
        this.userNotifyId,
        this.userReceiveId,
        this.userNotifyName,
        this.userNotifyAvatar,
        this.notifyType,
        this.notificationContent,
        this.notificationContentEn,
        this.notificationCreateAt,
        this.postId,
        this.eventId,
        this.read,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        notificationId: json["notificationId"],
        userNotifyId: json["userNotifyId"],
        userReceiveId: json["userReceiveId"],
        userNotifyName: json["userNotifyName"],
        userNotifyAvatar: json["userNotifyAvatar"],
        notifyType: json["notifyType"],
        notificationContent: json["notificationContent"],
        notificationContentEn: json["notificationContentEn"],
        notificationCreateAt: json["notificationCreateAt"],
        postId: json["postId"],
        eventId: json["eventId"],
        read: json["read"],
    );

    Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userNotifyId": userNotifyId,
        "userReceiveId": userReceiveId,
        "userNotifyName": userNotifyName,
        "userNotifyAvatar": userNotifyAvatar,
        "notifyType": notifyType,
        "notificationContent": notificationContent,
        "notificationContentEn": notificationContentEn,
        "notificationCreateAt": notificationCreateAt,
        "postId": postId,
        "eventId": eventId,
        "read": read,
    };
}