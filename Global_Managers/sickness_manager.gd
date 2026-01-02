extends Node

signal Diseases_Loaded


var DOENCAS_FOLDER_PATH: String = "res://Doencas/Doencas_Database/"
var REMEDIOS_FOLDER_PATH: String = "res://Doencas/Remedios_Database/"
var SINTOMAS_FOLDER_PATH: String = "res://Doencas/Sintomas_Database/"


var Doencas_DB: Array
var Remedios_DB: Array
var Sintomas_DB: Array


func Load_Resources_into_Array(folder_path: String) -> Array:
	
	var resources: Array = []
	var dir :DirAccess = DirAccess.open(folder_path)
	
	
	if dir == null:
		push_error("Failed to open directory: " + folder_path)
		return resources
		
		
	for file_name in dir.get_files():
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var full_path = folder_path + "/" + file_name
			var res = load(full_path)
			if res:
				resources.append(res)
	return resources
	
	
	
func Retorna_Index_do_Sintoma(Lista_de_Sintomas: Array) -> int:
	
	var Peso_Total_dos_Sintomas: float = 0.0
	for sintoma in Lista_de_Sintomas:
		Peso_Total_dos_Sintomas += sintoma.Symptoms_Commonality
	
	var Decider_RNG: RandomNumberGenerator = RandomNumberGenerator.new()
	var Random_Float: float = Decider_RNG.randf_range(0, Peso_Total_dos_Sintomas)
	
	var i: int = 0
	
	while true:
		Random_Float -= Lista_de_Sintomas[i].Symptoms_Commonality
		
		if Random_Float <= 0.0:
			break
		else:
			i += 1
		
	return i
	
	
func Montar_Possiveis_Doencas() -> void:
	
	var remedio_iter: int = 0
	var Decider_RNG: RandomNumberGenerator = RandomNumberGenerator.new()
	
	
	
	for minha_doenca in Doencas_DB:
		
		var Local_Symptoms_Copy: Array = Sintomas_DB.duplicate(true)
		Local_Symptoms_Copy.shuffle()
		# numero de sintomas é definido pela Classe Doenca
		for i in range(Decider_RNG.randi_range(minha_doenca.Range_of_Symptoms.x, minha_doenca.Range_of_Symptoms.y)):
			
			var Clamped_Index: int = Retorna_Index_do_Sintoma(Local_Symptoms_Copy)
			Clamped_Index = clampi(Clamped_Index, 0, Local_Symptoms_Copy.size()-1)
			
			var Temp_Sintoma: Sintoma = Local_Symptoms_Copy.pop_at(Clamped_Index)
			minha_doenca.List_of_Symptons.append(Temp_Sintoma)
			
			
			
			
			
		# numero de tratamentos é definido pela Classe Doenca
		for j in range(Decider_RNG.randi_range(minha_doenca.Range_of_Cures.x, minha_doenca.Range_of_Cures.y)):
			
			minha_doenca.Possible_Cure.append(Remedios_DB[remedio_iter])
			
			if (remedio_iter+1) == Remedios_DB.size():
				remedio_iter = 0
				continue
				
			remedio_iter += 1
		
		
		
	
func _ready() -> void:
	
	Doencas_DB = Load_Resources_into_Array(DOENCAS_FOLDER_PATH)
	Remedios_DB = Load_Resources_into_Array(REMEDIOS_FOLDER_PATH)
	Sintomas_DB = Load_Resources_into_Array(SINTOMAS_FOLDER_PATH)
	
	#Doencas_DB.shuffle()
	Remedios_DB.shuffle()
	Sintomas_DB.shuffle()
	
	
	Montar_Possiveis_Doencas()
	
	Diseases_Loaded.emit()
	
	
