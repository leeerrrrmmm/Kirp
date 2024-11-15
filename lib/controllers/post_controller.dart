import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiru/constant.dart';
import 'package:kiru/controllers/user_controller.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../service/api_response.dart';


//get USERS POSTS
Future<ApiResponse> getUsersPosts() async
{
  ApiResponse apiResponse = ApiResponse();
  try{
      String token =  await getToken();
      final response = await http.get(
          Uri.parse('$baseURL/getPosts'),
        headers: {
          'Accept' : 'application/json',
          'Authorization': 'Bearer $token',
        });

      logger.i('getUsersPosts response status: ${response.statusCode}');
      logger.i('getUsersPosts response body: ${response.body}');

      switch(response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
          apiResponse.data as List<dynamic>;
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

//get USER POST
Future<ApiResponse> getUserPost(int userId) async
{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/getUserProfilePosts/$userId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );

    logger.i('getUserProfilePosts response status: ${response.statusCode}');
    logger.i('getUserProfilePosts response body: ${response.body}');

    switch(response.statusCode)
        {
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
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



//get getPofilePostsById I
Future<ApiResponse> getPofilePostsById(int postId) async
{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$baseURL/getPofilePostsById/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token',
        }
    );

    logger.i('getPofilePostsById response status: ${response.statusCode}');
    logger.i('getPofilePostsById response body: ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
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

//get getPostId
Future<ApiResponse> getPostId(int postId) async
{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$baseURL/getPostId/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token',
        }
    );

    logger.i('getPostId response status: ${response.statusCode}');
    logger.i('getPostId response body: ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
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



//createPosts
Future<ApiResponse> createPost(String body, String? image) async
{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();

    final response = await http.post(
      Uri.parse('$baseURL/createPost',
      ),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      },
      body: image != null
        ?
      {
        'body' : body,
        'image' : image,
      }
        :
      {
        'body' : body
      }
    );


    logger.i('CreatePost response status: ${response.statusCode}');
    logger.i('CreatePost response body: ${response.body}');

    switch(response.statusCode)
        {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        Get.snackbar(
          'Succes',
          'Post Created',
          colorText:Colors.white,
          snackPosition: SnackPosition.TOP
        );
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.key.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e)
  {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//update Posts
Future<ApiResponse> updatePost(int postId, String body) async{
  ApiResponse apiResponse = ApiResponse();
    try{
      String token = await getToken();
      var data = {
        'body' : body,
      };
      final response = await http.put(
        Uri.parse('$baseURL/updatePost/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token',
        },
        body: data,
      );


      logger.i('updatePost response status: ${response.statusCode}');
      logger.i('updatePost response body: ${response.body}');

      switch(response.statusCode)
      {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
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

//delete Post
Future<ApiResponse> deletePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseURL/deletePost/$postId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );


    logger.i('deletePost response status: ${response.statusCode}');
    logger.i('deletePost response body: ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

//Like or Unlike Posts
Future<ApiResponse> likeOrUnlike(int postId) async
{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$baseURL/likeOrUnlike/$postId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );


    logger.i('likeOrUnlike response status: ${response.statusCode}');
    logger.i('likeOrUnlike response body: ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//Get From Users Liked Posts
Future<ApiResponse> getLikedPosts() async
{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/getLikedPost'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );


    logger.i('getLikedPosts response status: ${response.statusCode}');
    logger.i('getLikedPosts response body: ${response.body}');

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}