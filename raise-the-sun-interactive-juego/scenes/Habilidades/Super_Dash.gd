extends "res://scenes/Habilidades/Habilidad.gd"

func _init():
	nombre="Super Dash"
	descripción="Potente desplazamiento rápido lineal hacia adelante."

func aplicar(pje):
	pje.can_sdash=true

func remover(pje):
	pje.can_sdash=false
