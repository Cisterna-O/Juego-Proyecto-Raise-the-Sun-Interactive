class_name Plataforma
extends StaticBody2D

@export_enum("normal","pesado","superpesado","impenetrable","ligero") var tipo:String="normal"
@export var gravity: float=500
var peso_bloque: int=1
@onready var collider: CollisionShape2D=$CollisionShape2D
var held: bool=false
var player_on_top:Player=null
@onready var sprite: Sprite2D=$Normal

func _ready() -> void:
	add_to_group("plataformas")
	config_platform()

func config_platform() -> void:
	match tipo:
		"normal":
			peso_bloque=1
			sprite.modulate=Color(0,0.6,1)
		"pesado":
			peso_bloque=2
			sprite.modulate=Color(0.5,0.2,0)
		"superpesado":
			peso_bloque=3
			sprite.modulate=Color(0.5,0.5,0.5)
		"impenetrable":
			peso_bloque=4
			sprite.modulate=Color(0.2,0.2,.2)
		"ligero":
			peso_bloque=0
			sprite.modulate=Color(1,1,1)

func _on_top_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player_on_top=body


func _on_top_detector_body_exited(body: Node2D) -> void:
	if body == player_on_top:
		player_on_top=null

func _physics_process(delta: float) -> void:
	if player_on_top and player_on_top.peso>peso_bloque:
		print("Bloque cede")
		queue_free()
	else:
		return
