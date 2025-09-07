import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pokemon/infrastructure/model/sighting_model.dart';
import 'package:pokemon/presentation/bloc/sightingsbloc/sightings_bloc.dart';

Future<void> registerSighting(BuildContext context) async {
  try {
    final picker = ImagePicker();
    LocationPermission permission = await Geolocator.checkPermission();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final savedPath = await saveImagePermanently(pickedFile.path);

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permiso de ubicación denegado");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permiso de ubicación denegado permanentemente");
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(),
    );

    final sighting = Sighting(
      imagePath: savedPath,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );

    context.read<SightingsBloc>().add(AddSighting(sighting));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error registrando avistamiento: $e")),
    );
  }
}

Future<String> saveImagePermanently(String imagePath) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = path.basename(imagePath);
  final newPath = '${directory.path}/$name';
  final newFile = await File(imagePath).copy(newPath);
  return newFile.path;
}
