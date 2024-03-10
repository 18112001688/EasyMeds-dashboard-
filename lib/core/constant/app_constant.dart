import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/images.dart';
import 'package:medcs_dashboard/models/category_model.dart';

class AppConstent {
  static List<CategoryModel> categoriesList = [
    CategoryModel(
      categoryName: 'beauty',
      id: 'beauty',
      image: AppImages.beauty,
    ),
    CategoryModel(
      categoryName: 'basic',
      id: 'basic',
      image: AppImages.basic,
    ),
    CategoryModel(
      categoryName: 'Supplements',
      id: 'Supplements',
      image: AppImages.vitmin,
    ),
    CategoryModel(
      categoryName: 'Lifestyle',
      id: 'Lifestyle',
      image: AppImages.lifeStyle,
    ),
    CategoryModel(
      categoryName: 'Health',
      id: 'Health',
      image: AppImages.health,
    ),
    CategoryModel(
      categoryName: 'Family',
      id: 'Family',
      image: AppImages.family,
    ),
  ];

  static List<DropdownMenuItem<String>> get categoriesDropDownList {
    return List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index].categoryName,
        child: Text(
          categoriesList[index].categoryName,
        ),
      ),
    );
  }
}
