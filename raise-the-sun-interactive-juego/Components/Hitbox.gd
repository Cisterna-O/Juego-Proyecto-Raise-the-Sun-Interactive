class_name Hitbox
extends Area2D

signal damage_dealt

@export var damage = 10

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area:Area2D):
	var hurtbox = area as Hurtbox
	if not hurtbox:
		return
	var player= owner as CharacterBody2D
	if not player:
		return
	if player.velocity.y>0 and player.global_position.y < hurtbox.global_position.y:
		print("pato pisó")
		player.velocity.y= -player.jump_speed*0.7
		if hurtbox.owner and hurtbox.owner.has_method("take_damage"):
			hurtbox.owner.take_damage(damage)
