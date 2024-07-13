
import 'package:basic_initiative_tracker/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_bloc_state.dart';
part 'settings_bloc_event.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
	bool sortOnNewRound = false;

	SettingsBloc() : super(SettingsBlocState.initial()){
    on<SystemChangeEvent>(( event, emit) async {
			emit(
        SettingsBlocState(
          selectedSystem: event.newSelectedSystem,
        )
      );

    });
	}
}