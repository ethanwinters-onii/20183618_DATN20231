class ProductModel {
    String? productId;
    String? userId;
    String? image;
    String? price;
    String? name;

    ProductModel({
        this.productId,
        this.userId,
        this.image,
        this.price,
        this.name,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["productId"],
        userId: json["userId"],
        image: json["image"],
        price: json["price"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "userId": userId,
        "image": image,
        "price": price,
        "name": name,
    };
}