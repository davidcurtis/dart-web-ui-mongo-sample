library server;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'dart:json';

part 'src/static_file_handler.dart';

handleSave(HttpRequest req, HttpResponse resp) {
  var buffer = new StringBuffer();
  var input = req.inputStream;
  input.onData = () {
    buffer.add(new String.fromCharCodes(input.read()));
  };
  input.onClosed = () {
    var data = JSON.parse(buffer.toString());
    print(data);
    // store into database
    resp.statusCode = 201;
    resp.outputStream.close();
  };
  input.onError = (error) {
    print(error);
  };
}

init({String basePath}) {
  var db = new Db("mongodb://127.0.0.1/mongo_dart-test");
  DbCollection collection;
  var server = new HttpServer();
  server.addRequestHandler(
      (req) => req.path == '/save',
      handleSave);
  server.defaultRequestHandler = new StaticFileHandler(basePath).onRequest;
  server.onError = (error) => print("Server error: $error");
  
  db.open().then((_) {
    collection = db.collection("entries");
    server.listen("127.0.0.1", 8888);
  });
}