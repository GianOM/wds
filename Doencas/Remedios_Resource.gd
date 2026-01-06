class_name Remedio
extends Resource


@export var Treatment_Name: StringName


@export var Quantidade: int = 0

## Lista_das_Doencas que este remedio trata. Precisamos saber destes valores
## para que na criação do Crafting, ele possa retornar pra nos
@export var Lista_de_Doencas: Array[StringName] 



@export_category("Ingredientes")
## Possivel quantidade de Ingredientes. Exemplo: (1,3) 
## significa que o total de Ingredientes Possiveis é entre 1 e 3 Sintomas
@export var Range_de_Ingredientes: Vector2i
@export var Lista_de_Ingredientes: Array[Ingrediente] # Lista de Ingredientes para fabricar o Remedio
