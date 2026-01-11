extends TextureButton
class_name Upgrade

enum Upgrade_State {
	Unavailable,
	Available,
	Bought
}


@onready var line_2d: Line2D = $Line2D

@export var Upgrade_Data_Resource: Player_Upgrade


var My_Current_State: Upgrade_State = Upgrade_State.Unavailable

func _ready():
	var children = get_children()
	for i in children.size():
		if children[i] is Upgrade:
			line_2d.add_point(global_position + size/2)
			line_2d.add_point(get_child(i).global_position + size/2)


func back_to_normal():
	modulate = Color(0.259, 0.259, 0.259)
	line_2d.default_color = Color(0.271, 0.271, 0.271)
	
func upgrade_bought():
	
	
	
	My_Current_State = Upgrade_State.Bought
	var children = get_children()
	for i in children.size():
		if children[i] is not Line2D:
			children[i].My_Current_State = Upgrade_State.Available

func _on_pressed() -> void:
	if My_Current_State == Upgrade_State.Unavailable:
		print("requires previous upgrade")
		return
		
	if My_Current_State == Upgrade_State.Bought:
		SignalManager.description_confirmation.emit(self)
	elif My_Current_State == Upgrade_State.Available:
		modulate = Color.WHITE
		line_2d.default_color = Color(1, 1, 1, 1.0)
		SignalManager.show_confirmation.emit(self)
