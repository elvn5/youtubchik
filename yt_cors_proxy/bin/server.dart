import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<Response> _requestHandler(Request req) async {
  final target = req.url.replace(scheme: 'https', host: 'i.ytimg.com');
  final response = await http.get(target);
  return Response.ok(response.bodyBytes, headers: response.headers);
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: {ACCESS_CONTROL_ALLOW_ORIGIN: '*'}))
      .addHandler(_requestHandler);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}