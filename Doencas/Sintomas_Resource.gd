class_name Sintoma
extends Resource

enum Body_Part{
	Head,
	Neck,
	Torso,
	Arms,
	Legs
}


@export var Symptom_Name: StringName


## Descricao do Sintoma, caso precise
@export var description: String


## O quao comum sera o Sintoma, sendo 0.0 bem raro de aparecer e 1.0 extremamente comum
@export var Symptoms_Commonality: float

@export var My_Body_Part: Body_Part
