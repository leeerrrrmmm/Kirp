import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/Screens/Profile/update_user.dart';
import 'package:kiru/Screens/Settings/settings.dart';
import 'package:kiru/controllers/post_controller.dart';

import '../../constant.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';
import '../Create/create_post.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  List<dynamic> _postList = [];
  bool _postLoading = true;
  String token = '';

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void getUser() async {
    ApiResponse response = await getUserInfo();
    token = await getToken();
    if(response.error == null) {
      setState(() {
        loading = false;
        user = response.data as User;
        txtNameController.text = user!.name ?? '';
      });
      retrievePosts();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }


  void retrievePosts() async {

    ApiResponse response = await getPofilePostsById(user?.id ?? 0);
    if (response.error == null) {
        setState(() {
          _postList = response.data as List<dynamic>;
          _postLoading = false;
        });
    } else if (response.error == unauthorized) {
      logout().then((value) {
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




  void _deletePost(int postId) async {
    ApiResponse response = await deletePost(postId);

    if (response.error == null) {
      retrievePosts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Пост удален'),
      ));
    } else if (response.error == unauthorized) {
      logout().then((value) {
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
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Settings(
                    userId : user?.id ?? 0,
                    token : token,
                    email : user?.email ?? '',
                  )), (route) => true);
            },
          ),
        ],
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async {
          getUser();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            image: _imageFile != null
                                ? DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            )
                                : user?.image != null
                                ? DecorationImage(
                              image: NetworkImage('${user!.image}'),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: Colors.grey,
                          ),
                          child: _imageFile == null && user?.image == null
                              ? Icon(Icons.camera_alt_outlined, size: 50,
                              color: Colors.white)
                              : null,
                        ),
                        onTap: () {
                          // Логика выбора изображения профиля
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${user?.name ?? 'Loading...'}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn('${user?.followerCount ?? 0}', 'Подписчики'),
                          buildStatColumn('${_postList.length}', 'Публикации'),
                          buildStatColumn('${user?.followCount ?? 0}', 'Подписки'),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('${user?.about ?? 'sss'}',
                          style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          )),
                      SizedBox(height: 16),
                      kTextEditButton('Редактировать', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateUserProfile(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              kTextCreateButton(
                'Опубликовать',
                    () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreatePost(
                      title: 'Создать пост',
                    ),
                  ));
                },
                Icon(Icons.add_circle_outline, color: Colors.black),
              ),
              SizedBox(height: 16),
              _postLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => Settings(),
                      //   ),
                      // );
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
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    // Реализуйте логику редактирования поста
                                  } else if (value == 'delete') {
                                    _deletePost(post.id ?? 0);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Редактировать'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Удалить'),
                                  ),
                                ],
                                icon: Icon(
                                    Icons.more_vert, color: Colors.white),
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
                                              ? Colors.red
                                              : Colors.black,
                                          size: 17.0,
                                        ),
                                        onPressed: () {
                                          // _handlePostLikeDislike(post.id ?? 0);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4.0),
                                  ],
                                ),
                              ),
                            ), Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child:Text('${post.body}')
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
