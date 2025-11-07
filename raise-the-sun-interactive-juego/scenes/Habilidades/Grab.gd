extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Grab"
	tipo=TipoHabilidad.ACT
	descripción="Agarre y lanzamiento de bloques."

func aplicar(pje):
	pje.can_grab=true

func remover(pje):
	pje.can_grab=false
