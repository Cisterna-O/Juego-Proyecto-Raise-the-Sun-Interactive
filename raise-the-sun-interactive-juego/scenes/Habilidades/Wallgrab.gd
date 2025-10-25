extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Wall-grab"
	tipo = TipoHabilidad.ACT
	descripción="Reduce el peso del personaje."

func aplicar(pje):
	pje.can_wall_grab=true

func remover(pje):
	pje.can_wall_grab=false
