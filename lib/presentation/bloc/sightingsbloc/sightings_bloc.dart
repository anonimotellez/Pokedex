import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/infrastructure/model/sighting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sightings_event.dart';
part 'sightings_state.dart';

class SightingsBloc extends Bloc<SightingsEvent, SightingsState> {
  final SharedPreferences prefs;

  SightingsBloc(this.prefs) : super(SightingsInitial()) {
    on<LoadSightings>(_onLoadSightings);
    on<AddSighting>(_onAddSighting);
    on<DeleteSighting>(_onDeleteSighting);
  }

  void _onLoadSightings(LoadSightings event, Emitter<SightingsState> emit) {
    final data = prefs.getStringList("sightings") ?? [];

    final sightings = data
        .map((e) => Sighting.fromJson(jsonDecode(e)))
        .toList();

    emit(SightingsLoaded(sightings));
  }

  Future<void> _onAddSighting(
    AddSighting event,
    Emitter<SightingsState> emit,
  ) async {
    // Cargar lo que ya exista en prefs
    final data = prefs.getStringList("sightings") ?? [];
    final sightings = data
        .map((e) => Sighting.fromJson(jsonDecode(e)))
        .toList();

    // Añadir el nuevo
    final updated = List<Sighting>.from(sightings)..add(event.sighting);

    // Emitir nuevo estado
    emit(SightingsLoaded(updated));

    // Guardar en prefs
    await prefs.setStringList(
      "sightings",
      updated.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> _onDeleteSighting(
    DeleteSighting event,
    Emitter<SightingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SightingsLoaded) {
      final updated = List<Sighting>.from(currentState.sightings)
        ..removeAt(event.index);

      emit(SightingsLoaded(updated));

      await prefs.setStringList(
        "sightings",
        updated.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
  }
}
