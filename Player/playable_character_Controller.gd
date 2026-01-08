class_name Jogador extends CharacterBody3D

@onready var player_ui: Control = $PlayerUi

@onready var camera_3d: Camera3D = $Camera3D

var Player_Speed: float = 3
const PLAYER_CAMERA_SPEED: float = 0.001

var rot : Vector3
var mouse_axis: Vector2 = Vector2.ZERO

var is_Player_Active: bool = false


@onready var global_position_debug: RichTextLabel = $"Debug UI/Global_Position_Debug"

func _input(event: InputEvent) -> void:
		
	
	if event is InputEventMouseMotion and is_Player_Active:
		# event.relative is the delta since the last mouse motion event
		
		if player_ui.book_ui.is_visible_in_tree() or player_ui.remedio_craft_ui.is_visible_in_tree():
			return
		
		
		mouse_axis = event.relative * PLAYER_CAMERA_SPEED
		handle_Camera_Movement()
		
	
	
func _ready() -> void:
	
	Activate_Player()
	
func Activate_Player():
	
	camera_3d.make_current()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	is_Player_Active = true
	
	
func Deactivate_Player():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	is_Player_Active = false
	
	
	
func Kill_the_Player():
	Deactivate_Player()
	
	
	
	
func _process(delta: float) -> void:
	handle_Player_Movement(delta)
	
	global_position_debug.text = str(global_position)
	
	
	
	
	
func handle_Player_Movement(Delta_Time: float):
	
	if is_Player_Active:
		var Input_Direction = Input.get_vector("Left_Key","Right_Key","Forward_Key","Back_Key")
		
		var movement_direction = (transform.basis * Vector3(Input_Direction.x ,0,Input_Direction.y) ).normalized()
		
		if not is_on_floor():
			velocity.y -= 9.8 * Delta_Time
			#print("Im not on floor")
		
		velocity.x = movement_direction.x * Player_Speed
		velocity.z = movement_direction.z * Player_Speed
		
		move_and_slide()
		
		
		
func handle_Camera_Movement():
	
	camera_3d.rotation.x -= mouse_axis.y
	camera_3d.rotation.x = clamp(camera_3d.rotation.x, -1.5, 1.5)
	
	rotation.y -= mouse_axis.x
	
	
	
