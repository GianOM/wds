extends Control


@onready var icon: TextureRect = $Icon
@onready var name_upgrade: Label = $Name
@onready var description: RichTextLabel = $Description
@onready var cancel_button: Button = $CancelButton
@onready var buy_button: Button = $BuyButton

var tween: Tween

var current_upgrade_selected: Upgrade

#Bad Practice
@onready var Player_Ref: Jogador = $"../../.."

func _ready() -> void:
	SignalManager.show_confirmation.connect(show_confirmation)
	SignalManager.description_confirmation.connect(show_description)
	modulate = Color.TRANSPARENT
	hide()
	
	
	#Player_Ref = upgrade_screen_ui.player_ui.Player_Pointer

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		exit_details()

func show_description(upgrade: Upgrade):
	if tween:
		tween.kill()
		
		
	current_upgrade_selected = upgrade
	icon.texture = upgrade.Upgrade_Data_Resource.Upgrade_Icon
	name_upgrade.text = upgrade.Upgrade_Data_Resource.Upgrade_name
	description.text = upgrade.Upgrade_Data_Resource.description
	
	
	Show_Description_UI(false)
	
## If true, then it's purchasable and the buy button should appear
func Show_Description_UI(is_purchasable: bool = true):
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if is_purchasable:
	
		buy_button.show()
		buy_button.disabled = false
		
	else:
		
		buy_button.hide()

func show_confirmation(upgrade: Upgrade):
	if tween:
		tween.kill()
	
	current_upgrade_selected = upgrade
	icon.texture = upgrade.Upgrade_Data_Resource.Upgrade_Icon
	name_upgrade.text = upgrade.Upgrade_Data_Resource.Upgrade_name
	description.text = upgrade.Upgrade_Data_Resource.description
	
	Show_Description_UI()
	
func hide_confirmation():
	buy_button.disabled = true
	if tween:
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(hide)

func exit_details():
	hide_confirmation()
	if current_upgrade_selected and current_upgrade_selected.My_Current_State == Upgrade.Upgrade_State.Bought:
		return
	elif current_upgrade_selected:
		current_upgrade_selected.back_to_normal()
		current_upgrade_selected = null
	else: return

func _on_cancel_button_pressed() -> void:
	exit_details()


func _on_buy_button_pressed() -> void:
	hide_confirmation()
	SignalManager.update_stuff.emit(current_upgrade_selected)
	current_upgrade_selected.upgrade_bought()
	
	
	
	
	current_upgrade_selected.Upgrade_Data_Resource.Apply_on_Player(Player_Ref)
	
	
	
	


func _on_outside_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Left_Click"):
		exit_details()
