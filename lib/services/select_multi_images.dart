import 'package:image_picker/image_picker.dart';

Future<List<XFile>> getImages() async {
  final ImagePicker picker = ImagePicker();
  List<XFile> lstImages = await picker.pickMultiImage();
  return lstImages;
}