class API {
  static const hostConnect = "http://192.168.0.137/adminenye";
  static const hostConnectAdminUser = "$hostConnect/admin";

  //product images
  static const productImages = "$hostConnect/admin/products_img/";

  //file catalogs pdf
  static const fileCatalogsPdf = "$hostConnect/admin/catalog_pdf/";

  //sign-up admin user
  static const signUpAdmin = "$hostConnect/admin/signup.php";

  //login admin user
  static const loginAdmin = "$hostConnect/admin/login.php";

  //check session start
  static const userSession = "$hostConnect/admin/config.php";

  //sub categories (FROM CATALOGS SCREEN) actions
  static const manufacturer = "$hostConnect/admin/catalogs_screen/manufacturer.php";

  //categories (FROM CATALOGS SCREEN) actions
  static const categories = "$hostConnect/admin/catalogs_screen/categories.php";

  //sub categories (FROM CATALOGS SCREEN) actions
  static const subcategories = "$hostConnect/admin/catalogs_screen/subCategories.php";

  //products (FROM CATALOGS SCREEN) actions
  static const products = "$hostConnect/admin/catalogs_screen/products.php";

  //catalogs actions
  static const catalogs = "$hostConnect/admin/catalogs.php";

  //catalogs files (FROM DASHBOARD SCREEN) actions
  static const fileCatalogs = "$hostConnect/admin/dashboard/file_catalogs.php";
}