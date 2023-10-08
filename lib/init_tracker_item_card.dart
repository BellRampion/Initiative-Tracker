// ignore_for_file: must_be_immutable

import 'package:basic_initiative_tracker/data_models/init_tracker_item.dart';
import 'package:basic_initiative_tracker/main.dart';
import 'package:flutter/material.dart';

class InitTrackerItemCard extends StatelessWidget{
    InitTrackerItem initTrackerItem;
	TextEditingController currentHpController = TextEditingController();
	IconButton deleteButton;
	IconButton copyButton;

	InitTrackerItemCard({super.key, required this.initTrackerItem, required this.deleteButton, required this.copyButton}){
		currentHpController.text = initTrackerItem.currentHp.toString();
	}

	@override
	Widget build(BuildContext context){
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(8.0),
				child: Row(
					children: [
						Expanded(
							child: Text(initTrackerItem.name, style: UIStyles.getRegularText(context)),
						),
						SizedBox(
							width: 40,
							child: TextField(
								controller: currentHpController,
								onChanged: (value){
									initTrackerItem.currentHp = int.tryParse(value) ?? 0;
								},
								style: UIStyles.getRegularText(context),
								textAlign: TextAlign.right,
							),
						),
						const Text("/ "),
						Text(initTrackerItem.totalHp.toString(), style: UIStyles.getRegularText(context)),
						SizedBox(
							width: MediaQuery.sizeOf(context).width / 10,
						),
						Text(initTrackerItem.initiative.toString(), style: UIStyles.getRegularText(context).copyWith(fontWeight: FontWeight.bold)),

					]
				),
			)
		);
	}
}