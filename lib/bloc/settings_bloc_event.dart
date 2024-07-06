part of 'settings_bloc.dart';

class SettingsBlocEvent {
	SettingsBlocEvent();
}

class SystemChangeEvent extends SettingsBlocEvent {
  SystemChoices newSelectedSystem;

  SystemChangeEvent({required this.newSelectedSystem});
}