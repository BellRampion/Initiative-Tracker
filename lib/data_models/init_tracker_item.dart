import 'package:flutter/material.dart';

class InitTrackerItem {
	double initiative;
	String name;
	String notes;
	int totalHp = 0;
	int currentHp = 0;
	//Distinct identifier to refer to this initiative card by
	UniqueKey key = UniqueKey();

	//Default HP to 0 because not every character needs to have hitpoints recorded
    InitTrackerItem({
		required this.initiative, 
		required this.name, 
		required this.notes, 
		this.totalHp = 0, 
		this.currentHp = 0
    });
}