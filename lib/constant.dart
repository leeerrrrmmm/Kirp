


import 'package:flutter/material.dart';

const baseURL = 'http://192.168.0.106:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const getPostsURL = baseURL + '/getPosts';
const commentsURL = baseURL + '/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';


TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black),
        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 20,horizontal: 120))
    ),
    onPressed: () => onPressed(),
  );
}


TextButton kTexFollowButton(String label, VoidCallback onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.black),
      padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 8, horizontal: 20)),
    ),
    onPressed: onPressed,
  );
}


TextButton kTextLogButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.black,fontSize:17),),
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 20,horizontal: 130))
    ),
    onPressed: () => onPressed(),
  );
}

TextButton kTextRegButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white,fontSize:17),),
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black),
        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 20,horizontal: 130))
    ),
    onPressed: () => onPressed(),
  );
}

TextButton kTextEditButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.black,fontSize:17),),
    style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black12),
        padding: WidgetStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 15,horizontal: 50))
    ),
    onPressed: () => onPressed(),
  );
}

TextButton kTextCreateButton(String label, Function onPressed, Icon icon) {
  return TextButton.icon(
    icon: icon,
    label: Text(
      label,
      style: TextStyle(color: Colors.black, fontSize: 17),
    ),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
            (states) => Colors.black12,
      ),
      padding: WidgetStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      ),
    ),
    onPressed: () => onPressed(),
  );
}

//Have & not have account
Row NotHaveAccount(String fText, String sText){
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(fText,style:TextStyle(color: Colors.grey)),
        SizedBox(width: 20,),
        Text(sText,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w600)),
      ]
  );
}

//Privacy
Text privacy(String text){
  return Text(text,style:TextStyle(color:Colors.grey));
}



// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text,style:TextStyle(color:Colors.grey)),
      GestureDetector(
          child: Text(label, style:TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
          onTap: () => onTap()
      )
    ],
  );
}


//Profile design
Column buildStatColumn(String count, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        count,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label),
    ],
  );
}


InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))
  );
}