extends Node


## 1 kill  = +60
## 1 Paciente nao atendido = +20
## 300 = Game Over
var Score_de_Insatisfacao: int = 0


var Dinheiro_Total: int = 0

var Total_de_Tentativas: int = 0
var Total_de_Acertos: int = 0




func Calcular_Recompensa_pela_Doenca_Curada(Doenca_de_Entrada: Doenca):
	
	
	Dinheiro_Total += Doenca_de_Entrada.List_of_Symptons.size()*10
	Total_de_Acertos += 1
	
	
	pass
