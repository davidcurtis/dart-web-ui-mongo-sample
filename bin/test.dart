import 'dart:io';

main() {
  for (var i = 0; i < 100; i++) {
    final f = new File("bin/test.dart");
    f.exists().then((bool exists) {
      f.fullPath().then((String fullPath) {
        var input = f.openInputStream();
        input.onData = () {
          var data = input.read();
          print("$i ${data.length}");
        };
        input.onClosed = () => print('$i closed');
      });
    });
  }
}