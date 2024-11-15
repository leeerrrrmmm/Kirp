import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../service/api_response.dart';
import '../Log&Reg/login_screen.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  bool _loading = true;
  List<dynamic> _postList = [];

  void _handleLikedOrUnlikedPost( int postId) async
  {
    ApiResponse response = await likeOrUnlike(postId);

    if(response.error == null) {
      _showLikedPosts();
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

  Future<void> _showLikedPosts() async {
    ApiResponse response = await getLikedPosts();

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

  @override
  void initState() {
    _showLikedPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Понравившиеся публикации', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _showLikedPosts,
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
                                    post.selfLiked == false
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: post.selfLiked == true
                                        ? Colors.black
                                        : Colors.black,
                                    size: 17.0,
                                  ),
                                  onPressed: () {
                                    _handleLikedOrUnlikedPost(post.id ?? 0);
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
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => CommentScreen(
                                    //       postId: post.id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                              SizedBox(width: 4.0),
                            ],
                          ),
                        ),
                      ),
                      Align(
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
