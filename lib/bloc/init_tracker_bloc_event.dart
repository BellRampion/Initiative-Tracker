part of 'init_tracker_bloc.dart';

class InitTrackerBlocEvent {
	InitTrackerBlocEvent();
}

class AddInitItem extends InitTrackerBlocEvent {
	InitTrackerItem item;

	AddInitItem({required this.item});
}

class AdvanceTracker extends InitTrackerBlocEvent {
	AdvanceTracker();
}

class ToggleDeleteButtons extends InitTrackerBlocEvent {
	bool deleteButtons = false;
	
	ToggleDeleteButtons({required this.deleteButtons});
}

class ToggleCopyButtons extends InitTrackerBlocEvent {
	bool copyButtons = false;

	ToggleCopyButtons({required this.copyButtons});
}

class DeleteItem extends InitTrackerBlocEvent {
	int index;

	DeleteItem({required this.index});
}