part of server;

class StaticFileHandler {
  final String basePath;

  StaticFileHandler(this.basePath);

  _send404(HttpResponse response) {
    response.statusCode = HttpStatus.NOT_FOUND;
    response.outputStream.close();
  }

  // TODO: etags, last-modified-since support
  onRequest(HttpRequest request, HttpResponse response) {
    final String path = request.path.endsWith('/') ?
        '${request.path}index.html' : request.path;
    final File file = new File('${basePath}${path}');
    file.exists().then((found) {
      if (found) {
        file.fullPath().then((final String fullPath) {
          if (!fullPath.startsWith(basePath)) {
            _send404(response);
          } else {
            file.length().then((final int length) {
              response.headers.set("Content-Length", length);
              file.openInputStream().pipe(response.outputStream);
            });
          }
        });
      } else {
        _send404(response);
      }
    });
  }
}