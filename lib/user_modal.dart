class UserModal {
  int id;
  String name;

  UserModal({required this.id, required this.name});

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };

  factory UserModal.ModelObjectFromMap(Map<String, dynamic> mapValue) =>
      UserModal(id: mapValue["id"], name: mapValue["name"]);
}
