import 'package:flutter/material.dart';

/// Model class for items on the initiative tracker
/// 
/// Some fields are system-specific. These should still have a default value so that when the system gets switched the existing items have at least placeholder values.
class InitTrackerItem {
	double initiative;
	String name;
	String notes;
	int totalHp = 0;
	int currentHp = 0;
	//Rogue Trader specific
  bool reaction1Used = false;
  bool reaction2Used = false;
	//Runequest II/Legend specific
	int combatActions = 0;
	int combatActionsTotal = 0;
	//Distinct identifier to refer to this initiative card by
	UniqueKey key = UniqueKey();

	//Default HP to 0 because not every character needs to have hitpoints recorded
	InitTrackerItem({required this.initiative, required this.name, required this.notes, this.totalHp = 0, this.currentHp = 0, this.combatActions = 0, this.combatActionsTotal = 0});

	InitTrackerItem.fromJson(Map<String, dynamic> json) :
			initiative = (json['initiative'] as double?) ?? 0,
			name = (json['name'] as String?) ?? "",
			notes = (json['notes'] as String?) ?? "",
			totalHp = (json['totalHp'] as int?) ?? 0,
			currentHp = (json['currentHp'] as int?) ?? 0,
      reaction1Used = (json['reaction1Used'] as bool?) ?? false,
      reaction2Used = (json['reaction2Used'] as bool?) ?? false,
			combatActionsTotal = (json['combatActionsTotal'] as int?) ?? 0,
			combatActions = (json['combatActions'] as int?) ?? 0;

	/// Converts this object to a json map. 
	/// 
	/// Includes the system-specific fields, such as combat actions or reactions used, in every record. If the currently selected system is not one that uses those fields, they will have their default values. This reduces the amount of code, allows fields to be used across several systems, and allows files created with one system to be imported while the application is set to another without errors. 
	Map<String, dynamic> toJson(){
		return {
			"initiative": initiative,
			"name": name,
			"notes": notes,
			"totalHp": totalHp,
			"currentHp": currentHp,
      "reaction1Used": reaction1Used,
      "reaction2Used": reaction2Used,
			"combatActionsTotal": combatActionsTotal,
			"combatActions": combatActions
		};
	}
}