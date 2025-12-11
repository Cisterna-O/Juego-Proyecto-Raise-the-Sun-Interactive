extends Node2D

@export var required_items: Array = ["level1_A", "level2_B"]
@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var collider := $StaticBody2D/CollisionShape2D
@onready var sprite := $Sprite2D

func _ready():
	print("[Door] READY")
	print("[Door] Required items: ", required_items)

	_check_open()
	GameState.connect("collected_changed", Callable(self, "_on_collected_changed"))
	print("[Door] Collider: ", collider)
	print("[Door] Sprite: ", sprite)

func _on_collected_changed(item_id: String, value: bool):
	print("[Door] Collected changed → item: ", item_id, " value: ", value)
	_check_open()

func _check_open():
	print("[Door] Checking items...")

	if GameState.has_all(required_items):
		print("[Door] All required items present → OPENING DOOR")
		_open()
	else:
		print("[Door] Missing items → CLOSING DOOR")
		_close()

func _open():
	collider.set_deferred("disabled", true)
	sprite.visible = false
	print("[Door] Door is now OPEN")

func _close():
	collider.set_deferred("disabled", false)
	sprite.visible = true
	print("[Door] Door is now CLOSED")
