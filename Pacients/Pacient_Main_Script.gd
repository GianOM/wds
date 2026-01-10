class_name Paciente
extends CharacterBody3D

signal Death_Signal

# Constants
const MOVEMENT_SPEED: float = 3.0
const WRONG_MEDICINE_PENALTY: int = 60
const TIMEOUT_PENALTY: int = 20

var HOME_POSITION: Vector3 

# Enums
enum PacientState {
	SICK,
	TREATED
}

# State
var current_state: PacientState = PacientState.SICK
var sickness: Doenca
var has_move_target: bool = false
var next_path_position: Vector3 = Vector3.ZERO

# Node references
@onready var nav_agent: NavigationAgent3D = $Pacient_NavAgent
@onready var debug_mesh: MeshInstance3D = $Debug_Mesh
@onready var symptoms_label: Label3D = $"Symptoms Text"
@onready var time_label: Label3D = $Time_Untill_Die

@onready var kill_timer: Timer = $Go_Home_Timer
@onready var death_timer: Timer = $Death_Timer

@onready var mesh_collision: CollisionShape3D = $Mesh_Collision
@onready var outline_meshes: Node3D = $Outline_Meshes


func _ready() -> void:
	_initialize_patient()
	_setup_visual_debugging()


func _physics_process(_delta: float) -> void:
	_update_time_display()
	
	if has_move_target:
		_process_movement()


# Initialization
func _initialize_patient() -> void:
	sickness = SicknessManager.Draw_Sickness_from_Pool().duplicate_deep()
	symptoms_label.text = sickness.Sintomas_em_Texto()


func _setup_visual_debugging() -> void:
	var random_color: Color = Color(randf(), randf(), randf())
	nav_agent.set("debug_path_custom_color", random_color)
	_set_mesh_color(random_color, true)


# Movement
func set_target_position(target: Vector3) -> void:
	has_move_target = true
	nav_agent.target_position = target
	next_path_position = nav_agent.get_next_path_position()


func _process_movement() -> void:
	next_path_position = nav_agent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_position)
	var target_velocity: Vector3 = direction * MOVEMENT_SPEED
	
	
	
	
	var target_rotation = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	
	var ROTATION_SPEED: float = 0.4
	
	if abs(target_rotation-rotation.y) > deg_to_rad(60):
		ROTATION_SPEED = 2.0
		
	rotation.y = move_toward(rotation.y, target_rotation, ROTATION_SPEED)
	
	
	
	if nav_agent.get_avoidance_enabled():
		nav_agent.set_velocity(target_velocity)
	else:
		_on_avoidance_velocity_computed(target_velocity)
	
	move_and_slide()
	
	if nav_agent.is_navigation_finished():
		_on_navigation_finished()


func _on_avoidance_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity


func _on_navigation_finished() -> void:
	has_move_target = false
	
	if kill_timer.is_stopped() and current_state == PacientState.TREATED:
		kill_timer.start()


# Medicine treatment
func _on_medicine_given(medicine_name: String) -> void:
	var is_correct: bool = _is_medicine_correct(medicine_name)
	
	if is_correct:
		_handle_correct_treatment()
	else:
		_handle_wrong_treatment()
	
	death_timer.stop()
	_go_home()


func _is_medicine_correct(medicine_name: String) -> bool:
	for cure in sickness.Possible_Cure:
		if cure.Treatment_Name == medicine_name:
			return true
	return false


func _handle_correct_treatment() -> void:
	_set_debug_color(Color.GREEN)
	ScoreManager.Calcular_Recompensa_pela_Doenca_Curada(sickness)


func _handle_wrong_treatment() -> void:
	_set_debug_color(Color(0.857, 0.0, 0.179))
	ScoreManager.Score_de_Insatisfacao += WRONG_MEDICINE_PENALTY


# Navigation
func _go_home() -> void:
	
	nav_agent.set_avoidance_enabled(false)

	
	Death_Signal.emit()
	
	mesh_collision.disabled = true
	nav_agent.target_position = HOME_POSITION
	has_move_target = true
	current_state = PacientState.TREATED


# Visual feedback
func _set_mesh_color(color: Color, use_stencil: bool = false) -> void:
	var material: Material = debug_mesh.get_surface_override_material(0)
	if use_stencil:
		material.set("stencil_color", color)
	else:
		material.set("albedo_color", color)


func _set_debug_color(color: Color) -> void:
	debug_mesh.get_surface_override_material(0).set("albedo_color", color)


func _update_time_display() -> void:
	time_label.text = " %.2f s" % death_timer.time_left


# Player interaction


func On_Player_Aimed_At_Me(Jogador_Reference: Jogador):
	symptoms_label.show()
	outline_meshes.show()
	
	
	if not Jogador_Reference.player_ui.Player_Selected_Medicine.is_connected(_on_medicine_given):
		Jogador_Reference.player_ui.Player_Selected_Medicine.connect(_on_medicine_given)

func On_Player_Stopped_Aiming_At_Me(Jogador_Reference: Jogador):
	symptoms_label.hide()
	outline_meshes.hide()
	
	if Jogador_Reference.player_ui.Player_Selected_Medicine.is_connected(_on_medicine_given):
		Jogador_Reference.player_ui.Player_Selected_Medicine.disconnect(_on_medicine_given)

func Isolate_on_Inspection():
	$Goblin/Cube.set_layer_mask_value(6,true)
	$Goblin/Cube_002.set_layer_mask_value(6,true)
	$Goblin/Retopo_Cube_001.set_layer_mask_value(6,true)
	$Goblin/Cube_001.set_layer_mask_value(6,true)
	$Goblin/Sphere.set_layer_mask_value(6,true)
	$Goblin/Retopo_Cube_002.set_layer_mask_value(6,true)
	$Goblin/Sphere_001.set_layer_mask_value(6,true)
	
	
func Reset_Character_on_Inspection():
	
	#$Goblin/Cube.set_layer_mask_value(6,true)
	#$Goblin/Cube_002.set_layer_mask_value(6,true)
	#$Goblin/Retopo_Cube_001.set_layer_mask_value(6,true)
	#$Goblin/Cube_001.set_layer_mask_value(6,true)
	#$Goblin/Sphere.set_layer_mask_value(6,true)
	#$Goblin/Retopo_Cube_002.set_layer_mask_value(6,true)
	#$Goblin/Sphere_001.set_layer_mask_value(6,true)
	
	$Goblin/Cube.set_layer_mask_value(6,false)
	$Goblin/Cube_002.set_layer_mask_value(6,false)
	$Goblin/Retopo_Cube_001.set_layer_mask_value(6,false)
	$Goblin/Cube_001.set_layer_mask_value(6,false)
	$Goblin/Sphere.set_layer_mask_value(6,false)
	$Goblin/Retopo_Cube_002.set_layer_mask_value(6,false)
	$Goblin/Sphere_001.set_layer_mask_value(6,false)
	





# Timer callbacks
func start_kill_timer() -> void:
	kill_timer.start()


func _on_kill_timer_timeout() -> void:
	queue_free()


func _on_death_timer_timeout() -> void:
	ScoreManager.Score_de_Insatisfacao += TIMEOUT_PENALTY
	_set_debug_color(Color(0.88, 0.437, 0.153))
	_go_home()
