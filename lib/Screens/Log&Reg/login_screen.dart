import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiru/Screens/Log&Reg/register_screen.dart';
import 'package:kiru/service/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user.dart';
import '../Bottom/bottom_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passworConfirmdController = TextEditingController();
  AuthController _authController = Get.put(AuthController());

  bool obscureText = true;


  void _LoginUser() async {
    ApiResponse response = await _authController.login(
     _emailController.text.trim(),
    _passwordController.text.trim(),

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
        title:Text('Login',
        style:TextStyle(
          color:Colors.white
        )),
        centerTitle:true,
      ),
      body:Stack(
        children: [
          Column(

            children: [
              Expanded(
                  child:
                  Center(
                    child: Container(
                      width: double.infinity,
                      constraints:  BoxConstraints(minWidth: 380, maxWidth: 380),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Colors.grey[200],

                      ),
                      child:Form(
                        key:_key,
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              cursorWidth: 1.5,
                              cursorColor: Colors.black,
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText:'Email',
                                labelStyle:TextStyle(
                                  color:Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                  borderSide:BorderSide(
                                    color:Colors.grey,
                                    width: 1
                                  )
                                ),
                                focusedBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:BorderSide(
                                    color:Colors.black,
                                    width: 1
                                  )
                                )
                              ),
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              obscureText:obscureText ,
                              cursorWidth: 1.5,
                              cursorColor: Colors.black,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText:'Password',
                                labelStyle:TextStyle(
                                  color:Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(10),
                                  borderSide:BorderSide(
                                    color:Colors.grey,
                                    width: 1
                                  )
                                ),
                                focusedBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:BorderSide(
                                    color:Colors.black,
                                    width: 1
                                  )
                                )
                              ).copyWith(
                                suffixIcon:IconButton(
                                  onPressed:() {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon:obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                                )
                              )
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                                obscureText:obscureText ,
                                cursorWidth: 1.5,
                                cursorColor: Colors.black,
                                controller: _passworConfirmdController,
                                decoration: InputDecoration(
                                    labelText:'Password Confirmation',
                                    labelStyle:TextStyle(
                                      color:Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:BorderRadius.circular(10),
                                        borderSide:BorderSide(
                                            color:Colors.grey,
                                            width: 1
                                        )
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:BorderSide(
                                            color:Colors.black,
                                            width: 1
                                        )
                                    )
                                ).copyWith(
                                    suffixIcon:IconButton(
                                        onPressed:() {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                        icon:obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                                    )
                                )
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                      _LoginUser();
                                  },
                                  child:Text('Login',
                                  style:TextStyle(
                                    color:Colors.white
                                  )),
                                  style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    elevation: 0,
                                    padding:EdgeInsets.symmetric(horizontal: 50, vertical: 20)
                                  )
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RegisterScreen()), (route) => false);
                                  },
                                  child:Text('Register',
                                  style:TextStyle(
                                    color:Colors.black,
                                  )),
                                  style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    elevation: 0,
                                    padding:EdgeInsets.symmetric(horizontal: 50, vertical: 20)
                                  )
                                )

                              ]
                            )
                          ],
                        ),
                      )
                    ),
                  )
              )
            ],
          )
        ],
      )
    );
  }
}
