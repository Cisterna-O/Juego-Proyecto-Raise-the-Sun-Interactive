# res://scenes/Door.gd
extends Node2D

@export var required_items: Array = ["level1_A", "level2_B"]
@onready var collider := $CollisionShape2D
@onready var sprite := $Sprite2D

func _ready() -> void:
	# comprobar estado actual (por si ya recogiste antes)
	_check_open()
	# escuchar cambios futuros
	GameState.connect("collected_changed", Callable(self, "_on_collected_changed"))

func _check_open() -> void:
	if GameState.has_all(required_items):
		_open()
	else:
		_close()

func _on_collected_changed(item_id: String, value: bool) -> void:
	_check_open()

func _open() -> void:
	print("Door: open")
	# ejemplo simple: desactivar colisión y animar desaparecer
	if collider:
		collider.disabled = true
	if sprite:
		# puedes animar con Tween/AnimationPlayer, aquí simplemente hide
		sprite.hide()

func _close() -> void:
	print("Door: closed")
	if collider:
		collider.disabled = false
	if sprite:
		sprite.show()
