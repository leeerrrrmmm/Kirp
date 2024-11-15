


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiru/Screens/Bottom/bottom_bar_widget.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/service/api_response.dart';

import 'constant.dart';
import 'controllers/user_controller.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void _loadUserInfo() async {
    String token = await getToken();
    if(token == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
    }
    else {
      ApiResponse response = await getUserInfo();
      if (response.error == null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>BottomBarWidget()), (route) => false);
      }
      else if (response.error == unauthorized){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
      }
      else {
        print('Server error: ${response.error}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ошибка сервера: ${response.error}'),
        ));
      }

    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
          child: CircularProgressIndicator()
      ),
    );
  }
}