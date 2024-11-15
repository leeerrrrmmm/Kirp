import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kiru/controllers/user_controller.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../models/user.dart';
import '../service/api_response.dart';


final isLoading = false.obs;
class AuthController extends GetxController {

  Future<ApiResponse> login(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      isLoading.value = true;
      var data = {
        'email' : email,
        'password' : password,
        'password_confirmation' : password,
      };
      final response = await http.post(
        Uri.parse('$baseURL/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      logger.i('Login response status: ${response.statusCode}');
      logger.i('Login response body: ${response.body}');

      switch (response.statusCode) {
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          Get.snackbar(
              'Error',
              apiResponse.error = jsonDecode(response.body)['message'],
            colorText:Colors.white,
            backgroundColor: Colors.red,
            snackPosition:SnackPosition.TOP
          );
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      logger.e('Exception in login: $e');
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  Future<ApiResponse> Register(String name, String email, String password, String passwordConfirm) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      isLoading.value = true;
      String token = await getToken();
      var data = {
        'name' : name,
        'email' : email,
        'password' : password,
        'password_confirmation' : passwordConfirm,
      };
      final response = await http.post(
        Uri.parse('$baseURL/register'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token',

        },
        body: data,
      );

      logger.i('Register response status: ${response.statusCode}');
      logger.i('Register response body: ${response.body}');

      switch (response.statusCode) {
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          Get.snackbar(
              'Success',
              'Welcome',
              colorText: Colors.white,
              backgroundColor: Colors.green,
          );
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      logger.e('Exception in register: $e');
      apiResponse.error = serverError;
    }

    return apiResponse;
  }
}