part of 'init_tracker_bloc.dart';

class InitTrackerBlocState {
	List<InitTrackerItem> initList = [];
	int listPlace = 0;
	bool isNewRound = false;

	InitTrackerBlocState({
		required this.initList,
		this.listPlace = 0,
		this.isNewRound = false,
	});

	InitTrackerBlocState.initial();
}