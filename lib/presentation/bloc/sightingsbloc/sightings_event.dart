part of 'sightings_bloc.dart';

abstract class SightingsEvent {}

class LoadSightings extends SightingsEvent {}

class AddSighting extends SightingsEvent {
  final Sighting sighting;
  AddSighting(this.sighting);
}

class DeleteSighting extends SightingsEvent {
  final int index;
  DeleteSighting(this.index);
}
