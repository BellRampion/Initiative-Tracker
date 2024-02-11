import 'package:basic_initiative_tracker/data_models/init_tracker_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'init_tracker_bloc_state.dart';
part 'init_tracker_bloc_event.dart';

class InitTrackerBloc extends Bloc<InitTrackerBlocEvent, InitTrackerBlocState> {
	bool sortOnNewRound = false;

	InitTrackerBloc() : super(InitTrackerBlocState.initial()){

		on<AddInitItem>(( event, emit) async {
			UniqueKey key;
			int newListPlace = 0;
			if (state.initList.isNotEmpty){
				//Save the key for the currently selected item so it doesn't lose its place
				key = state.initList[state.listPlace].key;
				//Add the new initiative step
				state.initList.add(event.item);
				//Sort list
			  sortInitList(state.initList);

				//Find the item with the saved key and set it as the currently selected item
				for (int i = 0; i < state.initList.length; i++){
					if (state.initList[i].key == key){
						newListPlace = i;
						break;
					}
				}
			}
			else {
				state.initList.add(event.item);
			}

			emit(InitTrackerBlocState(
				initList: state.initList,
				listPlace: newListPlace,
			));
		});

		on<AdvanceTracker>((event, emit){
			int currentStep = state.listPlace;
			int newStep;
			newStep = currentStep + 1;

			if (state.initList.isEmpty){
				newStep = 0;
			}
			else if (newStep == state.initList.length)
			{
				newStep = 0;
			}      
			if (newStep == 0){
				emit(InitTrackerBlocState(
					initList: state.initList,
					listPlace: newStep,
					isNewRound: true,
				));
			}
			else {
				emit(InitTrackerBlocState(
					initList: state.initList,
					listPlace: newStep,
					isNewRound: false,
				));
			}
		});

		on<DeleteItem>((event, emit){
			int itemIndex = 0;
			UniqueKey currItemKey;
			int newListPlace = 0;

			//Save the key for the currently selected item so it doesn't lose its place
			currItemKey = state.initList[state.listPlace].key;

			//Find the item with the key that needs to be deleted
			for (int i = 0; i < state.initList.length; i++){
				if (event.key == state.initList[i].key){
					itemIndex = i;
				}
			}
			state.initList.removeAt(itemIndex);

			//Find the item with the saved key and set it as the currently selected item
			for (int i = 0; i < state.initList.length; i++){
				if (state.initList[i].key == currItemKey){
					newListPlace = i;
					break;
				}
			}

			emit(InitTrackerBlocState(
				initList: state.initList,
				listPlace: newListPlace,
			));
		});

    on<EditItem>((event, emit){
			int itemIndex = 0;
			UniqueKey currItemKey;
			int newListPlace = 0;

			//Save the key for the currently selected item so it doesn't lose its place
			currItemKey = state.initList[state.listPlace].key;

			//Find the item with the key that needs to be replaced and exchange all the fields
			for (int i = 0; i < state.initList.length; i++){
				if (event.key == state.initList[i].key){
					state.initList[i] = event.newItem;
				}
			}

      //Sort list
			sortInitList(state.initList);

			//Find the item with the saved key and set it as the currently selected item
			for (int i = 0; i < state.initList.length; i++){
				if (state.initList[i].key == currItemKey){
					newListPlace = i;
					break;
				}
			}

			emit(InitTrackerBlocState(
				initList: state.initList,
				listPlace: newListPlace,
			));
		});

		on<DeleteAll>((event, emit){
			emit(InitTrackerBlocState(
				initList: [],
				listPlace: 0,
			));
		});

    on<RestartTracker>((event, emit){
      emit(InitTrackerBlocState(
        initList: state.initList,
        listPlace: 0,
        isNewRound: true,
      ));
    });

	}

  void sortInitList(List<InitTrackerItem> initList){
    //Sort high to low initative
    initList.sort((a, b) => a.initiative.compareTo(b.initiative) * -1);
  }
}
