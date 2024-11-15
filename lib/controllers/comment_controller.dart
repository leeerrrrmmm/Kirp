import 'dart:convert';
import 'package:kiru/constant.dart';
import 'package:kiru/controllers/user_controller.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
import '../service/api_response.dart';

Future<ApiResponse> createComment(int postId, String? comment) async
{
  ApiResponse apiResponse = ApiResponse();

  try{
      String token = await getToken();
      final response = await http.post(
        Uri.parse('$baseURL/createComment/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token',
        },
        body: {
          'comment' : comment,
        }
      );

      logger.i('createComment response status: ${response.statusCode}');
      logger.i('createComment response body: ${response.body}');

      switch(response.statusCode)
      {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 403:
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


Future<ApiResponse> getComments(int postId) async
{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/getCom/$postId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body)['comments'].map((p) => Comment.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> updateComment(String? comment, int commentId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$baseURL/changeCom/$commentId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: {
        'comment' : comment
      }
    );

    switch(response.statusCode)
    {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseURL/deleteCom/$commentId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      }
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
      default:
        apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}