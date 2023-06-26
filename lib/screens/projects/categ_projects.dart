class projCategories {
  final String category;
  final String title;
  final String images;

  projCategories({
    required this.category,
    required this.title,
    required this.images,
  });
}

final List<projCategories> projCategoriesList = [
  projCategories(category: 'ALL', images: 'assets/icons/select-all.png', title: 'ALL'),
  projCategories(category: '7', images: 'assets/icons/proj_school.png', title: 'SCHOOL & LEARNING CENTERS'),
  projCategories(category: '1', images: 'assets/icons/proj_buildings.png', title: 'BUILDINGS'),
  projCategories(category: '2', images: 'assets/icons/proj_hospital.png', title: 'HOSPITALS'),
  projCategories(category: '3', images: 'assets/icons/proj_condo.png', title: 'CONDOMINIUM'),
  projCategories(category: '4', images: 'assets/icons/proj_resort.png', title: 'HOTEL & RESORT'),
  projCategories(category: '5', images: 'assets/icons/proj_airport.png', title: 'INDUSTRIES'),
  projCategories(category: '6', images: 'assets/icons/proj_mall.png', title: 'MALLS'),
];