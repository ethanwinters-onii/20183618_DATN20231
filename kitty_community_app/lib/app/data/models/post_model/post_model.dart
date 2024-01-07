class PostModel {
  String? postId; // postId = userid + time
  String? userId;
  String? description;
  String? image;
  List<String>? hearts;
  String? createdAt;
  String? userAvatar;
  String? createdBy;
  int? noComment;

  PostModel({
    this.postId,
    this.userId,
    this.description,
    this.image,
    this.hearts,
    this.createdAt,
    this.userAvatar,
    this.createdBy,
    this.noComment
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        postId: json["postId"],
        userId: json["userId"],
        description: json["description"],
        image: json["image"],
        hearts: json["hearts"] == null
            ? []
            : List<String>.from(json["hearts"]!.map((x) => x)),
        createdAt: json["createdAt"],
        userAvatar: json["userAvatar"],
        createdBy: json["createdBy"],
        noComment: json["noComment"]
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "userId": userId,
        "description": description,
        "image": image,
        "hearts":
            hearts == null ? [] : List<dynamic>.from(hearts!.map((x) => x)),
        "createdAt": createdAt,
        "userAvatar": userAvatar,
        "createdBy": createdBy,
        "noComment": noComment
      };
}
