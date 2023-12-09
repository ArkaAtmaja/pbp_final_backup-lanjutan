import 'package:news_c_kelompok4/model/user_model.dart';

import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/user';
  static final String userendpoint = '/api/users';
  //static final String registerEndPoint = '/api/register';
  static final String loginEndPoint = '/api/login';
  

  static final String urlHP = '192.168.2.22';
  //static final String registerEndPointHP = 'API_NEWS/api/register';
  static final String loginEndPointHP = 'API_NEWS/api/login';
  static final String endpointHP = 'API_NEWS/api/user';
  static final String userendpointHP = 'API_NEWS/api/users';
 
   static Client? _httpClient; 

  static Client get httpClient {
    if (_httpClient == null) {
     
      _httpClient = Client();
    }
    return _httpClient!;
  }
  static set httpClient(Client client) {
    _httpClient = client;
  }

  static Future<Map<String, dynamic>> getUserByUsername(String username) async {
    try {
      var response = await get(Uri.http(url, '$userendpoint/$username'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      var response = await get(Uri.http(url, '$userendpoint/$email'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<User> login(String username, String password) async {
    try {
      var response = await post(Uri.http(url, loginEndPoint),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(User user) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<bool> checkEmail(String email) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$email'));

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return json.decode(response.body)['unique'];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(User user) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${user.id}'),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
