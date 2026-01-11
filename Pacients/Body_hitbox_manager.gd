extends Node3D


@onready var pacient_instance: Paciente = $"../.."


func _on_Moused_Entered_Head_Hitbox():
	
	#if pacient_instance.is_Character_being_Inspected:
	
		print("Head Hitbox Being Hovered")
	
	
func _on_Moused_Entered_Torso_Hitbox():
	
	#if pacient_instance.is_Character_being_Inspected:
	
		print("Torso Hitbox Being Hovered")
	
	
func _on_Moused_Entered_Arms_Hitbox():
	
	#if pacient_instance.is_Character_being_Inspected:
	
		print("Arms Hitbox Being Hovered")
	
func _on_Moused_Entered_Legs_Hitbox():
	
	#if pacient_instance.is_Character_being_Inspected:
	
		print("Legs Hitbox Being Hovered")
	
