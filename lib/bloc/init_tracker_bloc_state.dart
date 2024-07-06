part of 'init_tracker_bloc.dart';

class InitTrackerBlocState {
	List<InitTrackerItem> initList = [];
	int listPlace = 0;
	bool isNewRound = false;
	String? displayString;
	bool hasError = false;
  int roundCounter = 0;

	InitTrackerBlocState({
		required this.initList,
    required this.roundCounter,
		this.listPlace = 0,
		this.isNewRound = false,
		this.displayString,
		this.hasError = false,
	});

	InitTrackerBlocState.initial();
}