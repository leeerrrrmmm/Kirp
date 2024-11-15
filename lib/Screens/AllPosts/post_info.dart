import 'package:flutter/material.dart';
import 'package:kiru/controllers/user_controller.dart';
import 'package:kiru/models/sub.dart';

import '../../constant.dart';
import '../../controllers/sub_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';
import '../Comment/comment_screen.dart';
import '../Log&Reg/login_screen.dart';
import '../Profile/userInfo_fromPosts.dart';


class UsersInfo extends StatefulWidget {
  final int userId;
  final String userName;
  final String userImage;
  final String postImage;
  final String postText;
  final int postLikes;
  final int commentsCount;
  final int postId;
  final int userFolowersCount; // Исправлено

  UsersInfo({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.postImage,
    required this.postText,
    required this.postLikes,
    required this.commentsCount,
    required this.postId,
    required this.userFolowersCount, // Исправлено
  }) : super(key: key);

  @override
  State<UsersInfo> createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  User? user;
  Post? post;
  Sub? sub;
  bool _loading = true;


  @override
  void initState() {
    _getUserInfo();
    _checkSubStatus();
    super.initState();
  }

  Future<void> _getUserInfo() async {
    try {
      ApiResponse response = await getUserById(widget.userId);
      if (response.error == null) {
        setState(() {
          user = response.data as User;
          _loading = false; // Изменяем состояние загрузки
        });
      } else {
        print('Error getting user info: ${response.error}');
      }
    } catch (e) {
      print('Exception in _getUserInfo: $e');
    }
  }

  void _checkSubStatus() async {
    ApiResponse response = await checkSubscriptionStatus(widget.userId);

    if (response.error == null) {
      // Предполагаем, что ответ содержит только булево значение
      bool isSubscribed = response.data as bool;

      // Обновляем состояние sub с данными о подписке
      setState(() {
        sub = Sub(isSubscribed: isSubscribed);
      });

      logger.e('This user Is Subscribed to selected user : ${sub!.isSubscribed}');
    } else if (response.error == unauthorized) {
      logout().then((_) => {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        )
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }



  void subOrUnsub () async {
    ApiResponse response = await subOrunsub(widget.userId);
    if(response.error == null) {
      setState(() {
        _getUserInfo();
        _checkSubStatus();
      });
    }else if(response.error == unauthorized)
    {
      logout().then(
              (value) =>
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
      );
    }else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }

  }





  Future<void> _onRefresh() async {
    await _getUserInfo(); // Обновляем данные при свайпе вниз
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Просмотр публикации'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card with post image
                widget.postImage.isNotEmpty
                    ? Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
                      child: Image.network(
                        widget.postImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : Container(),
                SizedBox(height: 16),
                // User info
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UserinfoFromposts(
                                      userId: widget.userId,
                                      userName: user?.name ?? 'Loading name...',
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: widget.userImage.isNotEmpty
                                    ? NetworkImage(widget.userImage)
                                    : null,
                                child: widget.userImage.isEmpty
                                    ? Icon(Icons.person, size: 30, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.38),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userName,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'подписчики: ${user?.followerCount ?? 0}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 10),
                                      kTextCreateButton (
                                        sub?.isSubscribed ?? false ? 'Отписаться' : 'Подписаться',
                                            () {
                                          subOrUnsub();
                                        },
                                        Icon(Icons.add_circle_outline, color: Colors.black),
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Описание:',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.postText,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Добавьте функционал лайков
                                  },
                                ),
                                Text(widget.postLikes.toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.sms_outlined, color: Colors.black),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CommentScreen(postId: widget.postId)));
                                  },
                                ),
                                Text(widget.commentsCount.toString())
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.shortcut_outlined, color: Colors.black),
                                onPressed: () {
                                  // Добавьте функционал шеринга
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
