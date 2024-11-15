import 'user.dart';

class Sub {
  int? id;
  int? userId;
  int? subscribedUserId;
  User? user;
  bool? isSubscribed;

  Sub({
    this.id,
    this.userId,
    this.subscribedUserId,
    this.user,
    this.isSubscribed,
  });

  // Преобразование объекта Subscription в Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subscribed_user_id': subscribedUserId,
      'user': user?.toJson(),
      'isSubscribed' : isSubscribed,
    };
  }

  // Преобразование JSON в объект Subscription
  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      id: json['id'],
      userId: json['user_id'],
      subscribedUserId: json['subscribed_user_id'],
      isSubscribed: json['isSubscribed'],
      user: json['user'] != null
          ? User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      )
          : null,
    );
  }
}
