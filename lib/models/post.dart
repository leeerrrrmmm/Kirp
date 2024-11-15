import 'user.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

  // Преобразование объекта Post в Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'image': image,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'likes': selfLiked == true ? [1] : [],
      'user': user?.toJson(),
    };
  }

  // Преобразование JSON в объект Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        body: json['body'],
        image: json['image'],
        likesCount: json['likes_count'],
        commentsCount: json['comments_count'],
        selfLiked: (json['likes'] as List<dynamic>?)?.isNotEmpty ?? false,
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']
        )
    );
  }
}