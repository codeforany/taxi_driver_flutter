import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_driver/common/color_extension.dart';

class ImagePickerView extends StatefulWidget {
  final Function(String) didSelect;
  const ImagePickerView({super.key, required this.didSelect});

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Container(
      width: media.width * 0.9,
      height: media.width * 0.7,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 4, spreadRadius: 4)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Image Picker",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: TColor.primaryText,
            ),
          ),
          SizedBox(
            height: media.width * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    getImageCamera();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 100,
                    color: TColor.primaryText,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    getImageGallery();
                  },
                  child: Icon(
                    Icons.image,
                    size: 100,
                    color: TColor.primaryText,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Take Photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.primaryText, fontSize: 17),
                ),
              ),
              Expanded(
                child: Text(
                  "Gallery",
                    textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.primaryText, fontSize: 17),
                ),
              ),
            ],
          ),
          SizedBox(
            height: media.width * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  dismiss();
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void dismiss() {
    Navigator.pop(context);
  }

  Future getImageCamera() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        widget.didSelect(pickedFile.path);
        dismiss();
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future getImageGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        widget.didSelect(pickedFile.path);
        dismiss();
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
