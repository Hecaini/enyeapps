import 'package:get/get.dart';

import '../navbar/navbar.dart';
import '../pages/about.dart';
import '../pages/home.dart';
import '../pages/projects.dart';
import '../pages/systems.dart';

class AppPage{
  static List<GetPage> routes = [
    GetPage(name: navbar, page: ()=> const NavBar()),
    GetPage(name: home, page: ()=> const HomePage()),
    GetPage(name: systems, page: ()=> const SystemsPage()),
    GetPage(name: projects, page: ()=> const ProjectsPage()),
    GetPage(name: aboutus, page: ()=> const AboutPage()),
  ];

  static getnavbar() => navbar;
  static getHome() => home;
  static getSystems() => systems;
  static getProjects() => projects;
  static getAboutUs() => aboutus;

  static String navbar = '/';
  static String home = '/home';
  static String systems = '/systems';
  static String projects = '/projects';
  static String aboutus = '/aboutus';
}