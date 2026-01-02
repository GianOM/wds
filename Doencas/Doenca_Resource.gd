class_name Doenca
extends Resource

@export var Disease_Name: StringName

@export_category("Sintomas")
## Possivel quantidade de Sintomas. Exemplo: (3,6) 
## significa que o total de Sintomas Possiveis é entre 3 e 6 Sintomas
@export var Range_of_Symptoms: Vector2i
@export var List_of_Symptons: Array[Sintoma]

@export_category("Tratamentos")
## Possivel quantidade de Curas. Exemplo: (1,3) 
## significa que o total de Tratamentos Possiveis é entre 1 e 3 Sintomas
@export var Range_of_Cures: Vector2i
@export var Possible_Cure: Array[Remedio]
