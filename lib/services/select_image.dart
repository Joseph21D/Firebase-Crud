import 'package:image_picker/image_picker.dart';

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  /*if (image != null) {
    setState(() {
      imageToUpload = File(image.path);
    });
  }*/


  return image;
}