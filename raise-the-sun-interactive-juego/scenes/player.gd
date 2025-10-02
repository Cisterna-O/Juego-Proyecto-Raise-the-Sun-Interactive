class_name Player
extends CharacterBody2D

@export var max_speed = 200
@export var jump_speed = 200
@export var gravity = 500
@export var acceleration = 1000
var peso: float=1
var can_dash: bool=false
var is_dashing: bool=false
var dash_timer: float=0
const dash_dura:= 0.2
const dash_speed:= 600
const dash_cooldown:= 0.5
var dash_cooldown_timer: float=0

var habilidades: Array=[]
const max_habilities:=2


var was_on_floor = false
var is_dead := false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	#coyote_timer.timeout.connect(_on_coyote_timeout)
	#for hitbox in get_tree().get_nodes_in_group("Hitboxes"):
	#	hitbox.damage_dealt.connect(_on_damage_dealt) 
	pass

func equipar_habilidad(habilidad:Habilidad):
	if habilidades.size() >= max_habilities:
		print("El que mucho abarca, poco aprieta (Austin 3:18)")
		return
	habilidades.append(habilidad)
	habilidad.aplicar(self)

func remover_habilidad(habilidad:Habilidad):
	habilidad.remover(self)
	habilidades.erase(habilidad)

func tiene_habilidad(nombre_habilidad:String):
	for h in habilidades:
		if h.nombre == nombre_habilidad:
			return true
	return false

func start_dash(move_input:float):
	is_dashing=true
	dash_timer=dash_dura
	can_dash=false
	
	#Dirección del dash
	var direction= sign(move_input)
	if direction==0:
		direction=sign(sprite_2d.scale.x)
	velocity.x=direction*dash_speed

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 
	if (is_on_floor() ) and Input.is_action_just_pressed("jump"): #or not coyote_timer.is_stopped()

		velocity.y = -jump_speed
		was_on_floor = false
		
	var move_input: float = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("skill") and can_dash:
		start_dash(move_input)
	if is_dashing:
		dash_timer-=delta
		if dash_timer<=0:
			is_dashing=false
			dash_cooldown_timer=dash_cooldown
	
	#if ray_cast_2d.is_colliding():
		
	#if was_on_floor and not is_on_floor():
	#	coyote_timer.start()
	#if is_on_floor():
	#	coyote_timer.stop()
	was_on_floor = is_on_floor()
	
	#animation

#	if is_on_floor():
#		if move_input:
#			pivot.scale.x = sign(move_input)
	
#		if move_input or (velocity.x) > 10:
#			playback.travel("run")
#		else:
#			playback.travel("idle")	
			
#	else:
#		if velocity.y < 0:
#			playback.travel("jump")	
#		else:
#			playback.travel("fall")
			
			
#func take_damage(damage):
#	if is_dead: return
#	is_dead = true

#	sprite.visible = false
#	collision_main.disabled = true
#	collision_hitbox.disabled = true
#	collision_hurtbox.disabled = true

#	audio_death_player.play()
#	audio_death_player.finished.connect(_on_death_finished, CONNECT_ONE_SHOT)

func _on_death_finished():
	queue_free()

func _on_damage_dealt():
	velocity.y = -jump_speed
#	audio_jump_player.play()



			
func _on_coyote_timeout():	
	pass
