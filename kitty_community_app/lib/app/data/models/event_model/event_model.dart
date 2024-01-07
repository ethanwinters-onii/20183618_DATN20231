class EventModel {
    String? eventId;
    String? userId;
    String? userAvatar;
    String? userName;
    String? eventName;
    String? bgImage;
    String? eventDate;
    String? eventTime;
    String? eventAddress;
    String? eventDescription;
    List<String>? eventMembers;

    EventModel({
        this.eventId,
        this.userId,
        this.userAvatar,
        this.userName,
        this.eventName,
        this.bgImage,
        this.eventDate,
        this.eventTime,
        this.eventAddress,
        this.eventDescription,
        this.eventMembers,
    });

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eventId: json["eventId"],
        userId: json["userId"],
        userAvatar: json["userAvatar"],
        userName: json["userName"],
        eventName: json["eventName"],
        bgImage: json["bgImage"],
        eventDate: json["eventDate"],
        eventTime: json["eventTime"],
        eventAddress: json["eventAddress"],
        eventDescription: json["eventDescription"],
        eventMembers: json["eventMembers"] == null ? [] : List<String>.from(json["eventMembers"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "userId": userId,
        "userAvatar": userAvatar,
        "userName": userName,
        "eventName": eventName,
        "bgImage": bgImage,
        "eventDate": eventDate,
        "eventTime": eventTime,
        "eventAddress": eventAddress,
        "eventDescription": eventDescription,
        "eventMembers": eventMembers == null ? [] : List<dynamic>.from(eventMembers!.map((x) => x)),
    };
}