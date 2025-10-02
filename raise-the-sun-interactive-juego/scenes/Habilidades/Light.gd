extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Light"
	tipo = TipoHabilidad.PAS
	descripción="Reduce el peso del personaje."

func aplicar(pje):
	pje.peso-=1
	pje.vel+=50
	pje.gravity*=0.7

func remover(pje):

	pje.peso+=1
	pje.vel-= 50
	pje.gravity/=0.7
