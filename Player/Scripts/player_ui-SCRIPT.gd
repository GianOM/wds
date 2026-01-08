extends Control

signal Player_Selected_Medicine(Medicine_Name: String)

@onready var glossario_resumo: Array[String]
@onready var indice: GridContainer = $Indice

@onready var book_ui: Control = $Book_UI


var Local_Sickness_DB: Array
var Local_Remedios_DB: Array

var Local_RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var Choosen_Disease: Doenca


@onready var tempo_total: Label = $"In_Game_Metrics/Tempo Total"
var Total_Time: float = 0.0


@onready var score: Label = $In_Game_Metrics/Score
@onready var dinheiro_total: Label = $In_Game_Metrics/Dinheiro_Total
@onready var insatisfacao_total: Label = $In_Game_Metrics/Insatisfacao_Total

@onready var remedio_craft_ui: Control = $RemedioCraftUI
@onready var in_game_metrics: Control = $In_Game_Metrics


@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
		
		
	if Input.is_action_just_pressed("Book_Key"):
		
		if remedio_craft_ui.is_visible_in_tree():
			remedio_craft_ui.hide()
		
		
		Load_Remedios_Nomes()
		
		if book_ui.is_visible_in_tree():
			
			
			book_ui.hide()
			book_ui.close.pressed.emit()
			indice.hide()
			
			
		else:
			
			
			book_ui.show()
			book_ui.Open_Book()
			indice.show()
			
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	elif Input.is_action_just_pressed("Recipe_Book_Key"):
		
		if book_ui.is_visible_in_tree():
			book_ui.hide()
			book_ui.close.pressed.emit()
			indice.hide()
		
		if remedio_craft_ui.is_visible_in_tree():
			remedio_craft_ui.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		else:
			remedio_craft_ui.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		

func _on_Book_Closed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func Show_Recipes():
	remedio_craft_ui.show()
	in_game_metrics.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func Hide_Recipes():
	remedio_craft_ui.hide()
	in_game_metrics.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	
	
func _ready() -> void:
	
	
	book_ui.close.pressed.connect(_on_Book_Closed)
	
	Local_Sickness_DB = SicknessManager.Doencas_DB
	Local_Remedios_DB = SicknessManager.Remedios_DB
	#glossario_resumo.text = ""
	
	Load_Remedios_Nomes()
	
	
	Write_Diseases()
	book_ui.Glossario_de_Doencas = glossario_resumo
	
	
	dinheiro_total.text = "Money: $ " + str(ScoreManager.Dinheiro_Total)
	insatisfacao_total.text = "Insatisfacao : " + str(ScoreManager.Score_de_Insatisfacao) + " / 300"
	
	
func _process(delta: float) -> void:
	
	Total_Time += delta
	tempo_total.text = "%.2f" % Total_Time
	
	score.text = "%d / %d" % [ScoreManager.Total_de_Acertos,ScoreManager.Total_de_Tentativas]
	
	dinheiro_total.text = "Money: $ " + str(ScoreManager.Dinheiro_Total)
	insatisfacao_total.text = "Insatisfacao : " + str(ScoreManager.Score_de_Insatisfacao) + " / 300"
	
	
	
func Load_Remedios_Nomes():
	
	for i in range(Local_Remedios_DB.size()):
		var Temporary_Button: Button = indice.get_child(i)
		
		var Temp_Remedio: Remedio = Local_Remedios_DB[i]
		
		Temporary_Button.text = "%s x%d" % [Temp_Remedio.Treatment_Name, Temp_Remedio.Quantidade]
		
		if Temp_Remedio.Quantidade < 1:
			Temporary_Button.disabled = true
		else:
			Temporary_Button.disabled = false
		
		
		
		if not Temporary_Button.pressed.is_connected(_on_Remedio_Clicked):
			Temporary_Button.pressed.connect(_on_Remedio_Clicked.bind(Temp_Remedio.Treatment_Name))
		
	
	
	
func _on_Remedio_Clicked(Remedio_Name: String):
	
	ScoreManager.Total_de_Tentativas += 1
	
	#var Selected_Remedio: StringName = Remedio_Name
	Player_Selected_Medicine.emit(Remedio_Name)
	
	Subtrai_Unidade_de_Remedio(Remedio_Name)
	Load_Remedios_Nomes()
	
	
func Subtrai_Unidade_de_Remedio(Remedio_Name: String):
	
	for meu_remedio in Local_Remedios_DB:
		if meu_remedio.Treatment_Name == Remedio_Name:
			meu_remedio.Quantidade -= 1
			
			SicknessManager.Quantidade_de_Remedio_Changed.emit()
			
			return
			
	
	
func Write_Diseases():
	for i in range(11):
		
		var Temporary_Text: String = ""
	#
		Temporary_Text += "[b]%s[/b]\n" % Local_Sickness_DB[i].Disease_Name
	#
		#Temporary_Text += "Sintomas -> "
		#
		for meu_sintoma in Local_Sickness_DB[i].List_of_Symptons:
			Temporary_Text  += "[ul]%s[/ul]\n" % meu_sintoma.Symptom_Name
			
		Temporary_Text  += "\n"
		
		glossario_resumo.append(Temporary_Text)
		
	
