import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/Screens/Profile/update.dart';
import 'package:kiru/controllers/user_controller.dart';
import '../../constant.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';



class UpdateUserProfile extends StatefulWidget {
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtAbout_userController = TextEditingController();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserInfo();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        )
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  // update profile
  void updateProfile() async {
    ApiResponse response = await updateUser(
      txtNameController.text,
      getStringImage(_imageFile),
      txtAbout_userController.text, // Описание
    );

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.data}'),
      ));
      // Обновите состояние в Profile после успешного обновления
      Navigator.of(context).pop(); // Закрыть экран обновления профиля
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        )
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
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async {
          getUser();
        },
        child: ListView(
          padding: EdgeInsets.all(16.0),
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
                            ? Icon(Icons.camera_alt_outlined, size: 50, color: Colors.white)
                            : null,
                      ),
                      onTap: () {
                        getImage();
                      },
                    ),
                    SizedBox(height: 16),
                    Text('Изменить фото'),

                  ],
                ),
              ),
            ),
            Card(
                color:Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('О вас',style:TextStyle(
                                  color:Colors.grey
                              )),
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Имя пользователя'),
                            IconButton(
                                icon:Row(
                                  children: [
                                    Text('${user?.name ?? ''}',
                                        style:TextStyle(
                                            fontWeight: FontWeight.bold
                                        )),
                                    Icon(Icons.navigate_next)
                                  ],
                                ),
                                onPressed:() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Update()),
                                  );
                                }
                            ),

                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Описание'),
                        //     Flexible(
                        //       child: IconButton(
                        //         icon: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Expanded(
                        //               child: Text(
                        //                   '${user?.about ?? 'Добавить описание'}',
                        //                   overflow: TextOverflow.ellipsis,
                        //                   style:TextStyle(
                        //                       fontWeight: FontWeight.bold
                        //                   )
                        //               ),
                        //             ),
                        //             Icon(Icons.navigate_next),
                        //           ],
                        //         ),
                        //         onPressed: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(builder: (context) => Update()),
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // )

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Добавить описание'),
                            IconButton(
                                icon:Row(
                                  children: [
                                    Text('${user?.about ?? ''}',
                                        style:TextStyle(
                                            fontWeight: FontWeight.bold
                                        )),
                                    Icon(Icons.navigate_next)
                                  ],
                                ),
                                onPressed:() {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Update()),
                                  );
                                }
                            ),

                          ],
                        ),
                      ]
                  ),
                )
            ),
            Card(
                color:Colors.white,
                child:Padding(
                    padding:EdgeInsets.all(10),
                    child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Социальные сети',style:TextStyle(color:Colors.grey))
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Добавить Telegram'),
                              IconButton(
                                onPressed: () {},
                                icon: Row(

                                  children: [
                                    Text('Добавить Telegram'),
                                    Icon(Icons.navigate_next),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Instagram'),
                              IconButton(
                                  onPressed: () {},
                                  icon:Row(
                                      children: [
                                        Text('Добавить Instagram'),
                                        Icon(Icons.navigate_next)
                                      ]
                                  )
                              )
                            ],
                          )
                        ]
                    )
                )
            ),

          ],
        ),
      ),
    );
  }
}
