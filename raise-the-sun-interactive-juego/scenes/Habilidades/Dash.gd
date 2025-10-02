extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Dash"
	tipo=TipoHabilidad.ACT
	descripción="Desplazamiento rápido hacia adelante."

func aplicar(pje):
	pje.can_dash=true

func remover(pje):
	pje.can_dash=false
