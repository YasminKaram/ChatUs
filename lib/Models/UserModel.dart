class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String image;

  UserModel(
      { required this.id, required this.name, required this.email, required this.phone,required this.image});

  UserModel.fromJson(Map <String, dynamic>json) : this(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    image: json['image']
  );

  Map<String, dynamic>toJson() {
  return
  {
  "id":id,
  "email":email,
  "name":name,
  "phone":phone,
    "image":image
  };
}

}