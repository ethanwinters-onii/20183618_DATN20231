class PetModel {
    final int petId;
    final String vnName;
    final String enName;
    final String weight;
    final String origin;
    final String enAppearance;
    final String enDescription;
    final String enTemperament;
    final String viAppearance;
    final String viDescription;
    final String viTemperament;
    final String health;
    final String price;
    final String avatar;
    final List<String> images;

    PetModel({
        required this.petId,
        required this.vnName,
        required this.enName,
        required this.weight,
        required this.origin,
        required this.enAppearance,
        required this.enDescription,
        required this.enTemperament,
        required this.viAppearance,
        required this.viDescription,
        required this.viTemperament,
        required this.health,
        required this.price,
        required this.avatar,
        required this.images,
    });

    factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        petId: json["PetId"],
        vnName: json["vn_name"],
        enName: json["en_name"],
        weight: json["weight"],
        origin: json["origin"],
        enAppearance: json["en_appearance"],
        enDescription: json["en_description"],
        enTemperament: json["en_temperament"],
        viAppearance: json["vi_appearance"],
        viDescription: json["vi_description"],
        viTemperament: json["vi_temperament"],
        health: json["health"],
        price: json["price"],
        avatar: json["avatar"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "PetId": petId,
        "vn_name": vnName,
        "en_name": enName,
        "weight": weight,
        "origin": origin,
        "en_appearance": enAppearance,
        "en_description": enDescription,
        "en_temperament": enTemperament,
        "vi_appearance": viAppearance,
        "vi_description": viDescription,
        "vi_temperament": viTemperament,
        "health": health,
        "price": price,
        "avatar": avatar,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}