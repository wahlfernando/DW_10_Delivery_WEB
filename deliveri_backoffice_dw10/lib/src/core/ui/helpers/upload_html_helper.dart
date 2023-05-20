import 'dart:html';
import 'dart:typed_data';

typedef UploadCallback = void Function(Uint8List file, String fileName);

class UploadHtmlHelper {
  void startUpload(UploadCallback callback) {
    final uploadInut = FileUploadInputElement();
    uploadInut.click();
    uploadInut.onChange.listen((_) {
      handlerFileUpload(uploadInut, callback);
    });
  }

  void handlerFileUpload(
    FileUploadInputElement uploadInput,
    UploadCallback callback,
  ) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final reader = FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((_) {
        final bytes = Uint8List.fromList(reader.result as List<int>);
        callback(bytes, file.name);
      });
    }
  }
}
