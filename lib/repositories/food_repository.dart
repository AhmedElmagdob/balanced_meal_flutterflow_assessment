import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/food_item.dart';

class FoodRepository {
  Future<List<FoodItem>> loadVegetables() async {
    final String data = await rootBundle.loadString('assets/data/Vegetable.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => FoodItem.fromJson(json)).toList();
  }

  Future<List<FoodItem>> loadCarbs() async {
    final String data = await rootBundle.loadString('assets/data/Carb.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => FoodItem.fromJson(json)).toList();
  }

  Future<List<FoodItem>> loadMeats() async {
    final String data = await rootBundle.loadString('assets/data/Meat.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => FoodItem.fromJson(json)).toList();
  }
} 