import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

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

  late PDFDocument document;

  bool _usePDFListView = false;

  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        widget.filepath);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _usePDFListView = !_usePDFListView;
              setState(() {});
            },
            child: Icon(
                Icons.cached
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          /*!_usePDFListView
              ? */Expanded(
            child: Center(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PDFViewer(
                document: document,
                zoomSteps: 1,
                //uncomment below line to preload all pages
                // lazyLoad: false,
                // uncomment below line to scroll vertically
                scrollDirection: Axis.vertical,

                // enableSwipeNavigation: false,
                showPicker: false,
                showNavigation: true,
                //uncomment below code to replace bottom navigation with your own
                 navigationBuilder:
                            (context, page, totalPages, jumpToPage, animateToPage) {
                          return ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.first_page),
                                onPressed: () {
                                  jumpToPage(page: 0);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  animateToPage(page: page! - 2);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  animateToPage(page: page);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.last_page),
                                onPressed: () {
                                  jumpToPage(page: totalPages! - 1);
                                },
                              ),
                            ],
                          );
                        },
              ),
            ),
          )
           /*   : Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(),)
                : PDFListViewer(
              document: document,
              preload: true,
            ),
          )*/,
        ],
      ),
    );
  }
}

