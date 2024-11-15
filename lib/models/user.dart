class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? about;
  int? followCount;
  int? followerCount;
  bool? isSubscribe;
  String? token;

  User({
    this.id,
    this.name,
    this.image,
    this.email,
    this.about,
    this.followCount,
    this.followerCount,
    this.isSubscribe,
    this.token,
  });

  // Преобразование объекта User в Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'about': about,
      'following_count': followCount,
      'followers_count': followerCount,
      'is_subscribe': isSubscribe,
      'token': token,
    };
  }

  // Преобразование JSON в объект User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']?['id'],
      name: json['user']?['name'],
      image: json['user']?['image'],
      email: json['user']?['email'],
      about: json['user']?['about'],
      followerCount: json['user']?['followers_count'] ?? 0,
      followCount: json['user']?['following_count'] ?? 0,
      isSubscribe: json['user']?['is_subscribe'] ?? false,
      token: json['token'],
    );
  }

}