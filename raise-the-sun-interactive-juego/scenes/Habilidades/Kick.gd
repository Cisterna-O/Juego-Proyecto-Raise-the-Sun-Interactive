extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Kick"
	tipo=TipoHabilidad.ACT
	descripción="Combinación Grab + Dash. Personaje patea bloque agarrado."

func aplicar(pje):
	print("Agarramos y pateamos")
	pje.can_kick=true

func remover(pje):
	print("Removiendo Kick")
	pje.can_kick=false
