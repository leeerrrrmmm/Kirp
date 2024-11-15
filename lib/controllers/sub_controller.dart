
import 'dart:convert';

import 'package:kiru/controllers/user_controller.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../models/post.dart';
import '../models/sub.dart';
import '../service/api_response.dart';

Future<ApiResponse> subOrunsub(int userId) async
{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$baseURL/subOrUnsub/$userId'),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token',
      }
    );

    logger.i('Subscribe status ${response.statusCode}');
    logger.i('Subscribe body ${response.body}');

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
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  }catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getSubPosts () async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$baseURL/showSubscribedPosts'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token',
        }
    );


    logger.i('getSubPosts response status: ${response.statusCode}');
    logger.i('getSubPosts response body: ${response.body}');

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

Future<ApiResponse> checkSubscriptionStatus(int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/checkSubscriptionStatus/$userId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    logger.i('checkSubscriptionStatus statusCode: ${response.statusCode}');
    logger.i('checkSubscriptionStatus body: ${response.body}');

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['isSubscribed'];
        break;
      case 403:
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    logger.e('Error in checkSubscriptionStatus: $e');
    apiResponse.error = serverError;
  }

  return apiResponse;
}
