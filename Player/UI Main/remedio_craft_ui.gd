extends Control


@onready var v_box_de_remedios: VBoxContainer = $VBox_de_Remedios
var Lista_Local_de_Remedios: Array


@onready var ingredients_title: Label = $"Ingredient_List/Ingredients Title"

@onready var ingredient_list: RichTextLabel = $Ingredient_List
@onready var held_vs_required_text: RichTextLabel = $Ingredient_List/Held_vs_Required_Text
@onready var make_remedio_button: Button = $"Ingredient_List/Make Remedio Button"



var Current_Remedio_Index: int


@onready var doencas_trataveis: RichTextLabel = $Ingredient_List/Doencas_Trataveis

func _ready() -> void:
	
	Lista_Local_de_Remedios = SicknessManager.Remedios_DB
	
	SicknessManager.Quantidade_de_Remedio_Changed.connect(Inicializar_Lista_de_Remedios)
	Inicializar_Lista_de_Remedios()
	
	
	
	
func Inicializar_Lista_de_Remedios():
	
	for i in range(Lista_Local_de_Remedios.size()):
		var Temp_Button: Button = v_box_de_remedios.get_child(i)
		Temp_Button.text = "%s   x%d" % [Lista_Local_de_Remedios[i].Treatment_Name, Lista_Local_de_Remedios[i].Quantidade]
		
		
		if not Temp_Button.pressed.has_connections():
			Temp_Button.pressed.connect(_on_Remedio_Clicked.bind(i))
		
		
		
func _on_Remedio_Clicked(Remedio_Index: int):
	
	
	
	Current_Remedio_Index = Remedio_Index
	var Remedio_Selected: Remedio = Lista_Local_de_Remedios[Remedio_Index]
	
	
	ingredients_title.text = Remedio_Selected.Treatment_Name + " Ingredients: "
	
	var Lista_de_Remedios: String = ""
	var Quantidade_de_Remedios: String = ""
	var Doencas_Tratadas_Pelo_Remedio: String = ""
	#
	for minha_doenca in Remedio_Selected.Lista_de_Doencas:
		Doencas_Tratadas_Pelo_Remedio  += "[color=green][i]%s[/i][/color]\n" % minha_doenca
		
		
	doencas_trataveis.text = Doencas_Tratadas_Pelo_Remedio
	
	
	Enable_Craft_Button()
	
	for i in range(Remedio_Selected.Lista_de_Ingredientes.size()):
		
		var Qnt_Ingrediente: int = Remedio_Selected.Lista_de_Ingredientes[i].Quantidade
		
		#Quantidade_de_Remedios += "x" + str(Qnt_Ingrediente) + " / x1"
		#Quantidade_de_Remedios += "\n"
		
		if Qnt_Ingrediente < 1:
		
			Lista_de_Remedios += "[color=red]%s[/color]" % Remedio_Selected.Lista_de_Ingredientes[i].Ingredient_Name
			Lista_de_Remedios += "\n"
			
			Quantidade_de_Remedios += "[color=red]x%d / x1[/color]" % Qnt_Ingrediente
			Quantidade_de_Remedios += "\n"
			
			Disable_Craft_Button()
			
		else:
			
			Lista_de_Remedios += "[color=green]%s[/color]" % Remedio_Selected.Lista_de_Ingredientes[i].Ingredient_Name
			Lista_de_Remedios += "\n"
			
			Quantidade_de_Remedios += "[color=green]x%d / x1[/color]" % Qnt_Ingrediente
			Quantidade_de_Remedios += "\n"
		
		
	ingredient_list.text = Lista_de_Remedios
	held_vs_required_text.text = Quantidade_de_Remedios
	
	ingredient_list.show()
	
	
	
func _on_Craft_Button_Pressed():
	
	var Remedio_Crafted: Remedio = Lista_Local_de_Remedios[Current_Remedio_Index]
	
	Lista_Local_de_Remedios[Current_Remedio_Index].Quantidade += 1
	
	for meu_ingrediente in Remedio_Crafted.Lista_de_Ingredientes:
		
		meu_ingrediente.Quantidade -= 1
		
	
	
	
	# Atualiza a UI com os novos valores
	Inicializar_Lista_de_Remedios()
	_on_Remedio_Clicked(Current_Remedio_Index)
	
	
func Enable_Craft_Button():
	make_remedio_button.disabled = false
	
func Disable_Craft_Button():
	make_remedio_button.disabled = true
	
		
		
