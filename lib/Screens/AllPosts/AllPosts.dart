import 'package:flutter/material.dart';
import 'package:kiru/Screens/AllPosts/post_info.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/controllers/post_controller.dart';

import '../../constant.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';
import '../Comment/comment_screen.dart';


class AllOfUsersPosts extends StatefulWidget {
  @override
  _AllOfUsersPostsState createState() => _AllOfUsersPostsState();
}

class _AllOfUsersPostsState extends State<AllOfUsersPosts> {
  User? user;
  List<dynamic> _postList = [];
  bool _loading = true;

  // Метод для получения постов
  Future<void> retrievePosts() async {
    ApiResponse response = await getUsersPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      logout().then((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

void _handleLikedOrUnlikedPost( int postId) async
{
  ApiResponse response = await likeOrUnlike(postId);

  if(response.error == null) {
    retrievePosts();
  }else if( response.error == unauthorized)
   {
    logout().then((value) => {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
    });
   }
  else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
  }

}


  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рекомендуемые', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: retrievePosts,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
          ),
          itemCount: _postList.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = _postList[index];
            return GestureDetector(
              onTap: () {
                   setState(() {
                     Navigator.of(context).push( MaterialPageRoute(
                       builder: (context) => UsersInfo(
                         userId: post.user?.id ?? 0,
                         userName: post.user?.name ?? 'Неизвестный',
                         userImage: post.user?.image ?? '',
                         postImage: post.image ?? '',
                         postText: post.body ?? '',
                         postLikes: post.likesCount ?? 0,
                         commentsCount: post.commentsCount ?? 0,
                         postId: post.id ?? 0,
                         userFolowersCount: user?.followerCount ?? 0,
                       ),
                     ),);
                   });

              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: post.image != null
                            ? Image.network(
                          '${post.image}',
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Colors.grey[200],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.favorite_border, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16.0,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    post.selfLiked == true
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: post.selfLiked == true
                                        ? Colors.black
                                        : Colors.black,
                                    size: 17.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _handleLikedOrUnlikedPost(post.id ?? 0);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 4.0),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16.0,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.sms_outlined,
                                    color: Colors.black,
                                    size: 17.0,
                                  ),
                                  onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          postId: post.id
                                        )
                                      ));
                                    },
                                ),
                              ),
                              SizedBox(width: 4.0),
                            ],
                          ),
                        ),
                      ),Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('${post.body}')
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
