// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:basic_initiative_tracker/data_models/init_tracker_item.dart';
import 'package:basic_initiative_tracker/init_tracker_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/init_tracker_bloc.dart';

void main() {
	runApp(const MainApp());
}

class MainApp extends StatelessWidget {
	const MainApp({super.key});

	@override
	Widget build(BuildContext context) {
		return BlocProvider(
			create: (context) => InitTrackerBloc(),
			child: MaterialApp(
				debugShowCheckedModeBanner: false,
				theme: ThemeData.dark().copyWith(
					colorScheme: ColorScheme.fromSeed(
						seedColor: Color.fromARGB(255, 87, 0, 0),
					),
				),
				home: HomePage(),
			)
		);
	}
}

class HomePage extends StatelessWidget {
	const HomePage({super.key});
	static const double boxHeight = 10;



	@override
	Widget build(BuildContext context){
		return BlocConsumer<InitTrackerBloc, InitTrackerBlocState>(
			listener: (context, state) async {
				if (state.isNewRound){
					await showDialog(
						context: context, 
						builder: (context){
							return AlertDialog(
								title: Text("New Round", style: UIStyles.getHeaderText(context)),
								content: Text("New Round Starting", style: UIStyles.getRegularText(context)),
								contentPadding: EdgeInsets.all(8.0),
								actions: [
									TextButton(
										child: Text("Ok", style: UIStyles.getTextButtonText(context)),
										onPressed: (){
											Navigator.pop(context);
										}
									)
								]
							);
						}
					);
				}
			},
			builder: (context, state){ 
				return Scaffold(
					appBar: AppBar(
						backgroundColor: Color.fromARGB(255, 61, 0, 0),
						title: Text("Initiative Tracker", style: UIStyles.getHeaderText(context)),
						actions: [
							IconButton(
								onPressed: (){

								}, 
								icon: Icon(Icons.edit),
							),
							IconButton(
								onPressed: (){

								}, 
								icon: Icon(Icons.delete),
							)
						]
					),
					body: Padding(
						padding: EdgeInsets.all(8.0),
						child: ListView.builder(
							itemCount: state.initList.length,
							itemBuilder: (context, index){
								return InitTrackerItemCard(
									initTrackerItem: state.initList[index],
									copyButton: IconButton(

									),
									deleteButton: IconButton(
										onPressed: (){
											context.read<InitTrackerBloc>().add(DeleteItem(index: index));
										}
									),
								);
							}
						),
					),
					floatingActionButton: Padding(
						padding: EdgeInsets.all(16.0),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.end,
							children: [
								FloatingActionButton(
									child: Icon(Icons.navigate_next),
									onPressed: () async {
										context.read<InitTrackerBloc>().add(AdvanceTracker());
									}
								),
								SizedBox(width: 16),
								FloatingActionButton(
									onPressed: () async {
										InitTrackerItem? item = await showDialog<InitTrackerItem>(
											context: context,
											builder: (context) {
												return addItemDialog(context: context, name: "", initiative: 0, currentHp: 0, totalHp: 0);
											},
										);

										if (item != null){
											context.read<InitTrackerBloc>().add(AddInitItem(item: item));
										}
									},
									child: const Icon(Icons.add),
								),
							]
						),
					),
				);
			}
		);
	}

	Widget addItemDialog({required BuildContext context, required String name, required int currentHp, required int totalHp, required int initiative}){
		TextEditingController nameController = TextEditingController(text: name);
		TextEditingController currentHpController = TextEditingController(text: currentHp.toString());
		TextEditingController totalHpController = TextEditingController(text: totalHp.toString());
		TextEditingController initiativeController = TextEditingController(text: initiative.toString());
		
		return AlertDialog(
			title: Text("Add New Initiative Step", style: UIStyles.getRegularText(context)),
			content: Padding(
				padding: EdgeInsets.all(8.0),
				child: Column(
					children: [
						TextField(
							decoration: InputDecoration(
								labelText: "Name",
								border: OutlineInputBorder()
							),
							style: UIStyles.getRegularText(context),
							controller: nameController,
						),
						SizedBox(height: boxHeight),
						TextField(
							decoration: InputDecoration(
								labelText: "Current hitpoints",
								border: OutlineInputBorder()
							),
							style: UIStyles.getRegularText(context),
							controller: currentHpController,
							keyboardType: TextInputType.number,
							inputFormatters: <TextInputFormatter>[
								FilteringTextInputFormatter.allow(RegExp(r'\d+')),
							], 
						),
						SizedBox(height: boxHeight),
						TextField(
							decoration: InputDecoration(
								labelText: "Total Hitpoints",
								border: OutlineInputBorder()
							),
							style: UIStyles.getRegularText(context),
							controller: totalHpController,
							keyboardType: TextInputType.number,
							inputFormatters: <TextInputFormatter>[
								FilteringTextInputFormatter.allow(RegExp(r'\d+')),
							], 
						),
						SizedBox(height: boxHeight),
						TextField(
							decoration: InputDecoration(
								labelText: "Initiative",
								border: OutlineInputBorder()
							),
							style: UIStyles.getRegularText(context),
							controller: initiativeController,
							keyboardType: TextInputType.number,
							inputFormatters: <TextInputFormatter>[
								FilteringTextInputFormatter.allow(RegExp(r'\d+')),
							], 
						),
						SizedBox(height: boxHeight),
						
					]
				),
			),
			actions: [
				TextButton(
					onPressed: () => Navigator.pop(context, null),
					child: Text("Cancel", style: UIStyles.getTextButtonText(context)),
				),
				TextButton(
					onPressed: (){
						return Navigator.pop(
							context, 
							InitTrackerItem(
								name: nameController.text, 
								initiative: int.tryParse(initiativeController.text) ?? 0, 
								currentHp: int.tryParse(currentHpController.text) ?? 0,
								totalHp: int.tryParse(totalHpController.text) ?? 0,
							)
						);
					},
					child: Text("Done", style: UIStyles.getTextButtonText(context)),
				),
				
			]
		);
	}
}

class UIStyles {
	static final TextStyle _regularText = TextStyle(fontSize: 14);
	static final TextStyle _textButtonText = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
	static final TextStyle _headerText = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

	static TextStyle getRegularText(BuildContext context){
		return _regularText.copyWith(fontSize: MediaQuery.sizeOf(context).height > 500 ? 14 : 10);
	}

	static TextStyle getTextButtonText(BuildContext context){
		return _textButtonText.copyWith(fontSize: MediaQuery.sizeOf(context).height > 500 ? 12 : 8);
	}

	static TextStyle getHeaderText(BuildContext context){
		return _headerText.copyWith(fontSize: MediaQuery.sizeOf(context).height > 500 ? 16 : 12);
	}
}
