import 'package:flutter/material.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class editCatalogsPage extends StatefulWidget {
  static const String routeName = '/editcatalog';

  Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => editCatalogsPage(catalogs: catalogs)
    );
  }

  final Catalogs catalogs;
  editCatalogsPage({required this.catalogs});
  final String title = 'Edit Catalogs';

  @override
  _editCatalogsPageState createState() => _editCatalogsPageState();
}

class _editCatalogsPageState extends State<editCatalogsPage> {
  late String _titleProgess;
  late List<Categories> _categories;
  late List<subCategories> _filteredsubcategories;
  late List<subCategories> _subcategories;
  late List<Products> _filteredproducts;
  late List<Products> _products;
  late List<Manufacturer> _manufacturer;
  late TextEditingController modelName;
  late TextEditingController sized;
  late TextEditingController salePrice;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _titleProgess = widget.title;
    modelName = TextEditingController();
    sized = TextEditingController();
    salePrice = TextEditingController();
    _filteredproducts = [];
    _filteredsubcategories = [];
    _categories = [];
    _subcategories = [];
    _products = [];
    _manufacturer = [];
    _getCategories();
    _getSubCategories();
    _getProducts();
    _getMfr();
    _showValues(widget.catalogs);
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

  _editCatalogs(Catalogs catalogs){
    if (_formKey.currentState!.validate()) {
      if (valueChooseCategory == null) {
        setState(() => _dropdownError = "Please select a CATEGORY !");
      } else if (valueChooseSubCategory == null) {
        setState(() => _dropdownError = "Please select a SUB CATEGORY !");
      } else if (valueChooseProduct == null) {
        setState(() => _dropdownError = "Please select a PRODUCT !");
      } else if (valueChooseMfr == null) {
        setState(() => _dropdownError = "Please select a MANUFACTURER !");
      } else {
        catalogsServices.editCatalogs(
          catalogs.id,
          modelName.text, sized.text,
          salePrice.text,
          valueChooseCategory.toString(),
          valueChooseSubCategory.toString(),
          valueChooseProduct.toString(),
          valueChooseMfr.toString()
        ).then((
            result) {
          if ('success' == result) {
            _successSnackbar(context, "Edited Successfully");
          } else if ('exist' == result) {
            _errorSnackbar(context, "Catalog Name EXIST in database.");
          } else {
            _errorSnackbar(context, "Error occured...");
          }
        });
      }
    }
  }

  //kapag wala pa na-select sa option
  String? _dropdownError;

  //dropdown CATEGORY uses
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
          if (valueChooseSubCategory != null || valueChooseProduct != null){
            _filteredsubcategories.clear();
            valueChooseSubCategory = null;

            _filteredproducts.clear();
            valueChooseProduct = null;
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

  //dropdown SUB CATEGORY uses
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
          if (valueChooseProduct != null){
            _filteredproducts.clear();
            valueChooseProduct = null;
          }
          _filteredproducts = _products.where((Products) => Products.subcategory_id.toString() == value && Products.category_id.toString() == valueChooseCategory).toList();
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

  //dropdown PRODUCTS uses

  _getProducts(){
    _showProgress('Loading Products...');
    productServices.getProducts().then((Products){
      setState(() {
        _products = Products;
      });
      _showProgress(widget.title);
      print("Length ${Products.length}");
    });
  }

  String? valueChooseProduct;
  DropdownButton _productList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChooseProduct,
      onChanged: (value) {
        setState(() {
          valueChooseProduct = value;
        });
      },
      hint: Text("Select Product"),
      items: _filteredproducts.map((Products) => DropdownMenuItem(
        value: Products.id.toString(),
        child: Text(Products.name.toString()),
      )).toList(),
    );
  }

  //dropdown MANUFACTURER uses

  _getMfr(){
    _showProgress('Loading Manufacturers...');
    mfrServices.getManufacturer().then((mfr){
      setState(() {
        _manufacturer = mfr;
      });
      _showProgress(widget.title);
      print("Length ${mfr.length}");
    });
  }

  String? valueChooseMfr;
  DropdownButton _manufacturerList(){
    return DropdownButton(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      iconSize: 36,
      iconEnabledColor: Colors.deepOrange,
      isExpanded: true,
      value: valueChooseMfr,
      onChanged: (value) {
        setState(() {
          valueChooseMfr = value;
        });
      },
      hint: Text("Select Manufacturer"),
      items: _manufacturer.map((Manufacturer) => DropdownMenuItem(
        value: Manufacturer.id.toString(),
        child: Text(Manufacturer.name.toString()),
      )).toList(),
    );
  }

  _showValues(Catalogs catalogs){
    modelName.text = catalogs.model_name;
    sized.text = catalogs.sized;
    salePrice.text = catalogs.sale_price;
    valueChooseCategory = catalogs.category_id;
    valueChooseMfr = catalogs.manufacturer_id;
    _filteredsubcategories = _subcategories.where((subCategories) => subCategories.category_id.toString() == catalogs.category_id).toList();
    _filteredproducts = _products.where((Products) => Products.subcategory_id.toString() == catalogs.subCat_id && Products.category_id.toString() == catalogs.category_id).toList();
    valueChooseSubCategory = catalogs.subCat_id;
    valueChooseProduct = catalogs.products_id;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(_titleProgess, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      /*drawer: CustomDrawer(),*/
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                NormalTextField(controller: modelName, hintText: "Model Name"),

                const SizedBox(height: 20,),
                NormalTextField(controller: sized, hintText: "Sized"),

                const SizedBox(height: 20,),
                NormalTextField(controller: salePrice, hintText: "Sale Price"),

                const SizedBox(height: 20,),
                _categoryList(),

                const SizedBox(height: 20,),
                //kapag walang laman yung subCategory list or di pa na-select Category, naka-hide
                _filteredsubcategories.isEmpty ? Container() : _subcategoryList(),

                const SizedBox(height: 20,),
                //kapag walang laman yung Products list or di pa na-select Sub Category, naka-hide
                _filteredproducts.isEmpty ? Container() : _productList(),

                const SizedBox(height: 20,),
                _manufacturerList(),

                _dropdownError == null
                    ? SizedBox.shrink()
                    : Text(
                  _dropdownError ?? "",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _editCatalogs(widget.catalogs);
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

