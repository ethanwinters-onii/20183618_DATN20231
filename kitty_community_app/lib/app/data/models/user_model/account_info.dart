import 'package:hive/hive.dart';
part 'account_info.g.dart';

@HiveType(typeId: 0)
class AccountInfo {
    @HiveField(0)
    String? userId;
    @HiveField(1)
    String? name;
    @HiveField(2)
    bool? onFirstLogin;
    @HiveField(3)
    String? avatar;
    @HiveField(4)
    String? description;
    @HiveField(5)
    String? dateOfBirth;
    @HiveField(6)
    String? deviceToken;
    @HiveField(7)
    List<String>? follower;
    @HiveField(8)
    List<String>? following;

    AccountInfo({
        this.userId,
        this.name,
        this.onFirstLogin,
        this.avatar,
        this.description,
        this.dateOfBirth,
        this.deviceToken,
        this.follower,
        this.following,
    });

    factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
        userId: json["UserId"],
        name: json["Name"],
        onFirstLogin: json["onFirstLogin"],
        avatar: json["avatar"],
        description: json["description"],
        dateOfBirth: json["dateOfBirth"],
        deviceToken: json["deviceToken"],
        follower: json["follower"] == null ? [] : List<String>.from(json["follower"]!.map((x) => x)),
        following: json["following"] == null ? [] : List<String>.from(json["following"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Name": name,
        "onFirstLogin": onFirstLogin,
        "avatar": avatar,
        "description": description,
        "dateOfBirth": dateOfBirth,
        "deviceToken": deviceToken,
        "follower": follower == null ? [] : List<dynamic>.from(follower!.map((x) => x)),
        "following": following == null ? [] : List<dynamic>.from(following!.map((x) => x)),
    };
}