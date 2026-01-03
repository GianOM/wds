extends Node3D


const PACIENT_INSTANCE = preload("uid://cvog1aa5pvj6s")

const Minimum_Coordinates_XZ: Vector2 = Vector2(-10.0,0)
const Maximum_Coordinates_XZ: Vector2 = Vector2(10.0,-32)

var RNG_Main: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_Spawn_Timer_Timeout():
	
	print("NEW PACIENT ARRIVED")
	
	var New_Pacient: Paciente = PACIENT_INSTANCE.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(New_Pacient)
	
	var New_Pacient_Spawn_X_Position: float = RNG_Main.randf_range(Minimum_Coordinates_XZ.x,
															Maximum_Coordinates_XZ.x)
															
	var New_Pacient_Spawn_Z_Position: float = RNG_Main.randf_range(Minimum_Coordinates_XZ.y,
															Maximum_Coordinates_XZ.y)
	
	New_Pacient.global_position = Vector3(New_Pacient_Spawn_X_Position, 0.0, New_Pacient_Spawn_Z_Position)
	
