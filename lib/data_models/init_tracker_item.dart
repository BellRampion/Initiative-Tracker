class InitTrackerItem {
    int initiative;
    String name;
	int totalHp = 0;
	int currentHp = 0;

	//Default HP to 0 because not every character needs to have hitpoints recorded
    InitTrackerItem({required this.initiative, required this.name, this.totalHp = 0, this.currentHp = 0});
}