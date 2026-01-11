extends Node3D


@onready var Pacient_Root: Paciente = $".."
@onready var camera_3d: Camera3D = $Inspect_Camera
@onready var inpect_ray_cast: RayCast3D = $Inspect_Camera/InpectRayCast



var _rotation_x: float = 0.0
var _rotation_y: float = 0.0

var mouse_rotate_sensitivity: float = 0.2
var mouse_pan_sensitivity: float = 0.0008
var mouse_zoom_sensitivity: float = 0.15

var Right_Click_pan: bool = false
var Left_Click_Rotate: bool = false

var is_Mouse_Over_UI:bool = false
var Last_Mouse_Pos:Vector2 = Vector2.ZERO
var Current_Index_Position: int = 0

var Movement_Tween: Tween

@export var speed: float = 2
var velocity: Vector3 = Vector3.ZERO
var is_Player_in_Free_Camera:bool = false

var is_Player_on_Menu: bool = true
var Can_I_Zoom:bool = false

var can_Player_move: bool = false

var last_mouse_relative: Vector2 = Vector2.ZERO

#func _ready() -> void:
	#Activate_Player()
	
func Activate_Player():
	
	can_Player_move = true
	Can_I_Zoom = true
	camera_3d.make_current()
	
func Deactivate_Player():
	
	
	can_Player_move = false
	Can_I_Zoom = true
	
	
	
	
@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	
	if can_Player_move:
		
		if event is InputEventMouseMotion:
			last_mouse_relative = event.relative
			return
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Left_Click_Rotate = true
			Right_Click_pan = false
			
			
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			
			Left_Click_Rotate = false
			Right_Click_pan = true
			return
			
		
		else:
			Left_Click_Rotate = false
			Right_Click_pan = false
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP) and Can_I_Zoom:
			var Direction_to_Zoom: Vector3 = (camera_3d.global_position - global_position).normalized()
			camera_3d.global_position -= mouse_zoom_sensitivity * Direction_to_Zoom
			
			if camera_3d.global_position.distance_to(self.global_position) < 0.15:
				camera_3d.global_position += mouse_zoom_sensitivity * Direction_to_Zoom
				
			
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN) and Can_I_Zoom:
			var Direction_to_Zoom: Vector3 = (camera_3d.global_position - global_position).normalized()
			camera_3d.global_position += mouse_zoom_sensitivity * Direction_to_Zoom
			
			if camera_3d.global_position.distance_to(self.global_position) > 5.0:
				camera_3d.global_position -= mouse_zoom_sensitivity * Direction_to_Zoom
			
			
			
		
		
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	
	# Checkamos se a camera é a atual para evitar o player mover a camera quando em 1ª Pessoa
	if camera_3d.is_current():
		
		Pacient_Root.symptoms_label.show()
		
		#global_position = playable_character.Inspected_Pacient.global_position + Character_Camera_Offeset
		
		update_raycast_to_mouse()
		
		var Mouse_Position:Vector2 = get_viewport().get_mouse_position()
		var Delta_Mouse_Pos:Vector2 = -last_mouse_relative
		
		
		Last_Mouse_Pos = Mouse_Position
		
		if Left_Click_Rotate or is_Player_in_Free_Camera:
			
			Delta_Mouse_Pos *= mouse_rotate_sensitivity
			
			_rotation_y += Delta_Mouse_Pos.x
			_rotation_x += Delta_Mouse_Pos.y
			
			rotation_degrees = Vector3(_rotation_x, _rotation_y, 0.0)
			
		elif Right_Click_pan:
			
			
			var Right :Vector3 = camera_3d.global_transform.basis.x * mouse_pan_sensitivity
			var Up :Vector3 = camera_3d.global_transform.basis.y * mouse_pan_sensitivity
			
			global_position += Right * Delta_Mouse_Pos.x - Up * Delta_Mouse_Pos.y
			
			
			
		last_mouse_relative = Vector2.ZERO
		
	



	

func update_raycast_to_mouse():
	# Get mouse position on screen
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Project ray from camera through mouse position
	var from = camera_3d.project_ray_origin(mouse_pos)
	var to = from + camera_3d.project_ray_normal(mouse_pos) * 1024
	
	# Set raycast origin and target
	#raycast.global_position = from
	inpect_ray_cast.target_position = inpect_ray_cast.to_local(to)
	
	# Force raycast update
	inpect_ray_cast.force_raycast_update()
	
	# Optional: Check if raycast hit something
	if inpect_ray_cast.is_colliding():
		var collision_point = inpect_ray_cast.get_collision_point()
		var collider = inpect_ray_cast.get_collider()
		print("Hit: ", collider.name, " at ", collision_point)
