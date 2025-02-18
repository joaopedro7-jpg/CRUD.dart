import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart';

class PlanetProvider with ChangeNotifier {
  List<Planet> _planets = [];

  List<Planet> get planets => _planets;

  Future<void> loadPlanets() async {
    _planets = await DatabaseHelper.instance.getPlanets();
    notifyListeners();
  }

  Future<void> addPlanet(Planet planet) async {
    await DatabaseHelper.instance.createPlanet(planet);
    await loadPlanets();
  }

  Future<void> updatePlanet(Planet planet) async {
    await DatabaseHelper.instance.updatePlanet(planet);
    await loadPlanets();
  }

  Future<void> deletePlanet(int id) async {
    await DatabaseHelper.instance.deletePlanet(id);
    await loadPlanets();
  }
}
