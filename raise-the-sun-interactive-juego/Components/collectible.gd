# res://scenes/Collectible.gd
extends Area2D

@export var item_id: String = ""      # Ej: "level1_A" o "level2_B"
@export var pickup_sound: AudioStream = null
@onready var sprite := $Sprite2D      # ajusta al nombre real
@onready var collision := $CollisionShape2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	# Evitar recolecciones múltiples locales
	if GameState.has_item(item_id):
		# opcional: reproducir sonido "ya recogido" o desaparecer
		queue_free() # o visible = false
		return

	# reproducir sonido si tienes
	if pickup_sound:
		var p := AudioStreamPlayer2D.new()
		add_child(p)
		p.stream = pickup_sound
		p.play()

	# marcar en el GameState
	GameState.collect(item_id)

	# efecto visual: desactivar colisión y ocultar sprite
	collision.disabled = true
	sprite.visible = false
