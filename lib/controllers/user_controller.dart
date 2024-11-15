import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kiru/constant.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../Screens/Log&Reg/login_screen.dart';
import '../models/user.dart';
import '../service/api_response.dart';

final logger = Logger();
final box = GetStorage();
final isLoading = false.obs;


Future<ApiResponse> getUserInfo() async {

  ApiResponse apiResponse = ApiResponse();

  try{

    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/getUser'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );
    logger.i('getUserInfo response status: ${response.statusCode}');
    logger.i('getUserInfo response body: ${response.body}');
    logger.i('token $token');

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {

    logger.e('Exception in getUserInfo: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;

}

Future<ApiResponse> getUserById(int userId) async {

  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/getUserById/$userId'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Accept' : 'application/json',
      }
    );
    logger.i('getUserById response status: ${response.statusCode}');
    logger.i('getUserById response body: ${response.body}');

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {

    logger.e('Exception in getUserInfo: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;

}

Future<ApiResponse> updateUser(String name, String? image, String? about) async
{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await  http.put(
      Uri.parse('$baseURL/updateUser'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      },
      body: {
        'name' : name,
        'image' : image ?? '',
        'about' : about ?? '',
      }
    );

    logger.i('Update user response status: ${response.statusCode}');
    logger.i('Update user response body: ${response.body}');

    switch(response.statusCode) {

      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;
      default:
        apiResponse.error = somethingWentWrong;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;
    }
  }catch(e){

    logger.i('Excpection in updateUser: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//delete user
Future<ApiResponse> deleteUser(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseURL/deleteUser/$userId'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Accept' : 'application/json',
      }
    );

    logger.i('DeleteUser response statusCode ${response.statusCode}');
    logger.i('DeleteUser response body ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        Get.offAll(() => LoginScreen());
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}


// Get user ID
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}


// Get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
