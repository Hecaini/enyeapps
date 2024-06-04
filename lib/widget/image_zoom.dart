import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageZoomScreen extends StatelessWidget {
  final String imagepath;
  const ImageZoomScreen({required this.imagepath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Specify a fixed height for the SizedBox
              child: RepaintBoundary(
                child: PhotoView(
                  imageProvider: NetworkImage(imagepath),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}