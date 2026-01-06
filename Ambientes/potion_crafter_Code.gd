extends Node3D


func _on_Player_Enter_Ranger(Player_Body: Node3D):
	
	if Player_Body is Jogador:
		Player_Body.player_ui.Show_Recipes()
		
		
		
		
func _on_Player_Left_Range(Player_Body: Node3D):
	
	if Player_Body is Jogador:
		Player_Body.player_ui.Hide_Recipes()
