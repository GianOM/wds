extends Node3D

# Constants
const PACIENT_SCENE = preload("uid://cvog1aa5pvj6s")
const HOME_POSITION: Vector3 = Vector3(-16.587, 0.003, 0.4)

# Node references
@onready var navigation_region: NavigationRegion3D = $"../Main_Office_Navigation_Zone"

# State
var next_spawn_point: Vector3 = Vector3.ZERO
var navigation_rid: RID


@export var fila_path: Path3D
var fila_curve: Curve3D
var fila_points:  PackedVector3Array

var Num_of_Pacients: int = 0

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

@export var Pacients_Spawn_Points: Array[Marker3D]


func _ready() -> void:
	
	fila_curve = fila_path.get_curve()
	fila_points = fila_curve.get_baked_points()
	
	_initialize_navigation()
	_spawn_warmup_patient()
	
	


# Initialization
func _initialize_navigation() -> void:
	navigation_rid = navigation_region.get_rid()


func _spawn_warmup_patient() -> void:
	## Spawns a cached patient to warm up navigation threads
	var patient: Paciente = _create_patient_instance(PackedScene.GEN_EDIT_STATE_DISABLED)
	
	call_deferred("add_child", patient)
	await patient.tree_entered
	
	var this_npc_spawn_point: Vector3 = npc_spawn_point()
	
	patient.global_position = this_npc_spawn_point
	patient.HOME_POSITION = this_npc_spawn_point
	
	
	patient.call_deferred("set_target_position", point_from_curve_index())
	patient.Death_Signal.connect(_on_pacient_freed)
	
	Num_of_Pacients += 1


# Spawn management
func npc_spawn_point() -> Vector3:
	var Spawn_Point_Index: int = RNG.randi_range(0,Pacients_Spawn_Points.size()-1)
	return Pacients_Spawn_Points[Spawn_Point_Index].global_position


func _on_spawn_timer_timeout() -> void:
	_spawn_new_patient()


func _spawn_new_patient() -> void:
	var patient: Paciente = _create_patient_instance()
	
	call_deferred("add_child", patient)
	await patient.tree_entered
	
	var this_npc_spawn_point: Vector3 = npc_spawn_point()
	
	patient.global_position = this_npc_spawn_point
	patient.HOME_POSITION = this_npc_spawn_point
	
	
	patient.call_deferred("set_target_position", point_from_curve_index())
	patient.Death_Signal.connect(_on_pacient_freed)
	
	Num_of_Pacients += 1
	
	
	
func _on_pacient_freed():
	Num_of_Pacients -= 1


# Helper methods
func _create_patient_instance(edit_state: int = PackedScene.GEN_EDIT_STATE_INSTANCE) -> Paciente:
	return PACIENT_SCENE.instantiate(edit_state)
	
func point_from_curve_index() -> Vector3:
	return fila_points[Num_of_Pacients]
	
	
	
	
	
