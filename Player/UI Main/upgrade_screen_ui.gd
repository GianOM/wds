extends Control

@onready var player_ui: Control = $".."


@onready var upgrade_button: Upgrade = $UpgradeButton
@onready var stats: Label = $Stats
@onready var upgrade_details_ui: Control = $UpgradeDetailsUI

func _ready() -> void:
	SignalManager.update_stuff.connect(update_stats)
	upgrade_button.My_Current_State = Upgrade.Upgrade_State.Available
	stats.text = ""
	



func update_stats(upgrade: Upgrade):
	stats.text += str(upgrade.Upgrade_Data_Resource.description) + "\n"
