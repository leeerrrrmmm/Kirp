import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiru/Screens/Bottom/bottom_bar_widget.dart';
import 'package:kiru/Screens/Home/home_screen.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/service/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth_controller.dart';
import '../../models/user.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool obscureText = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController = TextEditingController();
  final AuthController _authenticatorController = Get.put(AuthController());


  void _Register() async {
    if(!_key.currentState!.validate()) return;

    ApiResponse response = await _authenticatorController.Register(
         _nameController.text.trim(),
         _emailController.text.trim(),
         _passwordController.text.trim(),
         _passwordConfirmationController.text.trim()
    );
    if(response.error == null)
      {
        _saveAndRedirectToHome(response.data as User);
      }else{
      setState(() {
        isLoading.value = false;
      });

    }

  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomBarWidget()), (route) => false);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Register',
        style: TextStyle(
          color: Colors.white,
        ),),
        centerTitle:true
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child:
                  Center(
                    child:
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 380, minWidth: 380),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]
                      ),
                      child: Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              cursorWidth: 1.5,
                              cursorColor:Colors.black,
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle:TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black26, width:  1)
                                ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide: BorderSide(color:Colors.grey, width: 1)
                                 )
                              ),
                            ),

                            const SizedBox(height: 10,),

                            TextFormField(
                              cursorWidth: 1.5,
                              cursorColor:Colors.black,
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black26, width:  1)
                                ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide: BorderSide(color:Colors.grey, width: 1)
                                 )
                              ),
                            ),

                            const SizedBox(height: 10,),

                            TextFormField(
                              obscureText: obscureText,
                              cursorWidth: 1.5,
                              cursorColor:Colors.black,
                              controller: _passwordController,
                              validator: (val) =>
                              val!.length < 6
                                  ?
                                  "Пароль должен содержать не менее 6 символов"
                                  :
                                   null,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black26, width:  1)
                                ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide: BorderSide(color:Colors.grey, width: 1)
                                 )
                              ).copyWith(suffixIcon: IconButton(onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              }, icon: obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility))),
                            ),

                            const SizedBox(height: 10,),

                            TextFormField(
                              obscureText: obscureText,
                              cursorWidth: 1.5,
                              cursorColor:Colors.black,
                              controller: _passwordConfirmationController,

                              decoration: InputDecoration(
                                labelText: 'Password Confirmation',
                                labelStyle:TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black26, width:  1)
                                ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   borderSide: BorderSide(color:Colors.grey, width: 1)
                                 )
                              ).copyWith(suffixIcon: IconButton(onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              }, icon: obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility)))
                            ),

                            const SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                        _Register();
                                 },
                                  child: Text('Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 22)
                                ),),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                  }, child: Text('Login',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 22)
                                  ),)
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          )
        ],
      )
    );
  }
}
