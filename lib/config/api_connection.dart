class API {
  static const hostConnect = "http://192.168.0.137/enye_app";
  static const hostConnectAdminUser = "$hostConnect/admin";

  //sign-up admin user
  static const signUpAdmin = "$hostConnect/admin/signup.php";

  //login admin user
  static const loginAdmin = "$hostConnect/admin/login.php";

  //check session start
  static const userSession = "$hostConnect/admin/config.php";

  //sub categories actions
  static const manufacturer = "$hostConnect/admin/manufacturer.php";

  //categories actions
  static const categories = "$hostConnect/admin/categories.php";

  //sub categories actions
  static const subcategories = "$hostConnect/admin/subCategories.php";

  //products actions
  static const products = "$hostConnect/admin/products.php";

  //catalogs actions
  static const catalogs = "$hostConnect/admin/catalogs.php";
}