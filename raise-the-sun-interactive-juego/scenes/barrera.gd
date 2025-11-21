extends StaticBody2D
@export var req_peso_min: float=2
@export var req_dash: bool=true

func take_damage(dmg):
	print("crac!")
	queue_free()

func _on_body_entered(body):
	if not body.has_method("tiene_habilidad"):
		return
	if not (body is Player):
		return
	var tiene_dash=body.tiene_habilidad("Dash")
	var ta_dasheando=body.is_dashing
	var tiene_peso=body.peso >= req_peso_min
	if req_dash and tiene_dash and ta_dasheando and tiene_peso:
		queue_free()
