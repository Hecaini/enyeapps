import 'dart:io';

import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class catalogPDFview extends StatefulWidget {
  static const String routeName = '/catalogPDFview';

  final String filepath;
  final String filename;
  catalogPDFview({required this.filepath, required this.filename});

  static Route route({required String filepath, required String filename}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => catalogPDFview(filepath: filepath, filename: filename,)
    );
  }

  @override
  State<catalogPDFview> createState() => _catalogPDFviewState();
}

class _catalogPDFviewState extends State<catalogPDFview> {
  bool _isLoading = true;
  double? _progress;

  late PDFDocument document;

  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        widget.filepath);
    setState(() => _isLoading = false);
  }

  Future openFile ({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) return;

    print('Path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future <File?> downloadFile (String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        //receiveTimeout: Duration(milliseconds: 0),
      ),
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          _progress = recivedBytes / totalBytes;
          if (_progress == 1.0){
            _progress = null;
          }
        });
        print(_progress);
      }
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        actions: <Widget>[
          _progress != null
          ? const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.white),)
          : GestureDetector(
            onTap: () => openFile(
              url: widget.filepath,
              filename: widget.filename,
            ),
            child: Icon(
                Icons.download
            ),
          ),

          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Center(
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(

            scrollDirection: Axis.vertical,
            document: document,
        )),
    );
  }
}

