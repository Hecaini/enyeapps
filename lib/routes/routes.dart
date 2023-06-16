import 'package:get/get.dart';

import '../navbar/navbar.dart';
import '../pages/about.dart';
import '../pages/comp_profile.dart';
import '../pages/home.dart';
import '../pages/projects.dart';
import '../pages/social_media.dart';
import '../sample_form/systemsform.dart';

class AppPage{
  static List<GetPage> routes = [
    GetPage(name: navbar, page: ()=> const NavBar()),
    GetPage(name: home, page: ()=> HomePage(), children: [
      GetPage(name: systems, page: ()=> const SystemsForm()),
      GetPage(name: projects, page: ()=> const ProjectsPage()),
    ]),
    GetPage(name: aboutus, page: ()=> const AboutPage()),
    GetPage(name: comprofile, page: ()=> CompProfilePage()),
    GetPage(name: socialmedia, page: ()=> const SocialmediaPage()),
  ];

  static getnavbar() => navbar;
  static getHome() => home;
  static getSystems() => systems;
  static getProjects() => projects;
  static getAboutUs() => aboutus;
  static getComprofile() => comprofile;
  static getSocialmedia() => socialmedia;

  static String navbar = '/';
  static String home = '/home';
  static String systems = '/systems';
  static String projects = '/projects';
  static String aboutus = '/aboutus';
  static String comprofile = '/comprofile';
  static String socialmedia = '/socialmedia';
}