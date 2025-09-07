import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/presentation/bloc/sightingsbloc/sightings_bloc.dart';
import 'package:pokemon/presentation/services/camera_gallery_service.dart';

class SightingsScreen extends StatefulWidget {
  const SightingsScreen({super.key});

  @override
  State<SightingsScreen> createState() => _SightingsScreenState();
}

class _SightingsScreenState extends State<SightingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SightingsBloc>().add(LoadSightings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Avistamientos")),
      body: BlocBuilder<SightingsBloc, SightingsState>(
        builder: (context, state) {
          if (state is SightingsLoading || state is SightingsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SightingsLoaded) {
            if (state.sightings.isEmpty) {
              return const Center(child: Text("No hay avistamientos aún"));
            }
            return ListView.builder(
              itemCount: state.sightings.length,
              itemBuilder: (context, index) {
                final sighting = state.sightings[index];
                return ListTile(
                  leading: Image.file(
                    File(sighting.imagePath),
                    width: 70,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    "Avistamiento - ${sighting.timestamp.toLocal()}",
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(
                    "Lat: ${sighting.latitude}, Lng: ${sighting.longitude}",
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<SightingsBloc>().add(DeleteSighting(index));
                    },
                  ),
                );
              },
            );
          } else if (state is SightingsError) {
            return Center(child: Text("Error al cargar los avistamientos"));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerSighting(context),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
