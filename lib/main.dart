// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:basic_initiative_tracker/bloc/settings_bloc.dart';
import 'package:basic_initiative_tracker/bloc/theme_color_bloc.dart';
import 'package:basic_initiative_tracker/constants.dart';
import 'package:basic_initiative_tracker/data_models/init_tracker_item.dart';
import 'package:basic_initiative_tracker/init_tracker_item_card.dart';
import 'package:basic_initiative_tracker/settingsPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/init_tracker_bloc.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	//final savedThemeMode = await AdaptiveTheme.getThemeMode();
	runApp(MainApp(
		themeMode: ThemeMode.dark,
	));
}

class MainApp extends StatefulWidget {
	ThemeMode themeMode;
	MainApp({super.key, required this.themeMode});

	@override
	State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
	@override
	Widget build(BuildContext context) {
		return MultiBlocProvider(
			providers: [
				BlocProvider<InitTrackerBloc>(
					create: (context) => InitTrackerBloc(),
				),
				BlocProvider<ThemeColorBloc>(
					create: (context) => ThemeColorBloc(),
				),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc()
        ),
			],
			child: BlocBuilder<ThemeColorBloc, ThemeColorBlocState>(builder: (context, state) {
				return MaterialApp(
					theme: ThemeData(
						useMaterial3: true,
						brightness: Brightness.light,
						colorSchemeSeed: state.selectedColorSeed
					),
					darkTheme: ThemeData(
						useMaterial3: true,
						brightness: Brightness.dark,
						colorSchemeSeed: state.selectedColorSeed,
					),
					themeMode:
							BlocProvider.of<ThemeColorBloc>(context).state.selectedThemeMode,
					title: "Initiative Tracker",
					debugShowCheckedModeBanner: false,
					home: HomePage(),
				);
			}),
		);
	}
}

class HomePage extends StatelessWidget {
	static const double boxHeight = 10;
	static const double iconButtonSpacing = 16;

	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		return BlocConsumer<InitTrackerBloc, InitTrackerBlocState>(
				listener: (context, state) async {
			if (state.isNewRound) {
				await showDialog(
					context: context,
					builder: (context) {
						return AlertDialog(
							content: Text("New Round Starting",
									style: UIStyles.getRegularText(context)),
							contentPadding: EdgeInsets.all(16.0),
							actions: [
								TextButton(
									child: Text("Ok",
											style: UIStyles.getTextButtonText(context)),
									onPressed: () {
										Navigator.pop(context);
									})
							]);
					}
				);
			}
		}, builder: (context, state) {
			return Scaffold(
				appBar: AppBar(
					backgroundColor: BlocProvider.of<ThemeColorBloc>(context).state.selectedThemeMode == ThemeMode.dark ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
					title: Text("Initiative Tracker",
							style: UIStyles.getHeaderText(context)),
					actions: [
            Text(
              "Round Counter: ${state.roundCounter}"
            ),
						IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(),
                  ),
                );
              }
            ),
					],
				),
				body: Padding(
					padding: EdgeInsets.all(8.0),
					child: Column(children: [
						Expanded(
							child: ListView.builder(
									itemCount: state.initList.length,
									itemBuilder: (context, index) {
										//Have to pull it out for the onPressed
										InitTrackerItem initialItem = state.initList[index];

										return InitTrackerItemCard(
											isSelected: state.listPlace == index,
											initTrackerItem: initialItem,
											editButton: IconButton(
													icon: Icon(Icons.edit),
													onPressed: () async {
														InitTrackerItem? item =
																await showDialog<InitTrackerItem>(
															context: context,
															builder: (context) {
																return addEditItemDialog(
																	title: "Edit Item",
																	context: context,
																	name: initialItem.name,
																	notes: initialItem.notes,
																	initiative: initialItem.initiative,
																	currentHp: initialItem.currentHp,
																	totalHp: initialItem.totalHp,
																	combatActions: initialItem.combatActions
																);
															},
														);

														if (item != null) {
															context.read<InitTrackerBloc>().add(EditItem(
																	key: initialItem.key, newItem: item));
														}
													}),
											copyButton: IconButton(
													icon: Icon(Icons.copy),
													onPressed: () async {
														InitTrackerItem? item =
																await showDialog<InitTrackerItem>(
															context: context,
															builder: (context) {
																return addEditItemDialog(
																	context: context,
																	name: initialItem.name,
																	notes: initialItem.notes,
																	initiative: initialItem.initiative,
																	currentHp: initialItem.currentHp,
																	totalHp: initialItem.totalHp,
																	combatActions: initialItem.combatActions,
																);
															},
														);

														if (item != null) {
															context
																	.read<InitTrackerBloc>()
																	.add(AddInitItem(item: item));
														}
													}),
											deleteButton: IconButton(
													icon: Icon(Icons.delete),
													onPressed: () {
														context
																.read<InitTrackerBloc>()
																.add(DeleteItem(key: initialItem.key));
													}),
										);
									}),
						),
						SizedBox(
							height: MediaQuery.of(context).size.height > 500 ? 100 : 30,
							child: Container(),
						),
					]),
				),
				floatingActionButton: Padding(
					padding: EdgeInsets.all(16.0),
					child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
						SizedBox(
									height: MediaQuery.of(context).size.height > 500 ? 100 : 30,
									child: Container(),
								),
						FloatingActionButton(
              heroTag: UniqueKey(),
              tooltip: "Save to file",
							onPressed: () async {
								String? outputFile = await FilePicker.platform.saveFile(
									dialogTitle: 'Please select an output file:',
									fileName: 'output-file.txt',
								);

								if (outputFile == null) {
								// User canceled the picker
									ScaffoldMessenger.of(context).showSnackBar(SnackBar(
										content: Text("Canceled save operation"),
									));
								}
								else {
									context.read<InitTrackerBloc>().add(SaveTracker(filename: outputFile));
								}

							},
							child: Icon(Icons.save) 
						),
						SizedBox(width: iconButtonSpacing),
						FloatingActionButton(
              heroTag: UniqueKey(),
              tooltip: "Load from file",
							onPressed: () async {
								String? inputFile = (await FilePicker.platform.pickFiles(
									dialogTitle: 'Please select an input file:',
								))?.files.single.path;

								if (inputFile == null) {
								// User canceled the picker
									ScaffoldMessenger.of(context).showSnackBar(SnackBar(
										content: Text("Canceled load operation"),
									));
								}
								else {
									context.read<InitTrackerBloc>().add(LoadTracker(filename: inputFile));
								}
							},
							child: Icon(Icons.file_open)
						),
						SizedBox(width: iconButtonSpacing),
						FloatingActionButton(
								heroTag: UniqueKey(),
                tooltip: "Delete all",
								onPressed: () async {
									bool? delete = await showDialog(
											context: context,
											builder: (context) {
												return AlertDialog(
													content: Text(
															"WARNING: This will delete all items in the tracker. Are you sure?",
															style: UIStyles.getHeaderText(context).copyWith(
																color: Theme.of(context).colorScheme.error)),
													actions: [
														TextButton(
															onPressed: () {
																Navigator.pop(context, false);
															},
															child: Text("Cancel",
																	style: UIStyles.getTextButtonText(context)),
														),
														TextButton(
															onPressed: () {
																Navigator.pop(context, true);
															},
															child: Text("OK",
																style: UIStyles.getTextButtonText(context)
																		.copyWith(
																			color: Theme.of(context)
																					.colorScheme
																					.error)),
														),
													]);
											});
									if (delete != null && delete) {
										context.read<InitTrackerBloc>().add(DeleteAll());
									}
								},
								child: Icon(Icons.delete_outlined)),
						SizedBox(width: iconButtonSpacing),
						FloatingActionButton(
							heroTag: UniqueKey(),
              tooltip: "Add item",
							onPressed: () async {
								InitTrackerItem? item = await showDialog<InitTrackerItem>(
									context: context,
									builder: (context) {
										return addEditItemDialog(
											context: context,
											name: "",
											notes: "",
											initiative: 0,
											currentHp: 0,
											totalHp: 0,
											combatActions: 0
										);
									},
								);
								if (item != null) {
									context.read<InitTrackerBloc>().add(AddInitItem(item: item));
								}
							},
							child: const Icon(Icons.add),
						),
						SizedBox(width: iconButtonSpacing),
						FloatingActionButton(
								heroTag: UniqueKey(),
                tooltip: "Next item",
								child: Icon(Icons.navigate_next),
								onPressed: () async {
									context.read<InitTrackerBloc>().add(AdvanceTracker());
								}),
						SizedBox(width: iconButtonSpacing),
						FloatingActionButton(
								heroTag: UniqueKey(),
                tooltip: "Restart",
								child: Icon(Icons.restart_alt),
								onPressed: () async {
									context.read<InitTrackerBloc>().add(RestartTracker());
								}),
						SizedBox(width: iconButtonSpacing),
					]),
				),
			);
		});
	}

	Widget addEditItemDialog({
		required BuildContext context,
		required String name,
		required String notes,
		required int currentHp,
		required int totalHp,
		required double initiative,
		required int combatActions,
		String? title,
	}) {
		TextEditingController nameController = TextEditingController(text: name);
		TextEditingController notesController = TextEditingController(text: notes);
		TextEditingController currentHpController =
				TextEditingController(text: currentHp.toString());
		TextEditingController totalHpController =
				TextEditingController(text: totalHp.toString());
		TextEditingController initiativeController =
				TextEditingController(text: initiative.toString());
		TextEditingController combatActionsController = TextEditingController(text: combatActions.toString());

		return AlertDialog(
				title: Text(title ?? "Add New Initiative Step",
						style: UIStyles.getRegularText(context)),
				content: Padding(
					padding: EdgeInsets.all(8.0),
					child: SingleChildScrollView(
						child: Column(children: [
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
									labelText: "Notes", 
									border: OutlineInputBorder()),
								style: UIStyles.getRegularText(context),
								controller: notesController,
							),
							//Only ask for combat actions if the selected system is Runequest
							if (SystemChoices.runequest.computerReadableName == context.watch<SettingsBloc>().state.selectedSystem.computerReadableName) 
							SizedBox(height: boxHeight),
							if (SystemChoices.runequest.computerReadableName == context.watch<SettingsBloc>().state.selectedSystem.computerReadableName) 
							TextField(
								decoration: InputDecoration(
									labelText: "Combat Actions", 
									border: OutlineInputBorder()),
								style: UIStyles.getRegularText(context),
								controller: combatActionsController,
								keyboardType: TextInputType.number,
								inputFormatters: <TextInputFormatter>[
									FilteringTextInputFormatter.allow(RegExp(r'\d+')),
								],
							),
							SizedBox(height: boxHeight),
							TextField(
								decoration: InputDecoration(
									labelText: "Current hitpoints",
									border: OutlineInputBorder()),
								style: UIStyles.getRegularText(context),
								controller: currentHpController,
								keyboardType: TextInputType.numberWithOptions(signed: true),
								inputFormatters: <TextInputFormatter>[
									FilteringTextInputFormatter.allow(RegExp(r'-?\d*')),
								],
							),
							SizedBox(height: boxHeight),
							TextField(
								decoration: InputDecoration(
									labelText: "Total Hitpoints", 
									border: OutlineInputBorder()),
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
									border: OutlineInputBorder()),
								style: UIStyles.getRegularText(context),
								controller: initiativeController,
								keyboardType: TextInputType.number,
								inputFormatters: <TextInputFormatter>[
									FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
								],
							),
							SizedBox(height: boxHeight),
						]),
					),
				),
				actions: [
					TextButton(
						onPressed: () => Navigator.pop(context, null),
						child: Text("Cancel", style: UIStyles.getTextButtonText(context)),
					),
					TextButton(
						onPressed: () {
							return Navigator.pop(
									context,
									InitTrackerItem(
										name: nameController.text,
										notes: notesController.text,
										initiative: double.tryParse(initiativeController.text) ?? 0,
										currentHp: int.tryParse(currentHpController.text) ?? 0,
										totalHp: int.tryParse(totalHpController.text) ?? 0,
										combatActions: int.tryParse(combatActionsController.text) ?? 0,
										combatActionsTotal: int.tryParse(combatActionsController.text) ?? 0,
									));
						},
						child: Text("Done", style: UIStyles.getTextButtonText(context)),
					),
				]);
	}
}

class UIStyles {
	static final TextStyle _regularText = TextStyle(fontSize: 14);
	static final TextStyle _textButtonText =
			TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
	static final TextStyle _headerText =
			TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

	static TextStyle getRegularText(BuildContext context) {
		return _regularText.copyWith(
				fontSize: MediaQuery.sizeOf(context).height > 500 ? 14 : 10);
	}

	static TextStyle getTextButtonText(BuildContext context) {
		return _textButtonText.copyWith(
				fontSize: MediaQuery.sizeOf(context).height > 500 ? 12 : 8);
	}

	static TextStyle getHeaderText(BuildContext context) {
		return _headerText.copyWith(
				fontSize: MediaQuery.sizeOf(context).height > 500 ? 16 : 12);
	}
}
