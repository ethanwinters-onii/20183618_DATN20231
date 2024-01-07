class UserRole {
    final String roleId;
    final String roleName;

    UserRole({
        required this.roleId,
        required this.roleName,
    });

    factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        roleId: json["roleId"],
        roleName: json["roleName"],
    );

    Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "roleName": roleName,
    };
}