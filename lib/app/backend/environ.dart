import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'auth/auth.dart';

class Environ {
  static const String baseServer = 'minima.green';
  static const String domainPrefix = (kDebugMode || true) ? 'dev-' : '';
  static const String authServer = '${domainPrefix}auth.$baseServer';
  static const String cdnServer = '${domainPrefix}cdn.$baseServer';
  static const String lensServer = '${domainPrefix}lens.$baseServer';
  static const String marketServer = '${domainPrefix}market.$baseServer';
  static const String myplantServer = '${domainPrefix}plant.$baseServer';

  static String? deviceInfo;

  static Uri api(String base, String path, {Map<String, dynamic>? query}) {
    return Uri.https(base, path,
        query?.map((key, value) => MapEntry(key, value.toString())));
  }

  static Future<Uri> privateApi(String base, String path,
      {Map<String, dynamic>? query}) async {
    query ??= {};
    query['token'] = (await Auth.instance.getToken())!;
    return api(base, path, query: query);
  }

  static Future<Response> privateGet(String base, String path,
      {Map<String, dynamic>? query}) async {
    return await get(await privateApi(base, path, query: query));
  }

  static Future<TResult?> tryResponseParse<TResult>(
      dynamic res, TResult Function(dynamic) convert,
      {TResult? Function(String)? failed}) async {
    String body = utf8.decode(
        res is StreamedResponse ? await res.stream.toBytes() : res.bodyBytes);

    if (kDebugMode) {
      print('HTTP: ${res.request?.url.path} : $body');
    }

    if (res.statusCode != 200) {
      if (failed != null) {
        final r = failed(body);
        if (r != null) return r;
      }
      throw HttpException(
          '${res.request?.url.path} ${res.statusCode} ${res.reasonPhrase}');
    }

    try {
      return convert(jsonDecode(body));
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  static Future<TResult?> privateGetResopnse<TResult>(
      String base, String path, TResult Function(dynamic) convert,
      {Map<String, dynamic>? query}) async {
    return await tryResponseParse(
        await privateGet(base, path, query: query), convert);
  }

  static Future<Response> privatePost(String base, String path,
      {Map<String, dynamic>? query,
      Map<String, dynamic>? body,
      bool jsonencode = true}) async {
    query ??= {};
    query['token'] = Auth.instance.getToken();
    return await post(await privateApi(base, path, query: query),
        body: jsonencode ? jsonEncode(body) : body,
        headers: jsonencode
            ? {
                'Content-Type': 'application/json',
              }
            : null);
  }

  static Future<TResult?> privatePostResopnse<TResult>(
      String base, String path, TResult Function(dynamic) convert,
      {Map<String, dynamic>? query,
      Map<String, dynamic>? body,
      bool jsonencode = true}) async {
    return await tryResponseParse(
        await privatePost(base, path,
            query: query, body: body, jsonencode: jsonencode),
        convert);
  }

  static Future<String> getDeviceInfo() async {
    if (deviceInfo != null) return deviceInfo!;
    return jsonEncode((await DeviceInfoPlugin().deviceInfo).toMap());
  }
}
