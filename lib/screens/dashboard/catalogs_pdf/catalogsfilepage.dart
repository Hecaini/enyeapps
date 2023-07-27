import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../config/api_connection.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class CatalogsFilePage extends StatefulWidget {
  CatalogsFilePage() : super();

  static const String routeName = '/catalogsfile';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CatalogsFilePage()
    );
  }

  final String title = 'Catalogs File';

  @override
  _CatalogsFilePageState createState() => _CatalogsFilePageState();
}

class _CatalogsFilePageState extends State<CatalogsFilePage> {
  late List<CatalogsFile> _catalogsFile;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController catalogsFileName;
  late CatalogsFile _selectedCatalogsFile;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  //kapag wala pa na-select sa file
  String? _dropdownError;

  File? filepath;
  String? filename;
  String? filedata;
  String? showfile;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      if(result != null){
        filepath = File(result.files.single.path ?? " ");
        filename = filepath?.path.split('/').last;
        filedata = base64Encode(filepath!.readAsBytesSync());
        print(filepath);
      }
    });
  }

  double? _progress;
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
        //receiveTimeout: 0
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
  void initState(){
    super.initState();
    _catalogsFile = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    catalogsFileName = TextEditingController();
    _getCatalogsFile();
  }

  _showProgress(String message){
    setState(() {
      _titleProgess = message;
    });
  }

  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _getCatalogsFile(){
    _showProgress('Loading Catalogs File...');
    catalogsFileSvc.getFileCatalogs().then((catalogsFile){
      setState(() {
        _catalogsFile = catalogsFile;
      });
      _showProgress(widget.title);
      print("Length ${catalogsFile.length}");
    });
  }

  _addFileCatalog(){
    if (_formKey.currentState!.validate()) {
      if (filepath == null){
        setState(() => _dropdownError = "Please select a FILE!");
      } else {
        _showProgress('Adding File Catalog...');
        catalogsFileSvc.addFileCatalogs(
            catalogsFileName.text, filename.toString(), filedata.toString())
            .then((result) {
          if ('success' == result) {
            _clearValues();
            _successSnackbar(context, "Successfully added.");
          } else if ('exist' == result) {
            _errorSnackbar(context, "File Name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  _editFileCatalog(CatalogsFile catalogsFile){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      //kapag same picture disregard lang
      if (filepath == null){
        filename = showfile;
        filedata = '';
      }

      _showProgress('Updating Category...');
      catalogsFileSvc.editFileCatalogs(catalogsFile.id, catalogsFileName.text, filename.toString(), filedata.toString()).then((result) {
        if('success' == result){
          setState(() {
            _isUpdating = false;
          });
          _successSnackbar(context, "Edited Successfully");
          _clearValues();
        }  else if('exist' == result){
          _errorSnackbar(context, "Category name EXIST in database.");
        } else {
          _errorSnackbar(context, "Error occured...");
        }

      });
    }
  }

  //delete data by getting classes in services.dart
  _delFileCatalog(CatalogsFile catalogsFile){
    _showProgress('Deleting File Catalog...');
    catalogsFileSvc.deleteFileCatalogs(catalogsFile.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");;
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //emptying textfields
  _clearValues(){
    catalogsFileName.text = '';
    filepath = null;
    filename = null;
    filedata = null;
    _getCatalogsFile();
  }

  //show data to textfield when datatable is clicked
  _showValues(CatalogsFile catalogsFile){
    catalogsFileName.text = catalogsFile.name;
    showfile = catalogsFile.filename;
  }

  //data table select all
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepOrange),)),
            DataColumn(label: Text('FILE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepOrange),)),
            DataColumn(label: Text('VIEW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepOrange),)),
            DataColumn(label: Text('DOWNLOAD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepOrange),)),
          ],
          rows: _catalogsFile.map((CatalogsFile) => DataRow(cells: [
            DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: 100),
                child: Text(CatalogsFile.name.toString(), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true,)),
                onTap: (){
                  _showValues(CatalogsFile);
                  _selectedCatalogsFile = CatalogsFile;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(ConstrainedBox(constraints: BoxConstraints(maxWidth: 100),
                child: Text(CatalogsFile.filename.toString(), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true,)),
                onTap: (){
                  _showValues(CatalogsFile);
                  _selectedCatalogsFile = CatalogsFile; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.red,),
              onPressed: () {
                /*PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: catalogPDFview.routeName,),
                  screen: catalogPDFview(filepath: "${API.fileCatalogsPdf + CatalogsFile.filename.toString()}", filename: "${CatalogsFile.filename.toString()}",),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );*/
              },
            )),
            DataCell(
              _progress != null
              ? const CircularProgressIndicator()
              :IconButton(
                icon: Icon(Icons.download, color: Colors.red,),
                onPressed: () => openFile(
                  url: "${API.fileCatalogsPdf + CatalogsFile.filename.toString()}",
                  filename: "${CatalogsFile.filename.toString()}",
                ),
              )
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delFileCatalog(CatalogsFile);
              },
            )),
          ])).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgess),
        actions: <Widget> [
          IconButton(
              onPressed: (){
                _getCatalogsFile();
              },
              icon: Icon(Icons.refresh)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const SizedBox(height: 20,),
                  NormalTextField(controller: catalogsFileName, hintText: "Catalogs File Name"),

                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: selectFile,
                    child: Stack(
                      children: [
                        filepath != null
                          ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(filename.toString(), style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),),
                            const SizedBox(width: 10,),
                            CircleAvatar(
                              radius: 16,
                              foregroundColor: Colors.deepOrange,
                              child: Icon(Icons.file_upload, color: Colors.deepOrange,),
                            ),
                          ],
                        ) : _isUpdating
                          ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(showfile!, style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),),
                            const SizedBox(width: 10,),
                            CircleAvatar(
                              radius: 16,
                              foregroundColor: Colors.deepOrange,
                              child: Icon(Icons.file_upload, color: Colors.deepOrange,),
                            ),
                          ],
                        )
                          : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Choose File", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Colors.grey.shade600),),
                            const SizedBox(width: 10,),
                            CircleAvatar(
                              radius: 16,
                              foregroundColor: Colors.deepOrange,
                              child: Icon(Icons.file_upload, color: Colors.deepOrange,),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),


                  _dropdownError == null
                    ? SizedBox.shrink()
                    : const SizedBox(height: 10,),
                    Text(
                      _dropdownError ?? "",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5,),
                  _isUpdating ?
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 20,),
                      editButton(
                        onTap: () {
                          _editFileCatalog(_selectedCatalogsFile);
                        },
                        text: 'UPDATE',
                      ),

                      delButton(
                        onTap: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                        text: 'CANCEL',
                      ),
                    ],
                  )
                      : Container(),

                  const SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: _dataBody(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addFileCatalog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

