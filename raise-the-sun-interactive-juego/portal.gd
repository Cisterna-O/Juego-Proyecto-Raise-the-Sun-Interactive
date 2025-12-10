extends Node2D

@export var target_scene_path: String = ""    # ej: "res://levels/level1.tscn"
@export var target_spawn_name: String = ""    # ej: "spawn_from_central_A"
@export var portal_id: String = ""            # ej: "central_A"

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
		
	print("✓ Es el jugador, intentando teletransportar...")

	SceneTransition.request_transition(
		target_scene_path,
		target_spawn_name,
		portal_id
	)
