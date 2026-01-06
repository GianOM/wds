extends Node3D


const PACIENT_INSTANCE = preload("uid://cvog1aa5pvj6s")


@onready var main_office_navigation_zone: NavigationRegion3D = $"../Main_Office_Navigation_Zone"

var RNG_Main: RandomNumberGenerator = RandomNumberGenerator.new()

var Next_Spawn_Point: Vector3

var Main_Nav_Zone_RID: RID 



func _ready() -> void:
	
	Main_Nav_Zone_RID = main_office_navigation_zone.get_rid()
	
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	Next_Spawn_Point = NavigationServer3D.region_get_random_point(Main_Nav_Zone_RID,1,false)
	
	
	
func _on_Spawn_Timer_Timeout():
	
	var New_Pacient: Paciente = PACIENT_INSTANCE.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	add_child(New_Pacient)
	
	
	New_Pacient.global_position = Next_Spawn_Point
	
	New_Pacient.call_deferred("Set_Fila_Target", Vector3(3.397,0.003,-12.448))
	
	
