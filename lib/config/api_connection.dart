class API {
  //static const hostConnect = "https://enye.com.ph/enyecontrols_app";
  static const hostConnect = "http://192.168.0.137/adminenye";

  //login admin
  static const loginAdmin = "$hostConnect/admin/login.php";

  //add user admin
  static const signUpAdmin = "$hostConnect/admin/signup.php";

  //user infos
  static const users = "$hostConnect/admin/features/users.php";
  static const usersImages = "$hostConnect/admin/users_img/";

  //department data's
  static const department = "$hostConnect/admin/features/department.php";

  //position data's
  static const position = "$hostConnect/admin/features/position.php";

  //technical data's
  static const technicalData = "$hostConnect/admin/technical/technical.php";

  //product images
  static const productImages = "$hostConnect/admin/products_img/";

  //file catalogs pdf
  static const fileCatalogsPdf = "$hostConnect/admin/system_catalog_pdf/";

  //sub categories (FROM PRODUCTS SCREEN) actions
  static const manufacturer = "$hostConnect/admin/products_screen/manufacturer.php";

  //categories (FROM PRODUCTS SCREEN) actions
  static const categories = "$hostConnect/admin/products_screen/categories.php";

  //sub categories (FROM PRODUCTS SCREEN) actions
  static const subcategories = "$hostConnect/admin/products_screen/subCategories.php";

  //products (FROM PRODUCTS SCREEN) actions
  static const products = "$hostConnect/admin/products_screen/products.php";

  //catalogs actions
  static const catalogs = "$hostConnect/admin/products_screen/products_model.php";

  //catalogs files (FROM DASHBOARD SCREEN) actions
  static const fileCatalogs = "$hostConnect/admin/dashboard/systems_catalog.php";

  //push notif to frontend
  static const pushNotif = "$hostConnect/admin/pushNotifAdmin.php";

  //token table
  static const token = "$hostConnect/admin/token.php";
}