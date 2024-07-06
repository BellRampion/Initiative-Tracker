class Constants {
	
}

enum SystemChoices {
  pathfinder(humanReadableName: "Pathfinder", computerReadableName: "pf"), rogueTrader(humanReadableName: "Rogue Trader", computerReadableName: "rt");

  const SystemChoices({
    required this.computerReadableName, required this.humanReadableName
  });

  final String humanReadableName;
  final String computerReadableName;
}