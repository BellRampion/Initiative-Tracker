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

class DeleteItem extends InitTrackerBlocEvent {
	UniqueKey key;

	DeleteItem({required this.key});
}

class DeleteAll extends InitTrackerBlocEvent {
	DeleteAll();
}

class RestartTracker extends InitTrackerBlocEvent {
	RestartTracker();
}