import 'package:basic_initiative_tracker/data_models/init_tracker_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'init_tracker_bloc_state.dart';
part 'init_tracker_bloc_event.dart';

class InitTrackerBloc extends Bloc<InitTrackerBlocEvent, InitTrackerBlocState> {
	bool sortOnNewRound = false;

	InitTrackerBloc() : super(InitTrackerBlocState.initial()){

		on<AddInitItem>(( event, emit) async {
			//Add the new initiative step
			state.initList.add(event.item);
			//Mark the list to be sorted when the round restarts
			sortOnNewRound = true;

			emit(InitTrackerBlocState(
				initList: state.initList,
				listPlace: state.listPlace,
				showDeleteButtons: state.showDeleteButtons,
				showCopyButtons: state.showCopyButtons,
			));
		});

		on<AdvanceTracker>((event, emit){
			int currentStep = state.listPlace;
			int newStep;
			if (currentStep == 0){
				newStep = 1;
			}
			else {
				newStep = state.initList.length % currentStep;
			}
			print("New step: $newStep\n");

			if (newStep == 0){
				if (sortOnNewRound){
					//Sort high to low initative
					state.initList.sort((a, b) => a.initiative.compareTo(b.initiative) * -1);
					sortOnNewRound = false;
				}
				emit(InitTrackerBlocState(
					initList: state.initList,
					listPlace: newStep,
					isNewRound: true,
					showDeleteButtons: state.showDeleteButtons,
					showCopyButtons: state.showCopyButtons,
				));
			}
			else {
				emit(InitTrackerBlocState(
					initList: state.initList,
					listPlace: newStep,
					isNewRound: false,
					showDeleteButtons: state.showDeleteButtons,
					showCopyButtons: state.showCopyButtons,
				));
			}
		});

		on<ToggleDeleteButtons>((event, emit){
			emit(
				InitTrackerBlocState(
					initList: state.initList,
					listPlace: state.listPlace,
					isNewRound: state.isNewRound,
					showDeleteButtons: event.deleteButtons,
					showCopyButtons: state.showCopyButtons,
				)
			);
		});

		on<ToggleCopyButtons>((event, emit){
			emit(
				InitTrackerBlocState(
					initList: state.initList,
					listPlace: state.listPlace,
					isNewRound: state.isNewRound,
					showDeleteButtons: state.showDeleteButtons,
					showCopyButtons: event.copyButtons,
				)
			);
		});

	}
}
