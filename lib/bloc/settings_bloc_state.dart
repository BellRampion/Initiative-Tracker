part of 'settings_bloc.dart';

class SettingsBlocState {
  /// The selected roleplaying system. Defaults to Pathfinder
	SystemChoices selectedSystem = SystemChoices.pathfinder;

	SettingsBlocState({
		required this.selectedSystem,
	});

	SettingsBlocState.initial();
}