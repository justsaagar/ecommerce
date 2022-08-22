// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:ecommerce_getx/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RestConstants {
  static const baseUrl = 'http://205.134.254.135/~mobile/MtProject/public/api/';
  static const productList = 'product_list.php';
}

class RestServices {
  static Map<String, String> headers = {
    'content-type': 'application/json',
    'token': 'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz',
  };

  static void showRequestLogs(Uri url, {Map<String, String>? headers}) {
    logs('<----------------- Requested server data Logs ----------------->');
    logs('Requested url --> $url');
    logs('Header --> $headers');
    logs('<----------------- Requested server data Logs ----------------->');
  }

  static void showResponseLogs({@required Response? response}) {
    logs('<----------------- Requested server data Logs ----------------->');
    logs('Response --> ${response!.statusCode} : ${response.request!.url}');
    logs('RHeader --> ${response.request!.headers}');
    logs('Response body --> ${response.body}');
    logs('<----------------- Requested server data Logs ----------------->');
  }

  static dynamic getRestCall(BuildContext context, String endPoint) async {
    String? responseData;
    try {
      Uri? requestedUri = Uri.tryParse('${RestConstants.baseUrl}$endPoint');
      showRequestLogs(requestedUri!);

      Response response = await http.get(requestedUri, headers: headers);

      if (response != null) {
        showResponseLogs(response: response);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
        case 400:
        case 404:
          logs('${response.statusCode} : Something went wrong.');
          break;
        case 401:
          logs('${response.statusCode} : Something went wrong with authorization.');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in Get rest call --> ${e.message}');
    } on SocketException catch (e) {
      logs('SocketException in Get rest call --> ${e.message}');
    }
    return responseData;
  }
}
