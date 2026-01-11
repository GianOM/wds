class_name Speed_Upgrades
extends Player_Upgrade


@export var Speed_Multiplier: float


func Apply_on_Player(Player_to_Modify:Jogador):
	
	Player_to_Modify.Player_Speed *= Speed_Multiplier
	
	
