extends Area2D

@export var habilidad_id: String = "peso"
var recogido=false

@onready var sprite: Sprite2D=$Sprite2D
@onready var area:Area2D=self

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	match habilidad_id.to_lower():
		"peso":
			sprite.modulate=Color(0.8,0.6,0.2)
		"light":
			sprite.modulate=Color(0.7,1.0,1.0)
		"dash":
			sprite.modulate=Color(1.0,0.4,0.4)
		_:
			sprite.modulate = Color.WHITE

func _on_body_entered(body):
	if recogido:
		return
	recogido=true
	
	if not body.has_method("equipar_habilidad"):
		return

	var path="res://scenes/Habilidades/%s.gd" % habilidad_id.capitalize()
	var habilidad_script = load(path)
	if not habilidad_script:
		print("no se pudo cargar la habilidad:",path)
		return
	
	var habilidad=habilidad_script.new()
	body.equipar_habilidad(habilidad)
	queue_free()
