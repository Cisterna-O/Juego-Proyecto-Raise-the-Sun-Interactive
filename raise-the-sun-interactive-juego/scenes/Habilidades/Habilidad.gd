extends Resource
class_name Habilidad

enum TipoHabilidad {ACT,PAS}

@export var nombre: String
@export var tipo: TipoHabilidad
@export var descripción: String
@export var es_fusion: bool=false

func aplicar(pje):
	pass

func  remover(pje):
	pass
