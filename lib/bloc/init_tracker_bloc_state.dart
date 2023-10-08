part of 'init_tracker_bloc.dart';

class InitTrackerBlocState {
	List<InitTrackerItem> initList = [];
	int listPlace = 0;
	bool isNewRound = false;
	bool showDeleteButtons = false;
	bool showCopyButtons = false;

	InitTrackerBlocState({
		required this.initList,
		this.listPlace = 0,
		this.isNewRound = false,
		this.showDeleteButtons = false,
		this.showCopyButtons = false,
	});

	InitTrackerBlocState.initial();
}