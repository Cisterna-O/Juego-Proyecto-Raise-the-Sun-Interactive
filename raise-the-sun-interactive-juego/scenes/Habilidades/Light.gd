extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Light"
	tipo = TipoHabilidad.PAS
	descripción="Reduce el peso del personaje."

func aplicar(pje):
	pass
	#pje.peso-=1
	#pje.max_speed+=100
	#pje.gravity*=0.7

func remover(pje):
	pass
	#pje.peso+=1
	#pje.max_speed-= 50
	#pje.gravity/=0.7
