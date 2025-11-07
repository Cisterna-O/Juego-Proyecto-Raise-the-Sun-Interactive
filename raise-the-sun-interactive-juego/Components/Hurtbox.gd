class_name Hurtbox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	var hitbox = area as Hitbox
	if not hitbox:
		return
	var player = owner
	if player and player.has_method("take_damage"):
		player.take_damage(hitbox.damage)
