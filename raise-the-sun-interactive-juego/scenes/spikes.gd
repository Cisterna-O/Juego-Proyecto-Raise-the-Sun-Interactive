extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		print("Se murio")
		get_tree().reload_current_scene()
