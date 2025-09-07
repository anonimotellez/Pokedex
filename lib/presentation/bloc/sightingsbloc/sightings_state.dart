part of 'sightings_bloc.dart';

abstract class SightingsState {}

class SightingsInitial extends SightingsState {}

class SightingsLoading extends SightingsState {}

class SightingsLoaded extends SightingsState {
  final List<Sighting> sightings;
  SightingsLoaded(this.sightings);
}

class SightingsError extends SightingsState {
  final String message;
  SightingsError(this.message);
}
