class API {
  static const hostConnect = "https://enye.com.ph/enyecontrols_app";
  //static const hostConnect = "http://192.168.0.137/adminenye";

  //login admin
  static const loginAdmin = "$hostConnect/admin/login.php";

  //add user admin
  static const signUpAdmin = "$hostConnect/admin/signup.php";
  static const userSign = "$hostConnect/admin/users_signature/";

  //reset password
  static const resetPassword = "$hostConnect/admin/resetPassword.php";

  //user infos
  static const users = "$hostConnect/admin/features/users.php";
  static const usersImages = "$hostConnect/admin/users_img/";
  static const updateUserSign = "$hostConnect/admin/editUserInfo.php";

  //department data's
  static const department = "$hostConnect/admin/features/department.php";

  //position data's
  static const position = "$hostConnect/admin/features/position.php";

  //technical data's
  static const appointmentData = "$hostConnect/admin/technical/appointment.php";

  //appointment data's
  static const technicalData = "$hostConnect/admin/technical/technical.php";
  static const completeAttachment = "$hostConnect/admin/attachment/";
  static const ECcompAtt = "https://enyecontrols.com/enyecontrols_engineering/attachment/";
  static const ECsoAttach = "https://enyecontrols.com/enyecontrols_engineering/upload/";

  //service order data's
  static const serviceOrderData = "$hostConnect/admin/technical/service_order.php";
  static const conformeSig = "$hostConnect/admin/conforme_signature/";
  static const attachment = "$hostConnect/admin/attachment/";

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

  //booking
  static const ec_calendar = "$hostConnect/ec_calendar.php"; //calendar disable holidays and events

  //schedule
  static const ec_schedule = "$hostConnect/admin/engineering_tsis/schedule.php";
  static const so_tsis = "$hostConnect/admin/engineering_tsis/service_order.php";
  static const ec_conformeSig = "https://enyecontrols.com/enyecontrols_engineering/signs_conforme_by/";
  static const ec_usersSig = "https://enyecontrols.com/enyecontrols_engineering/images/signatures/";
  static const ec_usersImg = "https://enyecontrols.com/enyecontrols_engineering/images/main_users/";

  //engineering users
  static const engUsers = "$hostConnect/admin/engineering_tsis/engineering_users.php";
}