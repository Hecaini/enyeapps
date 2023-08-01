import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = new ImagePicker();
  var getimage = await imagePicker.pickImage(source: ImageSource.gallery);

  if(getimage != null){
    return await getimage.path;
  }

  print("No Images Selected !");
}