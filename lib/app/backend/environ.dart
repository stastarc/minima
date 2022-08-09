import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'auth/auth.dart';

class Environ {
  static const String baseServer = 'nekos.ml';
  static const String authServer = 'auth.$baseServer';
  static const String cdnServer = 'cdn.$baseServer';
  static const String lensServer = 'lens.$baseServer';
  static const String marketServer = 'market.$baseServer';

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

  static Future<TResult?> privateGetResopnse<TResult>(
      String base, String path, TResult Function(dynamic) convert,
      {Map<String, dynamic>? query}) async {
    var req = await privateGet(base, path, query: query);
    if (req.statusCode != 200) {
      throw HttpException('$path ${req.statusCode} ${req.reasonPhrase}');
    }

    try {
      return convert(jsonDecode(utf8.decode(req.bodyBytes)));
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  static Future<Response> privatePost(String base, String path,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) async {
    query ??= {};
    query['token'] = Auth.instance.getToken();
    return await post(await privateApi(base, path, query: query),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        });
  }

  static Future<TResult?> privatePostResopnse<TResult>(
      String base, String path, TResult Function(dynamic) convert,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) async {
    var req = await privatePost(base, path, query: query, body: body);
    if (req.statusCode != 200) {
      throw HttpException('$path ${req.statusCode} ${req.reasonPhrase}');
    }

    try {
      return convert(jsonDecode(utf8.decode(req.bodyBytes)));
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
