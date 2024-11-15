import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiru/Screens/Log&Reg/login_screen.dart';
import 'package:kiru/controllers/user_controller.dart';
import '../../constant.dart';
import '../../models/user.dart';
import '../../service/api_response.dart';

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtAboutUserController = TextEditingController();


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
        txtAboutUserController.text = user!.about ?? '';
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
    print('Updating profile with:');
    print('Name: ${txtNameController.text}');
    print('About: ${txtAboutUserController.text}');
    print('Image: ${getStringImage(_imageFile)}');

    ApiResponse response = await updateUser(
        txtNameController.text,
        getStringImage(_imageFile),
        txtAboutUserController.text
    );

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.data}')
      ));
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
                    Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFormField(
                                decoration: kInputDecoration('Name'),
                                controller: txtNameController,
                                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                decoration: kInputDecoration('About'),
                                controller: txtAboutUserController,
                                validator: (val) => val!.isEmpty ? 'Invalid Credentials' : null,
                              ),
                            ]
                        )
                    ),
                    SizedBox(height: 16),
                    kTextButton('Update', () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        updateProfile();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
