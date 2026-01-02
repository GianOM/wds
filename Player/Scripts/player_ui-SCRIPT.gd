extends Control

@onready var Debug_Symptoms: RichTextLabel = $Symptoms

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
var Total_de_Tentativas: int = 0
var Total_de_Acertos: int = 0



@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
		
		
	if Input.is_action_just_pressed("Book_Key"):
		
		if is_Booking_Showing:
			
			book_ui.close.pressed.emit()
			
			
		else:
			book_ui.Open_Book()
			is_Booking_Showing = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		

func _on_Book_Closed():
	is_Booking_Showing = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




func _ready() -> void:
	
	book_ui.close.pressed.connect(_on_Book_Closed)
	
	
	
	Local_Sickness_DB = SicknessManager.Doencas_DB
	Local_Remedios_DB = SicknessManager.Remedios_DB
	
	Debug_Symptoms.text = ""
	#glossario_resumo.text = ""
	
	Load_Remedios_Nomes()
	Load_Symptoms()
	
	
	Write_Diseases()
	book_ui.Glossario_de_Doencas = glossario_resumo
	
	
	
func _process(delta: float) -> void:
	
	Total_Time += delta
	tempo_total.text = "%.2f" % Total_Time
	
	score.text = "%d / %d" % [Total_de_Acertos,Total_de_Tentativas]
	
	
	



func Load_Symptoms():
	
	var Random_Number: int = Local_RNG.randi_range(0, 10)
	Choosen_Disease = Local_Sickness_DB[Random_Number]
	
	Choosen_Disease.List_of_Symptons.shuffle()
	
	for i in range(Choosen_Disease.List_of_Symptons.size()):
		Debug_Symptoms.text += "Sintoma " + str(i) + " : " + Choosen_Disease.List_of_Symptons[i].Symptom_Name + "\n"
	
	
func Load_Remedios_Nomes():
	for i in range(11):
		
		var Temporary_Button: Button = indice.get_child(i)
		Temporary_Button.pressed.connect(_on_Remedio_Clicked.bind(Temporary_Button.text))
		
		
	

func _on_Revelar_Doenca_button_Pressed():
	Debug_Symptoms.text += "Resultado: " + Choosen_Disease.Disease_Name
	
	
	
func _on_ReRoll_Doenca_button_Pressed():
	Debug_Symptoms.text = ""
	
	Load_Symptoms()
	
	
func _on_Remedio_Clicked(Remedio_Name: String):
	
	Total_de_Tentativas += 1
	
	var Selected_Remedio: StringName = Remedio_Name
	
	for meu_remedio in Choosen_Disease.Possible_Cure:
		if meu_remedio.Treatment_Name == Selected_Remedio:
			
			Total_de_Acertos += 1
			
			_on_ReRoll_Doenca_button_Pressed()
	
	#print(Selected_Remedio)
	
	
	
	
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
		
	
