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
  static const String myplantServer = 'plant.$baseServer';

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
      dynamic res, TResult Function(dynamic) convert) async {
    if (res.statusCode != 200) {
      throw HttpException(
          '${res.request?.url.path} ${res.statusCode} ${res.reasonPhrase}');
    }

    try {
      dynamic data;
      if (res is Response) {
        data = jsonDecode(utf8.decode(res.bodyBytes));
      } else if (res is StreamedResponse) {
        data = jsonDecode(utf8.decode(await res.stream.toBytes()));
      } else {
        throw ArgumentError('res must be Response or StreamedResponse');
      }
      return convert(data);
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
        headers: {
          'Content-Type': 'application/json',
        });
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
}
