extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Wall-grab"
	descripción="Personaje se aferra y trepa la pared."

func aplicar(pje):
	pje.can_wall_grab=true

func remover(pje):
	pje.can_wall_grab=false
