class_name Paciente
extends CharacterBody3D

enum PacientState {
	Sick,
	Treated
	}

var My_Current_State: PacientState = PacientState.Sick


@onready var pacient_nav_agent: NavigationAgent3D = $Pacient_NavAgent
var has_move_target: bool = false
var next_path_position: Vector3 = Vector3.ZERO

@onready var debug_mesh: MeshInstance3D = $Debug_Mesh
@onready var symptoms_text: Label3D = $"Symptoms Text"

var Minha_Doenca: Doenca

@onready var wait_untill_kill_timer: Timer = $Wait_Untill_Kill_Timer
@onready var time_untill_death: Timer = $Wait_Time_Timout

@onready var time_untill_die: Label3D = $Time_Untill_Die


@onready var mesh_collision: CollisionShape3D = $Mesh_Collision



func _ready() -> void:
	Add_new_Sickness()
	
	var Random_Color: Color = Color(randf(), randf(), randf())
	
	pacient_nav_agent.set("debug_path_custom_color", Random_Color)
	debug_mesh.get_surface_override_material(0).set("stencil_color", Random_Color)
	
	
func Set_Fila_Target(Initial_NavMesh_Position: Vector3):
	
	
	await get_tree().physics_frame
	
	has_move_target = true
	pacient_nav_agent.target_position = Initial_NavMesh_Position
	next_path_position = pacient_nav_agent.get_next_path_position()
	
	
	
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	time_untill_die.text = " %.2f s" % time_untill_death.time_left
	
	if has_move_target:
		
		next_path_position = pacient_nav_agent.get_next_path_position()
		var movement_direction: Vector3 = global_position.direction_to(next_path_position)
		
		if pacient_nav_agent.get_avoidance_enabled():
			
			pacient_nav_agent.set_velocity(movement_direction * 3.0)
			
		else:
			on_avoidance_velocity_computed( movement_direction * 3.0)
		
		
		move_and_slide()
		
		if pacient_nav_agent.is_navigation_finished():
			
			has_move_target = false
			
			if wait_untill_kill_timer.is_stopped() and My_Current_State == PacientState.Treated:
				wait_untill_kill_timer.start()
			
			
			
# o Codigo do NavMesh computa uma velocidade safe usando avoidance
func on_avoidance_velocity_computed(New_Safe_Velocity: Vector3):
	velocity = New_Safe_Velocity
			
			
	
func Add_new_Sickness():
	
	Minha_Doenca = SicknessManager.Draw_Sickness_from_Pool().duplicate_deep()
	symptoms_text.text = Minha_Doenca.Sintomas_em_Texto()
	
	
	
	
func Compare_Medicine_With_Sickness(Medicine_Input_Name: String) -> bool:
	
	for Cura in Minha_Doenca.Possible_Cure:
		if Cura.Treatment_Name == Medicine_Input_Name:
			return true
	
	return false
	
func _on_Medicine_Given(Medicine_Input_Name: String):
	
	
	
	var Medicine_Result: bool = Compare_Medicine_With_Sickness(Medicine_Input_Name)
	
	if Medicine_Result == true:
		
		debug_mesh.get_surface_override_material(0).set("albedo_color", Color(0.0, 1.0, 0.0, 1.0))
		ScoreManager.Calcular_Recompensa_pela_Doenca_Curada(Minha_Doenca)
		
	else:
		
		debug_mesh.get_surface_override_material(0).set("albedo_color", Color(0.857, 0.0, 0.179, 1.0))
		ScoreManager.Score_de_Insatisfacao += 60
		
		
		
		
	time_untill_death.stop()
	
	Go_Home()
	
	
func Go_Home():
	
	mesh_collision.disabled = true
	
	pacient_nav_agent.target_position = Vector3(-16.587,
												0.003,
												0.4)
												
												
												
	has_move_target = true
	
	My_Current_State = PacientState.Treated
	
	
	
func _on_Kill_Timer_Timeout():
	queue_free()
	
func _on_Wait_Time_Timeout():
	ScoreManager.Score_de_Insatisfacao += 20
	debug_mesh.get_surface_override_material(0).set("albedo_color", Color(0.88, 0.437, 0.153, 1.0))
	
	Go_Home()
	
func _on_Player_Entered_my_Range(Player_Body: Node3D):
	if Player_Body is Jogador:
		symptoms_text.show()
		Player_Body.player_ui.Player_Selected_Medicine.connect(_on_Medicine_Given)
	
	
func _on_Player_Left_My_Range(Player_Body: Node3D):
	if Player_Body is Jogador:
		symptoms_text.hide()
		Player_Body.player_ui.Player_Selected_Medicine.disconnect(_on_Medicine_Given)
	
	
	
	
	
