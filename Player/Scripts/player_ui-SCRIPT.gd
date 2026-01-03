extends Control

signal Player_Selected_Medicine(Medicine_Name: String)

@onready var glossario_resumo: Array[String]
@onready var indice: GridContainer = $Indice

@onready var book_ui: Control = $Book_UI
var is_Booking_Showing: bool = false


var Local_Sickness_DB: Array
var Local_Remedios_DB: Array

var Local_RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var Choosen_Disease: Doenca


@onready var tempo_total: Label = $"Tempo Total"
var Total_Time: float = 0.0


@onready var score: Label = $Score



@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
		
		
	if Input.is_action_just_pressed("Book_Key"):
		
		if is_Booking_Showing:
			
			book_ui.close.pressed.emit()
			indice.hide()
			
			
		else:
			book_ui.Open_Book()
			is_Booking_Showing = true
			
			indice.show()
			
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		

func _on_Book_Closed():
	is_Booking_Showing = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




func _ready() -> void:
	
	book_ui.close.pressed.connect(_on_Book_Closed)
	
	
	
	Local_Sickness_DB = SicknessManager.Doencas_DB
	Local_Remedios_DB = SicknessManager.Remedios_DB
	#glossario_resumo.text = ""
	
	Load_Remedios_Nomes()
	
	
	Write_Diseases()
	book_ui.Glossario_de_Doencas = glossario_resumo
	
	
	
func _process(delta: float) -> void:
	
	Total_Time += delta
	tempo_total.text = "%.2f" % Total_Time
	
	score.text = "%d / %d" % [ScoreManager.Total_de_Acertos,ScoreManager.Total_de_Tentativas]
	
	
	
	
	
func Load_Remedios_Nomes():
	
	for i in range(Local_Remedios_DB.size()):
		var Temporary_Button: Button = indice.get_child(i)
		Temporary_Button.pressed.connect(_on_Remedio_Clicked.bind(Temporary_Button.text))
		
		
	
	
	
	
	
	
func _on_Remedio_Clicked(Remedio_Name: String):
	
	ScoreManager.Total_de_Tentativas += 1
	
	var Selected_Remedio: StringName = Remedio_Name
	Player_Selected_Medicine.emit(Remedio_Name)
	
	
	
	
func Write_Diseases():
	for i in range(11):
		
		var Temporary_Text: String = ""
	#
		Temporary_Text += Local_Sickness_DB[i].Disease_Name + " : \n"
	#
		Temporary_Text += "Sintomas -> "
		#
		for meu_sintoma in Local_Sickness_DB[i].List_of_Symptons:
			Temporary_Text  += meu_sintoma.Symptom_Name + "  "
			#
		Temporary_Text += "\n"
		
		Temporary_Text  += "Tratamentos -> "
		#
		for minhas_curas in Local_Sickness_DB[i].Possible_Cure:
			Temporary_Text  += minhas_curas.Treatment_Name + "  "
			
		Temporary_Text  += "\n"
		Temporary_Text  += "\n"
		
		glossario_resumo.append(Temporary_Text)
		
	
