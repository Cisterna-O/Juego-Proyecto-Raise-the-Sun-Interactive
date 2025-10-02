extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Heavy"
	tipo = TipoHabilidad.PAS
	descripción="Aumenta el peso del personaje."

func aplicar(pje):
	pje.peso+=1
	pje.vel-= 50

func remover(pje):
	pje.peso-=1
	pje.vel+=50
