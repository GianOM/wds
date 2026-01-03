class_name Paciente
extends CharacterBody3D

@onready var debug_mesh: MeshInstance3D = $Debug_Mesh
@onready var symptoms_text: Label3D = $"Symptoms Text"

var Minha_Doenca: Doenca

@onready var wait_untill_kill_timer: Timer = $Wait_Untill_Kill_Timer
@onready var time_untill_death: Timer = $Time_Untill_Death

@onready var time_untill_die: Label3D = $Time_Untill_Die

func _ready() -> void:
	Add_new_Sickness()
	
	
	
	
	
func _physics_process(delta: float) -> void:
	
	
	time_untill_die.text = " %.2f s" % time_untill_death.time_left

	
	pass
	
func Add_new_Sickness():
	
	Minha_Doenca = SicknessManager.Draw_Sickness_from_Pool()
	symptoms_text.text = Minha_Doenca.Sintomas_em_Texto()
	#symptoms_text.show()
	
	
	
	
func Compare_Medicine_With_Sickness(Medicine_Input_Name: String) -> bool:
	
	for i in range(Minha_Doenca.Possible_Cure.size()):
		if Minha_Doenca.Possible_Cure[i].Treatment_Name == Medicine_Input_Name:
			return true
	
	return false
	
func _on_Medicine_Given(Medicine_Input_Name: String):
	
	time_untill_death.stop()
	
	var Medicine_Result: bool = Compare_Medicine_With_Sickness(Medicine_Input_Name)
	
	if Medicine_Result == true:
		
		debug_mesh.get_surface_override_material(0).set("albedo_color", Color(0.0, 1.0, 0.0, 1.0))
		ScoreManager.Total_de_Acertos += 1
		
	else:
		
		debug_mesh.get_surface_override_material(0).set("albedo_color", Color(0.458, 0.458, 0.458, 1.0))
		
	wait_untill_kill_timer.start()
	
	
	
	
func _on_Kill_Timer_Timeout():
	queue_free()
	
	
	
	
func _on_Player_Entered_my_Range(Player_Body: Node3D):
	if Player_Body is Jogador:
		symptoms_text.show()
		Player_Body.player_ui.Player_Selected_Medicine.connect(_on_Medicine_Given)
	
	
func _on_Player_Left_My_Range(Player_Body: Node3D):
	if Player_Body is Jogador:
		symptoms_text.hide()
		Player_Body.player_ui.Player_Selected_Medicine.disconnect(_on_Medicine_Given)
	
	
	
	
	
