
import 'dart:convert';

import 'package:enye_app/config/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage() : super();

  static const String routeName = '/products';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductsPage()
    );
  }

  final String title = 'Products';


  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  late List<Categories> _categories;
  late List<subCategories> _subcategories;
  late List<subCategories> _filteredsubcategories;
  late List<Products> _products;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController productName;
  late TextEditingController productDescription;
  late Products _selectedProduct;
  late bool _isUpdating;
  late String _titleProgess;
  final _formKey = GlobalKey<FormState>();

  File? imagepath;
  String? imagename;
  String? imagedata;
  String? showimage;
  ImagePicker imagePicker = new ImagePicker();

  Future<void> selectImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
    });
  }

  @override
  void initState(){
    super.initState();
    _categories = [];
    _subcategories = [];
    _filteredsubcategories = [];
    _products = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey(); //key to get the context to show a Snackbar
    productName = TextEditingController();
    productDescription = TextEditingController();
    _getCategories();
    _getProducts();
    _getSubCategories();
  }

  _showProgress(String message){
    setState(() {
      _titleProgess = message;
    });
  }

  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.75,),
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
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.75,),
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

  _getProducts(){
    _showProgress('Loading Categories...');
    productServices.getProducts().then((Products){
      setState(() {
        _products = Products;
      });
      _showProgress(widget.title);
      print("Length ${Products.length}");
    });
  }

  _addProducts(){
    if (_formKey.currentState!.validate()) {
      if (valueChooseCategory == null || valueChooseSubCategory == null) {
        setState(() => _dropdownError = "Please select an OPTION!");
      } else if (imagepath == null) {
        setState(() => _dropdownError = "Please select an IMAGE!");
      } else {
        setState(() => _dropdownError = "");
        _showProgress('Adding Products...');
        productServices.addProducts(productName.text, productDescription.text, valueChooseCategory.toString(), valueChooseSubCategory.toString(), imagename!, imagedata!).then((result) {
          if('success' == result){
            _clearValues();
            _successSnackbar(context, "Successfully added.");
          } else if('exist' == result){
            _errorSnackbar(context, "Product Name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  _editProducts(Products products){
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      if (valueChooseCategory == null || valueChooseSubCategory == null) {
        setState(() => _dropdownError = "Please select an option!");
      } else {

        //kapag same picture disregard lang
        if (imagepath == null){
          imagename = showimage;
          imagedata = '';
        }

        _showProgress('Updating Products...');
        productServices.editProducts(
            products.id, productName.text, productDescription.text, valueChooseCategory.toString(), valueChooseSubCategory.toString(), imagename!, imagedata!).then((
            result) {
          if ('success' == result) {
            setState(() {
              _isUpdating = false;
            });
            _successSnackbar(context, "Edited Successfully");
            _clearValues();
          } else if ('exist' == result) {
            _errorSnackbar(context, "Product Name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  //delete data by getting classes in services.dart
  _delProducts(Products products){
    _showProgress('Deleting Category...');
    productServices.deleteProducts(products.id).then((result) {
      //if echo json from PHP is success
      if('success' == result){
        _successSnackbar(context, "Deleted Successfully");//refresh the list after update
        _clearValues();
      } else {
        _errorSnackbar(context, "Error occured...");
      }
    });
  }

  //emptying textfields
  _clearValues(){
    _getCategories();
    _getSubCategories();
    _getProducts(); //refresh the list after update
    productName.text = '';
    productDescription.text = '';
    _filteredsubcategories.clear();
    valueChooseSubCategory = null;
    valueChooseCategory = null;
    imagepath = null;
    showimage = null;
  }

  //show data to textfield when datatable is clicked
  _showValues(Products products){
    showimage = products.image;
    productName.text = products.name;
    productDescription.text = products.desc;
    valueChooseCategory = products.category_id;
    valueChooseSubCategory = products.subcategory_id;
    _filteredsubcategories = _subcategories.where((subCategories) => subCategories.category_id.toString() == products.category_id).toList();
  }

  _getCategories(){
    _showProgress('Loading Categories...');
    categoriesServices.getCategories().then((categories){
      setState(() {
        _categories = categories;
      });
      _showProgress(widget.title);
      print("Length ${categories.length}");
    });
  }

  //kapag wala pa na-select sa option
  String? _dropdownError;

  //category list at dropdown button
  String? valueChooseCategory;
  DropdownButton _categoryList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChooseCategory,
      onChanged: (value) {
        setState(() {
          if (valueChooseSubCategory != null){
            _filteredsubcategories.clear();
            valueChooseSubCategory = null;
          }
          _filteredsubcategories = _subcategories.where((subCategories) => subCategories.category_id.toString() == value).toList();
          valueChooseCategory = value;
        });
      },
      hint: Text("Select Category"),
      items: _categories.map((categories) => DropdownMenuItem(
        value: categories.id.toString(),
        child: Text(categories.name.toString()),
      )).toList(),
    );
  }

  _getSubCategories(){
    _showProgress('Loading Sub Categories...');

    subCatServices.getSubCategories().then((subCategories){ //para pumunta sa PHP file na subCategories at hindi sa PRODUCTS
      setState(() {
        _subcategories = subCategories;
      });
      _showProgress(widget.title);
      print("Length ${subCategories.length}");
    });
  }

  String? valueChooseSubCategory;
  DropdownButton _subcategoryList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChooseSubCategory,
      onChanged: (value) {
        setState(() {
          valueChooseSubCategory = value;
        });
      },
      hint: Text("Select Sub Category"),
      items: _filteredsubcategories.map((subCategories) => DropdownMenuItem(
        value: subCategories.id.toString(),
        child: Text(subCategories.name.toString()),
      )).toList(),
    );
  }

  //data table select all
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('Sub Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
            DataColumn(label: Text('DELETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),)),
          ],
          rows: _products.map((Products) => DataRow(cells: [
            DataCell(CircleAvatar(
              backgroundImage: NetworkImage(API.productImages + Products.image.toString()),
            ),
                onTap: (){
                  _showValues(Products);
                  _selectedProduct = Products;
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(Products.name.toString()),
                onTap: (){
                  _showValues(Products);
                  _selectedProduct = Products; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(Products.desc.toString()),
                onTap: (){
                  _showValues(Products);
                  _selectedProduct = Products; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(_categories.where((categories) => categories.id.toString() == Products.category_id.toString()).elementAt(0).name),
                onTap: (){
                  _showValues(Products);
                  _selectedProduct = Products; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(Text(_subcategories.where((subCategories) => subCategories.id.toString() == Products.subcategory_id.toString()).elementAt(0).name),
                onTap: (){
                  _showValues(Products);
                  _selectedProduct = Products; //set the selected category to update
                  setState(() {
                    _isUpdating = true; //set flag updating to show buttons
                  });
                }),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                _delProducts(Products);
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
                _getProducts();
              },
              icon: Icon(Icons.refresh)
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                InkWell(
                  onTap: selectImage,
                  child: Stack(
                    children: [
                      imagepath != null
                      ? CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(imagepath!),
                      ) : _isUpdating
                      ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(API.productImages + showimage!),
                      )
                      : CircleAvatar(
                        radius: 64,
                        foregroundColor: Colors.deepOrange,
                        child: Icon(Icons.photo, color: Colors.deepOrange, size: 50,),
                      ),
                      
                      Positioned(child: Icon(Icons.add_a_photo, color: Colors.deepOrange,), bottom: 2, left: 90,),
                    ],
                  ),
                ),

                const SizedBox(height: 10,),
                NormalTextField(controller: productName, hintText: "Product Name"),

                const SizedBox(height: 10,),
                NormalTextField(controller: productDescription, hintText: "Product Description"),

                const SizedBox(height: 10,),
                _categoryList(),

                const SizedBox(height: 5,),
                //kapag walang laman yung subCategory list or di pa na-select Category, naka-hide
                _filteredsubcategories.isEmpty ? Container() : _subcategoryList(),

                _dropdownError == null
                  ? SizedBox.shrink()
                  : Text(
                    _dropdownError ?? "",
                    style: TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 5,),
                _isUpdating ?
                  Row(
                  children: <Widget>[
                    const SizedBox(width: 20,),
                    editButton(
                      onTap: () {
                        _editProducts(_selectedProduct);
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
                ) : Container(),

                const SizedBox(height: 5,),
                Expanded(
                  child: _dataBody(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addProducts();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

