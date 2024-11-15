import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiru/constant.dart';
import '../../controllers/user_controller.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';
import '../Log&Reg/login_screen.dart';

class Settings extends StatefulWidget {
final int userId;
final String token;
final String email;

  Settings ({
  Key? key,
    required this.userId,
    required this.token,
    required this.email,
}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
User? user;

  void _getUser() async {
    ApiResponse response = await getUserById(widget.userId);
     if(response.error == null)
       {
         setState(() {
           user = response.data as User;
         });
       }else if(response.error == unauthorized)
         {
           logout().then((_) => {
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
           });
         }
  }

  void _deleteAccount() async {
    ApiResponse response = await deleteUser(widget.userId);
    if(response.error == null)
      {
        Get.snackbar(
          'Success',
          'User was deleted success!',
          colorText:Colors.white,
          backgroundColor: Colors.red,
          snackPosition:SnackPosition.TOP,
        );
      }
  }


  @override
  void initState() {
    _getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black,
        title: Text('Settigs',
        style:TextStyle(
          color:Colors.white
        )),
        centerTitle:true
      ),
      body: isLoading.value ?
          RefreshIndicator(
            onRefresh: () async {
              _getUser();
            },
            child: Center(
              child:CircularProgressIndicator(color:Colors.black)
            ),
          )
      :
      Center(
        child: Column(
          children: [
            Card(
              elevation: 0.5,
              color:Colors.white,
              child: Container(
                height: 190,
                constraints: BoxConstraints(maxWidth: 380, minWidth: 380,),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Данные аккнаунта',
                      style:TextStyle(
                        fontWeight:FontWeight.bold,
                        fontSize:17
                      )),
                      Text('Видны только вам',
                      style:TextStyle(
                        color:Colors.black54
                      )),
                      SizedBox(height: 15,),
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email_outlined,color:Colors.black),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email',
                                        style: TextStyle(
                                            fontSize:17,
                                            color:Colors.black
                                        )),
                                    Text( '${user?.email ?? 'Loading...'}',
                                        style: TextStyle(
                                            fontSize:17,
                                            color:Colors.black54
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Icon(Icons.chevron_right,color:Colors.black),
                          ],
                        ),
                        style:ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0
                        )
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.vpn_key_outlined,color:Colors.black),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Пароль',
                                          style: TextStyle(
                                              fontSize:17,
                                              color:Colors.black
                                          )),
                                      Text('************',
                                          style: TextStyle(
                                              fontSize:17,
                                              color:Colors.black54
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.chevron_right,color:Colors.black),
                            ],
                          ),
                          style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),

            Card(
              elevation: 0.5,
              color:Colors.white,
              child: Container(
                height: 170,
                constraints: BoxConstraints(maxWidth: 380, minWidth: 380,),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Действия с аккаунтом',
                          style:TextStyle(
                              fontWeight:FontWeight.bold,
                              fontSize:17
                          )),
                      SizedBox(height: 15,),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,color:Colors.black),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Выход из аккаунта',
                                          style: TextStyle(
                                              fontSize:17,
                                              color:Colors.black
                                          )),
                                      Text('Выйти из аккаунта?',
                                          style: TextStyle(
                                              fontSize:13,
                                              color:Colors.black54
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.chevron_right,color:Colors.black),
                            ],
                          ),
                          style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0
                          )
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(
                          onPressed: () {
                            _deleteAccount();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,color:Colors.black),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Удаление аккаунта(id:${user?.id ?? 123}',
                                          style: TextStyle(
                                              fontSize:17,
                                              color:Colors.black
                                          )),
                                      Text('Удалить аккаунт??',
                                          style: TextStyle(
                                              fontSize:13,
                                              color:Colors.black54
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.chevron_right,color:Colors.black),
                            ],
                          ),
                          style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child:Text(
                '${widget.token}'
              )
            )
          ],
        ),
      )
    );
  }
}
