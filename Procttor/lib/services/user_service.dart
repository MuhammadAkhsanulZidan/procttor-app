import 'dart:convert';

import 'package:procttor/constant.dart';
import 'package:procttor/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:procttor/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login (String email, String password) async{
  ApiResponse apiResponse=ApiResponse();
  try{
    final response= await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    print('response achieved');

    switch(response.statusCode){
      case 200:
        apiResponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error=errors[errors.keys.elementAt(0)[0]];
        break;
      case 403:
        apiResponse.error=jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error=somethingwentwrong;
        break;
    }
  }
  catch(e){
    //error shown up here
    apiResponse.error="http post failed";
  }

  return apiResponse;
}

Future<ApiResponse> signup (String name, String email, String password) async{
  ApiResponse apiResponse=ApiResponse();
  try{
    final response= await http.post(
      Uri.parse(signupURL),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password
      });

    switch(response.statusCode){
      case 200:
        apiResponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error=errors[errors.keys.elementAt(0)[0]];
        break;
      default:
        apiResponse.error=somethingwentwrong;
        break;
    }
  }
  catch(e){
    apiResponse.error=serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetails () async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token = await getToken();
    final response= await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error=unauthorized;
        break;
      default:
        apiResponse.error=somethingwentwrong;
        break;
    }
  }
  catch(e){
    apiResponse.error=serverError;
  }
  return apiResponse;
}

//get token
Future<String>getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token')??'';
}

//get user id
Future<int>getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

//log out
Future<bool>logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}