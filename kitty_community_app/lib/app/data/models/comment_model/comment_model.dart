class CommentModel {
    String? commentId;
    String? userId;
    String? postId;
    String? name;
    String? comment;
    String? avatar;
    List<String>? hearts;
    String? commentImage;

    CommentModel({
        this.commentId,
        this.userId,
        this.postId,
        this.name,
        this.comment,
        this.avatar,
        this.hearts,
        this.commentImage,
    });

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        commentId: json["commentId"],
        userId: json["userId"],
        postId: json["postId"],
        name: json["name"],
        comment: json["comment"],
        avatar: json["avatar"],
        hearts: json["hearts"] == null ? [] : List<String>.from(json["hearts"]!.map((x) => x)),
        commentImage: json["commentImage"],
    );

    Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "userId": userId,
        "postId": postId,
        "name": name,
        "comment": comment,
        "avatar": avatar,
        "hearts": hearts == null ? [] : List<dynamic>.from(hearts!.map((x) => x)),
        "commentImage": commentImage,
    };
}