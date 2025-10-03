extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Heavy"
	tipo = TipoHabilidad.PAS
	descripción="Aumenta el peso del personaje."

func aplicar(pje):
	pje.peso+=1
	pje.max_speed-= 100
	pje.gravity/=0.7

func remover(pje):
	pje.peso-=1
	pje.max_speed+=100
	pje.gravity*=0.7
