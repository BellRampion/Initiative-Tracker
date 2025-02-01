class Constants {
	
}

enum SystemChoices {
	pathfinder(humanReadableName: "Pathfinder", computerReadableName: "pf"), 
	rogueTrader(humanReadableName: "Rogue Trader", computerReadableName: "rt"),
	runequest(humanReadableName: "Runequest II/Legend", computerReadableName: "rq");

  const SystemChoices({
    required this.computerReadableName, required this.humanReadableName
  });

  final String humanReadableName;
  final String computerReadableName;
}